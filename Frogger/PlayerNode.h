//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Playground.h"

@interface PlayerNode : SKSpriteNode

- (id)initWithPlayground:(Playground *)playground;

- (void)stop;

- (void)moveToPosition:(CGPoint)position;

@end
