//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Globals.h"

@interface LaneNode : SKSpriteNode

@property (nonatomic, assign, readonly) TrafficDirection  trafficDirection;
@property (nonatomic, assign, readonly) CGFloat           speedFrom;
@property (nonatomic, assign, readonly) CGFloat           speedTo;
@property (nonatomic, assign, readonly) CGFloat           intervalFrom;
@property (nonatomic, assign, readonly) CGFloat           intervalTo;

- (id)initWithAttributes:(NSDictionary *)attributes
              playground:(SKSpriteNode *)playground
                    road:(SKSpriteNode *)road;

- (void)startTraffic;

- (void)stopTraffic;

@end
