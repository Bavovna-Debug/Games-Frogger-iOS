//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "GameOverScene.h"
#import "SelectLevelScene.h"

@interface GameOverScene ()

@property (nonatomic, strong) NSTimer *welcomeTimer;

@end

@implementation GameOverScene

#pragma mark - UI events

- (void)didMoveToView:(SKView *)view
{
    [self createBackground:YES];
    [self createTitle];

    NSString *label = NSLocalizedString(@"SCENE_LABEL_GAME_OVER", nil);
    [self makeLabel:label];

    //[self playAudioWithName:@"GameOver" ofType:@"m4a"];

    self.welcomeTimer =
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(switchToWelcomeScene)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)switchToWelcomeScene
{
    SKAction *action = [SKAction fadeOutWithDuration:0.5f];

    [self.scene runAction:action completion:^{
        SKScene *nextScene = [[SelectLevelScene alloc] initWithSize:self.size];

        [self.view presentScene:nextScene];
    }];

    [self.scene removeFromParent];
}

@end
