//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "PreparationScene.h"
#import "WelcomeScene.h"

@interface WelcomeScene ()

@end

@implementation WelcomeScene

#pragma mark UI events

- (void)didMoveToView:(SKView *)view
{
    [self makeBackground];

    NSString *label = NSLocalizedString(@"SCENE_LABEL_TAP_SCREEN", nil);
    [self makeLabel:label];
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    SKAction *action = [SKAction fadeOutWithDuration:0.5f];

    [self runAction:action completion:^{
        SKScene *preparationScene = [[PreparationScene alloc]initWithSize:self.size];

        [self.view presentScene:preparationScene];
    }];
}

@end