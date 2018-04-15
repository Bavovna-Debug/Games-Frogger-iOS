//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import "MissionCompleteScene.h"
#import "SelectLevelScene.h"

@interface MissionCompleteScene ()

@property (nonatomic, strong) NSTimer *welcomeTimer;

@end

@implementation MissionCompleteScene

#pragma mark - UI events

- (void)didMoveToView:(SKView *)view
{
    [self createBackground:YES];
    [self createTitle];

    NSString *label = NSLocalizedString(@"SCENE_LABEL_MISSION_COMPLETE", nil);
    [self makeLabel:label];

    //[self playAudioWithName:@"Applause" ofType:@"m4a"];

    self.welcomeTimer =
    [NSTimer scheduledTimerWithTimeInterval:5.0f
                                     target:self
                                   selector:@selector(switchToWelcomeScene)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)switchToWelcomeScene
{
    SKAction *action = [SKAction fadeOutWithDuration:0.5f];

    [self.scene runAction:action completion:^
    {
        SKScene *nextScene = [[SelectLevelScene alloc] initWithSize:self.size];

        [self.view presentScene:nextScene];
    }];

    [self.scene removeFromParent];
}

@end
