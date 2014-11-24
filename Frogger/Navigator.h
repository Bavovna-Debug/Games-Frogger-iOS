//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@protocol NavigatorCalibrationDelegate;
@protocol NavigatorDelegate;

@interface Navigator : NSObject

@property (nonatomic, strong, readwrite) id<NavigatorCalibrationDelegate>  calibrationDelegate;
@property (nonatomic, strong, readwrite) id<NavigatorDelegate>             navigationDelegate;

@property (nonatomic, assign, readonly) Boolean                 calibrating;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D  startPosition;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D  deviceCoordinate;
@property (nonatomic, assign, readonly) CLLocationDistance      deviceAltitude;
@property (nonatomic, assign, readonly) CLLocationDirection     deviceDirection;

+ (Navigator *)sharedNavigator;

- (void)startNavigation;

- (void)stopNavigation;

- (void)calibrate;

+ (CLLocationDirection)directionFrom:(CLLocationCoordinate2D)fromCoordinate
                                  to:(CLLocationCoordinate2D)toCoordinate;

+ (CLLocationDirection)directionFrom:(CLLocationCoordinate2D)fromCoordinate
                                  to:(CLLocationCoordinate2D)toCoordinate
                          forHeading:(CLLocationDirection)forHeading;

+ (CLLocationDistance)distanceFrom:(CLLocationCoordinate2D)fromCoordinate
                                to:(CLLocationCoordinate2D)toCoordinate;

+ (CLLocationCoordinate2D)shift:(CLLocationCoordinate2D)coordinate
                        heading:(CLLocationDegrees)heading
                       distance:(CLLocationDistance)distance;

+ (CLLocationCoordinate2D)randomLocationNearCoordinate:(CLLocationCoordinate2D)coordinate
                                             rangeFrom:(CLLocationDistance)rangeFrom
                                               rangeTo:(CLLocationDistance)rangeTo;

@end

@protocol NavigatorCalibrationDelegate <NSObject>

@required

- (void)navigatorDidCompleteCalibration;

@end

@protocol NavigatorDelegate <NSObject>

@optional

- (void)navigatorCoordinateDidChangeTo:(CLLocationCoordinate2D)coordinate;

- (void)navigatorDirectionDidChangeFrom:(CLLocationDirection)from
                                     to:(CLLocationDirection)to;

@end