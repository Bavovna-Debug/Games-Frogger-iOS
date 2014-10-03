//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "Globals.h"
#import "VehicleNode.h"

#define NumberOfPKW      3
#define NumberOfLKW      6
#define DrivingDistance  40.0f

@interface VehicleNode ()

@property (nonatomic, assign, readwrite) VehicleType     vehicleType;
@property (nonatomic, assign, readwrite) DriveDirection  driveDirection;
@property (nonatomic, assign, readwrite) CGFloat         drivingSpeed;

@end

@implementation VehicleNode

@synthesize vehicleType     = _vehicleType;
@synthesize driveDirection  = _driveDirection;
@synthesize drivingSpeed    = _drivingSpeed;

- (id)initWithType:(VehicleType)vehicleType
    driveDirection:(DriveDirection)driveDirection
      drivingSpeed:(CGFloat)drivingSpeed
{
    self = [super initWithTexture:[self backgroundTexture:vehicleType]];
    if (self == nil)
        return nil;

    self.vehicleType     = vehicleType;
    self.driveDirection  = driveDirection;
    self.drivingSpeed    = drivingSpeed;

    [self setName:@"vehicleNode"];
    [self setZPosition:NodeZVehicle];

    [self prepareAppearance];

    [self setPhysicsBody:[self preparePhysicsBody]];

    return self;
}

- (SKPhysicsBody *)preparePhysicsBody
{
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    
    [physicsBody setUsesPreciseCollisionDetection:YES];

    [physicsBody setCategoryBitMask:NodeCategoryVehicle];
    [physicsBody setCollisionBitMask:NodeCategoryLaneMarking | NodeCategoryVehicle];
    [physicsBody setContactTestBitMask:NodeCategoryLane | NodeCategoryLaneMarking | NodeCategoryVehicle];

    [physicsBody setDynamic:YES];
    [physicsBody setFriction:0.0f];
    [physicsBody setRestitution:0.0f];
    [physicsBody setLinearDamping:0.0f];
    [physicsBody setAllowsRotation:NO];

    return physicsBody;
}

- (SKTexture *)backgroundTexture:(VehicleType)vehicleType
{
    NSString *imageName;
    switch (vehicleType) {
        case VehicleTypePKW:
            imageName = [NSString stringWithFormat:@"PKW-%04d",
                         (int16_t)round(randomBetween(1, NumberOfPKW))];
            break;

        case VehicleTypeLKW:
            imageName = [NSString stringWithFormat:@"LKW-%04d",
                         (int16_t)round(randomBetween(1, NumberOfLKW))];
            break;
    }
    UIImage *vehicleImage = [UIImage imageNamed:imageName];

    UIGraphicsBeginImageContext(CGSizeMake(vehicleImage.size.width,
                                           vehicleImage.size.height + DrivingDistance));
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextDrawImage(context,
                       CGRectMake(0.0f,
                                  DrivingDistance,
                                  vehicleImage.size.width,
                                  vehicleImage.size.height),
                       [vehicleImage CGImage]);

    UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    SKTexture *texture = [SKTexture textureWithImage:textureImage];
    
    return texture;
}

- (void)prepareAppearance
{
    CGFloat angle;
    if (self.driveDirection == DriveDirectionLeftToRight)
        angle = 90.0f;
    else
        angle = 270.0f;

    [self runAction:[SKAction rotateToAngle:degreesToRadians(angle) duration:0.0f]];
}

- (void)startVehicle
{
    CGFloat speed;
    if (self.driveDirection == DriveDirectionLeftToRight)
        speed = self.drivingSpeed;
    else
        speed = -self.drivingSpeed;

    speed *= (self.size.width * self.size.height) / 1000;

    [self.physicsBody applyImpulse:CGVectorMake(speed, 0.0f)];
}

- (void)stopVehicle
{
    [self.physicsBody setVelocity:CGVectorMake(0.0f, 0.0f)];
}

- (void)steerOpposite
{
    [self.physicsBody applyImpulse:CGVectorMake(0.0f, 0.0f)];
}

- (void)slowDown
{
    CGFloat speedDelta = randomBetween(-1.0f, -0.5f);

    self.drivingSpeed += speedDelta;

    if (self.driveDirection == DriveDirectionRightToLeft)
        speedDelta = -speedDelta;

    [self.physicsBody applyImpulse:CGVectorMake(speedDelta, 0.0f)];
}

- (void)accelerate
{
    CGFloat speedDelta = randomBetween(1.0f, 1.5f);

    self.drivingSpeed += speedDelta;

    if (self.driveDirection == DriveDirectionRightToLeft)
        speedDelta = -speedDelta;

    [self.physicsBody applyImpulse:CGVectorMake(speedDelta, 0.0f)];
}

@end
