//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Playground.h"

@interface PlayerNode : SKSpriteNode

- (id)initWithPlayground:(Playground *)playground;

- (void)stop;

- (void)moveToPosition:(CGPoint)position;

@end
