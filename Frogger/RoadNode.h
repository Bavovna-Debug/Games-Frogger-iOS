//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Globals.h"

@interface RoadNode : SKSpriteNode

@property (nonatomic, assign, readonly) RoadType roadType;

- (id)initWithAttributes:(NSDictionary *)attributes
              playground:(SKSpriteNode *)playground;

- (void)startTraffic;

- (void)stopTraffic;

@end
