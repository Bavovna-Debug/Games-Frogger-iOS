//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "Globals.h"
#import "Navigator.h"
#import "PlayerNode.h"

@interface PlayerNode () <NavigatorDelegate>

#define PlayerPhysicsRadius     5.0f
#define NumberOfWalkAnimations  8

@property (nonatomic, strong) Navigator               *navigator;
@property (nonatomic, weak)   Playground              *playground;

@property (nonatomic, strong) SKAction                *walkingAnimation;

@property (nonatomic, strong) NSDate                  *lastMovement;
@property (nonatomic, assign) CLLocationCoordinate2D  lastCoordinate;
@property (nonatomic, assign) CGFloat                 lastSpeed;

@end

@implementation PlayerNode

#pragma mark Object cunstructors/destructors

- (id)initWithPlayground:(Playground *)playground
{
    self = [super initWithImageNamed:@"Player-0001"];
    if (self == nil)
        return nil;

    [self setName:@"playerNode"];
    [self setZPosition:NodeZPlayer];

    [self setPhysicsBody:[self preparePhysicsBody]];

    self.navigator = [Navigator sharedNavigator];
    [self.navigator setNavigationDelegate:self];

    self.playground      = playground;
    self.lastMovement    = [NSDate date];
    self.lastCoordinate  = [self.navigator deviceCoordinate];
    self.lastSpeed       = 0.0f;

    self.walkingAnimation = [self prepareWalkingAnimation];

    [self runAction:self.walkingAnimation withKey:@"walkingAnimation"];

    return self;
}

- (SKPhysicsBody *)preparePhysicsBody
{
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:PlayerPhysicsRadius];

    [physicsBody setUsesPreciseCollisionDetection:YES];

    [physicsBody setCategoryBitMask:NodeCategoryPlayer];
    [physicsBody setCollisionBitMask:0];
    [physicsBody setContactTestBitMask:NodeCategoryPlayground | NodeCategoryVehicle | NodeCategoryDestination];

    [physicsBody setDynamic:YES];
    [physicsBody setFriction:0.0f];
    [physicsBody setRestitution:0.0f];
    [physicsBody setLinearDamping:0.0f];
    [physicsBody setAllowsRotation:NO];

    return physicsBody;
}

- (SKAction *)prepareWalkingAnimation
{
    NSMutableArray *walkingTextures =
    [NSMutableArray arrayWithCapacity:NumberOfWalkAnimations];

    for (int i = 1; i <= NumberOfWalkAnimations; i++)
    {
        NSString *textureName =
        [NSString stringWithFormat:@"Player-%04d", i];

        SKTexture *texture =
        [SKTexture textureWithImageNamed:textureName];

        [walkingTextures addObject:texture];
    }

    SKAction *walkingAnimation =
    [SKAction animateWithTextures:walkingTextures
                     timePerFrame:0.1];

    SKAction *repeatWalkingAnimation =
    [SKAction repeatActionForever:walkingAnimation];

    return repeatWalkingAnimation;
}

#pragma mark Navigator delegate

- (void)navigatorDirectionDidChangeFrom:(CLLocationDirection)from
                                     to:(CLLocationDirection)to
{
    CLLocationDirection direction = to - [self.playground direction];
    direction = correctDegrees(direction);
    direction = degreesToRadians(direction);

    [self runAction:[SKAction rotateToAngle:-direction
                                   duration:0.2f
                            shortestUnitArc:YES]];
}

- (void)navigatorCoordinateDidChangeTo:(CLLocationCoordinate2D)coordinate
{
    NSDate *thisMovement = [NSDate date];
    NSTimeInterval sinceLastMovement = [thisMovement timeIntervalSinceDate:self.lastMovement];

    CLLocationDistance distance = [self.navigator distanceFrom:self.lastCoordinate
                                                            to:coordinate];
    CGFloat speedInMeterPerSecond = distance / sinceLastMovement;

    if ((sinceLastMovement < 2.0f) && (self.lastSpeed < 1.2f) && (speedInMeterPerSecond > 10.0f)) {
        CLLocationDirection heading = [self.navigator directionFrom:self.lastCoordinate
                                                                 to:coordinate];

        [self.playground moveCenterWithHeading:heading
                                      distance:distance];

        self.lastMovement    = thisMovement;
        //self.lastCoordinate  = coordinate;
    } else {
        self.lastMovement    = thisMovement;
        self.lastCoordinate  = coordinate;
        self.lastSpeed       = speedInMeterPerSecond;

        CGPoint lastPosition = self.position;
        CGPoint thisPosition = [self.playground positionFromCoordinate:coordinate];

        if (CGPointEqualToPoint(lastPosition, thisPosition) == NO)
            [self runAction:[SKAction moveTo:thisPosition
                                    duration:0.2f]];
    }
}

@end
