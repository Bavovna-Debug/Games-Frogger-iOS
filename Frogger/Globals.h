//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#ifndef Frogger_Nodes_h
#define Frogger_Nodes_h

#define NodeCategoryPlayer          0x0001
#define NodeCategoryPlayground      0x0002
#define NodeCategoryGround          0x0004
#define NodeCategoryTree            0x0008
#define NodeCategoryRoad            0x0010
#define NodeCategoryLane            0x0020
#define NodeCategoryLaneDecoration  0x0040
#define NodeCategoryLaneMarking     0x0080
#define NodeCategoryVehicle         0x0100
#define NodeCategoryDestination     0x8000

#define NodeZPlayground  0.0f
#define NodeZRoad           1.0f
#define NodeZLane               1.0f
#define NodeZVehicle                1.0f
#define NodeZGround         1.0f
#define NodeZFloraTree          3.0f
#define NodeZPlayer         3.0f

typedef enum {
    RoadTypeCityStreet,
    RoadTypeHighway
} RoadType;

typedef enum {
    TrafficDirectionLeftToRight,
    TrafficDirectionRightToLeft,
} TrafficDirection;

typedef enum {
    DriveDirectionLeftToRight,
    DriveDirectionRightToLeft
} DriveDirection;

#define randomValue(max) (((float)arc4random() / RAND_MAX) * max)
#define randomRange(min, max) (min + ((float)arc4random() / RAND_MAX) * (max - min))

#define randomFloat() rand() / (CGFloat) RAND_MAX
#define randomBetween(low, high) randomFloat() * (high - low) + low

#define degreesToRadians(degrees) (degrees * (M_PI / 180.0f))
#define radiandsToDegrees(radiands) (radiands * (180.0f / M_PI))
#define oppositeDirection(direction) ((direction < 180.0f) ? (direction + 180.0f) : (direction - 180.0f))
#define correctDegrees(x) ((x < 0.0f) ? (360.0f + x) : ((x >= 360.0f) ? (x - 360.0f) : x))

#endif
