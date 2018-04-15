//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#ifndef Globals_h
#define Globals_h

#define PLAY_MUSIC
#undef UNLOCK_REMINDER

#ifdef UNLOCK_REMINDER
#define UnlockReminderInterval      60.0f
#endif

#define RemoveAdsProductIdentifier  @"Zeppelinium.Frogger.Unlock"
#define GameUnlockedKey             @"gameUnlocked"
#define IntroductionCounterKey      @"introductionCounter"
#define TimesToShowIntroduction     5

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

#define NodeZBackground             0.0f
#define NodeZLabel                  1.0f
#define NodeZLevelButton            2.0f
#define NodeZUnlockButton           2.0f

#define NodeZPlayground             0.0f
#define NodeZRoad                   1.0f
#define NodeZLane                   1.0f
#define NodeZRailLights             2.0f
#define NodeZVehicle                1.0f
#define NodeZGround                 1.0f
#define NodeZFloraTree              3.0f
#define NodeZPlayer                 3.0f
#define NodeStopButton              99.0f

typedef enum
{
    RoadTypeCityStreet,
    RoadTypeHighway,
    RoadTypeRailway
} RoadType;

typedef enum
{
    TrafficDirectionLeftToRight,
    TrafficDirectionRightToLeft,
} TrafficDirection;

typedef enum
{
    DriveDirectionLeftToRight,
    DriveDirectionRightToLeft
} DriveDirection;

#define RandomValue(max) \
        (((float)arc4random() / RAND_MAX) * max)

#define RandomRange(min, max) \
        (min + ((float)arc4random() / RAND_MAX) * (max - min))

#define RandomFloat() \
        rand() / (CGFloat) RAND_MAX

#define RandomBetween(low, high) \
        RandomFloat() * (high - low) + low

#define DegreesToRadians(degrees) \
        (degrees * (M_PI / 180.0f))

#define RadiandsToDegrees(radiands) \
        (radiands * (180.0f / M_PI))

#define OppositeDirection(direction) \
        ((direction < 180.0f) ? (direction + 180.0f) : (direction - 180.0f))

#define CorrectDegrees(x) \
        ((x < 0.0f) ? (360.0f + x) : ((x >= 360.0f) ? (x - 360.0f) : x))

#endif
