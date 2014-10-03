//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <SpriteKit/SpriteKit.h>

@interface Playground : SKSpriteNode

@property (nonatomic, assign, readonly)  CLLocationCoordinate2D  centerCoordinate;
@property (nonatomic, assign, readonly)  CLLocationDirection     direction;
@property (nonatomic, assign, readonly)  CLLocationDistance      widthInMeter;
@property (nonatomic, assign, readonly)  CLLocationDistance      lengthInMeter;

@property (nonatomic, assign, readonly)  CGFloat                 scaleFactor;

- (id)initWithSize:(CGSize)size
      widthInMeter:(CGFloat)widthInMeter;

- (void)quit;

- (NSURL *)levelMusicURL;

- (void)moveCenterWithHeading:(CLLocationDegrees)heading
                     distance:(CLLocationDistance)distance;

- (CGPoint)positionFromCoordinate:(CLLocationCoordinate2D)coordinate;

@end
