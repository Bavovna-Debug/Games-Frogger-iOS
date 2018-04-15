//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import "SelectLevelScene.h"
#import "WelcomeScene.h"

@implementation WelcomeScene

#pragma mark - UI events

- (void)didMoveToView:(SKView *)view
{
    [self createBackground:YES];
    [self createTitle];

    NSString *label = NSLocalizedString(@"SCENE_LABEL_TAP_SCREEN", nil);
    [self makeLabel:label];
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    SKAction *action = [SKAction fadeOutWithDuration:0.5f];

    [self runAction:action completion:^
    {
        SKScene *nextScene = [[SelectLevelScene alloc] initWithSize:self.size];

        [self.view presentScene:nextScene];
    }];
}

@end
