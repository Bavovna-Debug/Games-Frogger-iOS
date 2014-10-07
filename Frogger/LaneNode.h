//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
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
