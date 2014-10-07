//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "Globals.h"
#import "LaneNode.h"
#import "RailLightsNode.h"
#import "VehicleNode.h"

#define NumberOfPKW        3
#define NumberOfLKW        6
#define NumberOfRailCars   5

#define DrivingDistance    40.0f
#define TrainBellDuration  4.0f
#define TrainClutchSize    10.0f

@interface VehicleNode ()

@property (nonatomic, assign, readwrite) VehicleType     vehicleType;
@property (nonatomic, assign, readwrite) DriveDirection  driveDirection;
@property (nonatomic, assign, readwrite) CGFloat         drivingSpeed;

@property (nonatomic, strong) NSTimer *scheduleTimer;
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
    switch (vehicleType)
    {
        case VehicleTypePKW:
        {
            NSString *imageName = [NSString stringWithFormat:@"PKW-%04d",
                                   (int16_t)round(randomBetween(1, NumberOfPKW))];
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

        case VehicleTypeLKW:
        {
            NSString *imageName = [NSString stringWithFormat:@"LKW-%04d",
                                   (int16_t)round(randomBetween(1, NumberOfLKW))];
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

        case VehicleTypeTrain:
        {
            NSUInteger numberOfVehicles = round(randomBetween(3, 8));
            NSMutableArray *vehicles = [NSMutableArray arrayWithCapacity:numberOfVehicles];

            UIImage *machineImage = [UIImage imageNamed:@"Machine-0001"];
            [vehicles addObject:machineImage];

            CGSize trainSize = CGSizeMake(machineImage.size.width,
                                          machineImage.size.height);

            while ([vehicles count] < numberOfVehicles)
            {
                NSString *imageName = [NSString stringWithFormat:@"Wagon-%04d",
                                       (int16_t)round(randomBetween(1, NumberOfRailCars))];
                UIImage *carImage = [UIImage imageNamed:imageName];
                [vehicles addObject:carImage];

                trainSize.height += carImage.size.height - TrainClutchSize;
            }


            UIGraphicsBeginImageContext(trainSize);
            CGContextRef context = UIGraphicsGetCurrentContext();

            CGFloat offset = trainSize.height;
            for (UIImage *vehicleImage in vehicles)
            {
                offset -= vehicleImage.size.height;

                CGRect vehicleRect = CGRectMake(0.0f,
                                                offset,
                                                vehicleImage.size.width,
                                                vehicleImage.size.height);
                CGContextDrawImage(context,
                                   vehicleRect,
                                   [vehicleImage CGImage]);

                offset += TrainClutchSize;
            }

            UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();

            UIGraphicsEndImageContext();
            
            SKTexture *texture = [SKTexture textureWithImage:textureImage];

            return texture;
        }
    }
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

- (void)scheduleVehicle
{
    switch (self.vehicleType)
    {
        case VehicleTypePKW:
        case VehicleTypeLKW:
            [self startVehicle];
            break;

        case VehicleTypeTrain:
        {
            LaneNode *lane = (LaneNode *)self.parent;
            RailLightsNode *lights = (RailLightsNode *)[lane childNodeWithName:@"railLightsNode"];

            if (lights != nil)
                [lights switchToGreed];

            self.scheduleTimer =
            [NSTimer scheduledTimerWithTimeInterval:TrainBellDuration
                                             target:self
                                           selector:@selector(startVehicle)
                                           userInfo:nil
                                            repeats:NO];
            break;
        }
    }
}

- (void)startVehicle
{
    LaneNode *lane = (LaneNode *)self.parent;
    RailLightsNode *lights = (RailLightsNode *)[lane childNodeWithName:@"railLightsNode"];

    if (lights != nil)
        [lights switchToRed];

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
    if (self.scheduleTimer != nil) {
        [self.scheduleTimer invalidate];
        self.scheduleTimer = nil;
    }

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
