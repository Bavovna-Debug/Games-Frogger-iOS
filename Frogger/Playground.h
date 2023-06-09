//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <SpriteKit/SpriteKit.h>

@interface Playground : SKSpriteNode

@property (nonatomic, assign, readonly)  NSUInteger              levelId;
@property (nonatomic, assign, readonly)  CLLocationCoordinate2D  centerCoordinate;
@property (nonatomic, assign, readonly)  CLLocationDirection     direction;
@property (nonatomic, assign, readonly)  CLLocationDistance      widthInMeter;
@property (nonatomic, assign, readonly)  CLLocationDistance      lengthInMeter;

@property (nonatomic, assign, readonly)  CGFloat                 scaleFactor;

- (id)initWithLevelId:(NSUInteger)levelId
                 size:(CGSize)size;

- (CGPoint)repositionPlayer;

- (void)quit;

- (NSURL *)levelMusicURL;

- (void)moveCenterWithHeading:(CLLocationDegrees)heading
                     distance:(CLLocationDistance)distance;

- (CGPoint)positionFromCoordinate:(CLLocationCoordinate2D)coordinate;

@end
