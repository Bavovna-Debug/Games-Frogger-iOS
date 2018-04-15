//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Globals.h"

@interface VehicleNode : SKSpriteNode

typedef enum {
    VehicleTypePKW,
    VehicleTypeLKW,
    VehicleTypeTrain
} VehicleType;

@property (nonatomic, assign, readonly) VehicleType     vehicleType;
@property (nonatomic, assign, readonly) DriveDirection  driveDirection;
@property (nonatomic, assign, readonly) CGFloat         drivingSpeed;

- (id)initWithType:(VehicleType)vehicleType
    driveDirection:(DriveDirection)driveDirection
      drivingSpeed:(CGFloat)drivingSpeed;

- (void)scheduleVehicle;

- (void)startVehicle;

- (void)stopVehicle;

- (void)steerOpposite;

- (void)slowDown;

- (void)accelerate;

@end
