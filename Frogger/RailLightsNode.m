//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import "Globals.h"
#import "LaneNode.h"
#import "RailLightsNode.h"

@interface RailLightsNode ()

@property (nonatomic, weak)   LaneNode   *lane;
@property (nonatomic, strong) SKTexture  *redTexture;
@property (nonatomic, strong) SKTexture  *greenTexture;
@property (nonatomic, strong) NSTimer    *lightsTimer;

@end

@implementation RailLightsNode

- (id)initWithLane:(SKSpriteNode *)lane
{
    self = [super init];
    if (self == nil)
        return nil;

    self.lane = (LaneNode *)lane;

    [self setName:@"railLightsNode"];
    [self setZPosition:NodeZRailLights];

    UIImage *redImage = [UIImage imageNamed:@"RailLightsRed"];
    UIImage *greenImage = [UIImage imageNamed:@"RailLightsGreen"];

    self.redTexture = [SKTexture textureWithImage:redImage];
    self.greenTexture = [SKTexture textureWithImage:greenImage];

    [self setSize:[redImage size]];

    [self setTexture:self.redTexture];

    [self setPhysicsBody:[self preparePhysicsBody]];

    [self prepareAppearance];
    
    return self;
}

- (SKPhysicsBody *)preparePhysicsBody
{
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];

    [physicsBody setUsesPreciseCollisionDetection:YES];

    [physicsBody setCategoryBitMask:NodeCategoryLaneDecoration];
    [physicsBody setCollisionBitMask:0];
    [physicsBody setContactTestBitMask:0];

    [physicsBody setDynamic:YES];
    [physicsBody setFriction:0.0f];
    [physicsBody setRestitution:0.0f];
    [physicsBody setLinearDamping:0.0f];
    [physicsBody setAllowsRotation:NO];

    return physicsBody;
}

- (void)prepareAppearance
{
    CGFloat angle;
    if (self.lane.trafficDirection == TrafficDirectionLeftToRight)
        angle = 90.0f;
    else
        angle = 270.0f;

    [self runAction:[SKAction rotateToAngle:DegreesToRadians(angle) duration:0.0f]];
}

- (void)switchToRed
{
    self.lightsTimer =
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(switchToRedScheduled)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)switchToGreed
{
    [self setTexture:self.greenTexture];
}

- (void)switchToRedScheduled
{
    [self setTexture:self.redTexture];
}

@end
