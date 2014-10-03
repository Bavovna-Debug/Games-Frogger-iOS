//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "FloraNode.h"
#import "Globals.h"

@interface FloraNode ()

@property (nonatomic, strong) NSTimer *rotationTimer;

@end

@implementation FloraNode

#define NumberOfTrees 6

- (id)init
{
    int randomNumber = (int)round(randomBetween(1, NumberOfTrees));
    NSString *floraElementName = [NSString stringWithFormat:@"Tree-%04d", randomNumber];

    self = [super initWithImageNamed:floraElementName];
    if (self == nil)
        return nil;

    [self setName:@"floraNode"];
    [self setZPosition:NodeZFloraTree];

    [self setPhysicsBody:[self preparePhysicsBody]];

    [self runAction:[SKAction rotateToAngle:round(degreesToRadians(randomBetween(0.0f, 360.0f)))
                                   duration:0.0f
                            shortestUnitArc:YES]];

    [self scheduleRotation];

    return self;
}

- (SKPhysicsBody *)preparePhysicsBody
{
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];

    [physicsBody setUsesPreciseCollisionDetection:NO];

    [physicsBody setCategoryBitMask:NodeCategoryTree];
    [physicsBody setCollisionBitMask:0];
    [physicsBody setContactTestBitMask:0];

    [physicsBody setDynamic:YES];
    [physicsBody setFriction:0.0f];
    [physicsBody setRestitution:0.0f];
    [physicsBody setLinearDamping:0.0f];
    [physicsBody setAllowsRotation:NO];
    
    return physicsBody;
}

- (void)scheduleRotation
{
    CGFloat interval = randomBetween(1.0f, 3.0f);

    [self runAction:[SKAction rotateByAngle:degreesToRadians(round(randomBetween(-3.0f, 3.0f)))
                                   duration:interval]];

    self.rotationTimer =
    [NSTimer scheduledTimerWithTimeInterval:interval
                                     target:self
                                   selector:@selector(scheduleRotation)
                                   userInfo:nil
                                    repeats:NO];
}

@end
