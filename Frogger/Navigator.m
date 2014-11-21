//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "Globals.h"
#import "Navigator.h"

@interface Navigator () <CLLocationManagerDelegate>

@property (nonatomic, assign, readwrite) Boolean                 calibrating;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D  startPosition;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D  deviceCoordinate;
@property (nonatomic, assign, readwrite) CLLocationDistance      deviceAltitude;
@property (nonatomic, assign, readwrite) CLLocationDirection     deviceDirection;

@property (nonatomic, strong) CLLocationManager    *locationManager;
@property (nonatomic, strong) NSTimer              *calibrationTimer;
@property (atomic,    assign) CLLocationDistance   calibrationDelta;

@end

@implementation Navigator

@synthesize startPosition = _startPosition;
@synthesize deviceCoordinate = _deviceCoordinate;
@synthesize deviceAltitude = _deviceAltitude;
@synthesize deviceDirection = _deviceDirection;
@synthesize locationManager = _locationManager;

+ (Navigator *)sharedNavigator
{
    static dispatch_once_t onceToken;
    static Navigator *navigator;

    dispatch_once(&onceToken, ^{
        navigator = [[Navigator alloc] init];
    });

    return navigator;
}

#pragma mark - Object cunstructors/destructors

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;

    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [self.locationManager setHeadingFilter:2.0f];
    [self.locationManager setDelegate:self];

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    self.startPosition = [[self.locationManager location] coordinate];

    self.deviceCoordinate = [[self.locationManager location] coordinate];
    self.deviceAltitude = [[self.locationManager location] altitude];
    self.deviceDirection = [[self.locationManager heading] trueHeading];

    return self;
}

#pragma mark - Navigation activation/deactivation

- (void)startNavigation
{
    [self.locationManager startUpdatingHeading];
    [self.locationManager startUpdatingLocation];
}

- (void)stopNavigation
{
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Calibration

- (void)calibrate
{
#ifdef DEBUG
    if (self.calibrationDelegate != nil)
        [self.calibrationDelegate navigatorDidCompleteCalibration];
    return;
#endif

    self.calibrating       = YES;
    self.calibrationDelta  = 0;

    self.calibrationTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                             target:self
                                                           selector:@selector(checkCalibration)
                                                           userInfo:nil
                                                            repeats:YES];
}

- (void)checkCalibration
{
    if (self.deviceDirection == 0.0f) {
        self.calibrationDelta = 0.0f;
        return;
    }

    /*if (self.deviceAltitude == 0.0f) {
        self.calibrationDelta = 0.0f;
        return;
    }*/

    if ((self.deviceCoordinate.latitude == 0.0f) && (self.deviceCoordinate.longitude == 0.0f)) {
        self.calibrationDelta = 0.0f;
        return;
    }

    if (self.calibrationDelta > 5.0f) {
        self.calibrationDelta = 0.0f;
        return;
    }

    if (self.calibrationTimer != nil) {
        NSTimer *timer = self.calibrationTimer;
        self.calibrationTimer = nil;
        [timer invalidate];
    }

    self.calibrating = NO;

    if (self.calibrationDelegate != nil)
        [self.calibrationDelegate navigatorDidCompleteCalibration];
}

#pragma mark - Navigation help tools

- (CLLocationDirection)directionFrom:(CLLocationCoordinate2D)fromCoordinate
                                  to:(CLLocationCoordinate2D)toCoordinate
{
    CLLocationDegrees fromLatitude = degreesToRadians(fromCoordinate.latitude);
    CLLocationDegrees fromLongitude = degreesToRadians(fromCoordinate.longitude);
    CLLocationDegrees toLatitude = degreesToRadians(toCoordinate.latitude);
    CLLocationDegrees toLongitude = degreesToRadians(toCoordinate.longitude);

    CLLocationDirection degree;

    degree = atan2(sin(toLongitude - fromLongitude) * cos(toLatitude), cos(fromLatitude) * sin(toLatitude) - sin(fromLatitude) * cos(toLatitude) * cos(toLongitude - fromLongitude));

    degree = radiandsToDegrees(degree);

    return (degree >= 0.0f) ? degree : 360.0f + degree;
}

- (CLLocationDirection)directionFrom:(CLLocationCoordinate2D)fromCoordinate
                                  to:(CLLocationCoordinate2D)toCoordinate
                          forHeading:(CLLocationDirection)forHeading
{
    CLLocationDirection headingAbsolute = [self directionFrom:fromCoordinate
                                                           to:toCoordinate];
    CLLocationDirection headingRelative = headingAbsolute - forHeading;

    if (headingRelative < 180.0f)
        headingRelative = 360.0f + headingRelative;
    if (headingRelative > 180.0f)
        headingRelative = headingRelative - 360.0f;

    return headingRelative;
}

- (CLLocationDistance)distanceFrom:(CLLocationCoordinate2D)fromCoordinate
                                to:(CLLocationCoordinate2D)toCoordinate
{
    CLLocation *fromLocation = [[CLLocation alloc] initWithLatitude:fromCoordinate.latitude
                                                          longitude:fromCoordinate.longitude];
    CLLocation *toLocation = [[CLLocation alloc] initWithLatitude:toCoordinate.latitude
                                                        longitude:toCoordinate.longitude];

    CLLocationDistance distance = [toLocation distanceFromLocation:fromLocation];

    return distance;
}

- (CLLocationCoordinate2D)shift:(CLLocationCoordinate2D)fromCoordinate
                        heading:(CLLocationDegrees)heading
                       distance:(CLLocationDistance)distance
{
    double distanceRadians = distance / 6371000.0f;

    double bearingRadians = degreesToRadians(heading);

    double fromLatitudeRadians = degreesToRadians(fromCoordinate.latitude);

    double fromLongitudeRadians = degreesToRadians(fromCoordinate.longitude);

    double toLatitudeRadians = asin(sin(fromLatitudeRadians) * cos(distanceRadians) + cos(fromLatitudeRadians) * sin(distanceRadians) * cos(bearingRadians));

    double toLongitudeRadians = fromLongitudeRadians + atan2(sin(bearingRadians) * sin(distanceRadians) * cos(fromLatitudeRadians), cos(distanceRadians) - sin(fromLatitudeRadians) * sin(toLatitudeRadians));

    toLongitudeRadians = fmod((toLongitudeRadians + 3 * M_PI), (2 * M_PI)) - M_PI;

    CLLocationCoordinate2D toCoordinate;
    toCoordinate.latitude = radiandsToDegrees(toLatitudeRadians);
    toCoordinate.longitude = radiandsToDegrees(toLongitudeRadians);

    return toCoordinate;
}

#pragma mark - Game help tools

- (CLLocationCoordinate2D)randomLocationNearCoordinate:(CLLocationCoordinate2D)coordinate
                                             rangeFrom:(CLLocationDistance)rangeFrom
                                               rangeTo:(CLLocationDistance)rangeTo
{
    CLLocationDegrees guessedDegrees = randomValue(360.0f);
    CLLocationDistance guessedDistance = randomRange(rangeFrom, rangeTo);
    CLLocationCoordinate2D guessedLocation = [self shift:coordinate
                                                 heading:guessedDegrees
                                                distance:guessedDistance];

    return guessedLocation;
}

#pragma mark - CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = (CLLocation *)[locations lastObject];

    if (self.calibrating == YES)
    {
        CLLocationDistance delta = [self distanceFrom:[self deviceCoordinate]
                                                   to:location.coordinate];
        self.calibrationDelta = MAX(self.calibrationDelta, delta);
    }

    [self setDeviceAltitude:location.altitude];
    [self setDeviceCoordinate:location.coordinate];

    if ((self.navigationDelegate != nil) && [self.navigationDelegate respondsToSelector:@selector(navigatorCoordinateDidChangeTo:)])
        [self.navigationDelegate navigatorCoordinateDidChangeTo:location.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    CLLocationDirection oldDirection = self.deviceDirection;
    CLLocationDirection newDirection = newHeading.trueHeading;

    [self setDeviceDirection:newDirection];

    if ((self.navigationDelegate != nil) && [self.navigationDelegate respondsToSelector:@selector(navigatorDirectionDidChangeFrom:to:)])
        [self.navigationDelegate navigatorDirectionDidChangeFrom:oldDirection
                                                              to:newDirection];
}

@end
