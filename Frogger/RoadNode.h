//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Globals.h"

@interface RoadNode : SKSpriteNode

@property (nonatomic, assign, readonly)  RoadType  roadType;
@property (nonatomic, assign, readwrite) Boolean   withPedestrian;

- (id)initWithAttributes:(NSDictionary *)attributes
              playground:(SKSpriteNode *)playground;

- (void)startTraffic;

- (void)stopTraffic;

@end
