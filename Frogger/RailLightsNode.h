//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface RailLightsNode : SKSpriteNode

- (id)initWithLane:(SKSpriteNode *)lane;

- (void)switchToRed;

- (void)switchToGreed;

@end
