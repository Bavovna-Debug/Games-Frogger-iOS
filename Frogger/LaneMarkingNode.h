//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LaneMarkingNode : SKSpriteNode

typedef enum {
    LaneMarkingTypeDouble,
    LaneMarkingTypeSolid,
    LaneMarkingTypeDash
} LaneMarkingType;

@property (nonatomic, assign, readonly) LaneMarkingType laneMarkingType;

- (id)initWithAttributes:(NSDictionary *)attributes
              playground:(SKSpriteNode *)playground;

@end
