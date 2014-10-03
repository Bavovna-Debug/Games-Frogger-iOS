//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <AVFoundation/AVAudioPlayer.h>

#import "MissionCompleteScene.h"
#import "WelcomeScene.h"

@interface MissionCompleteScene ()

@property (nonatomic, strong) AVAudioPlayer  *applausePlayer;
@property (nonatomic, strong) NSTimer        *welcomeTimer;

@end

@implementation MissionCompleteScene

#pragma mark UI events

- (void)didMoveToView:(SKView *)view
{
    [self makeBackground];

    NSString *label = NSLocalizedString(@"SCENE_LABEL_MISSION_COMPLETE", nil);
    [self makeLabel:label];

    //[self playAudio];

    self.welcomeTimer =
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(switchToWelcomeScene)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)playAudio
{
    NSURL *url =
    [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Applause"
                                                           ofType:@"m4a"]];
    self.applausePlayer =
    [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                           error:nil];

    [self.applausePlayer play];
}

- (void)switchToWelcomeScene
{
    SKAction *action = [SKAction fadeOutWithDuration:1.0f];

    [self.scene runAction:action completion:^{
        SKScene *welcomeScene = [[WelcomeScene alloc]initWithSize:self.size];

        [self.view presentScene:welcomeScene];
    }];

    [self.scene removeFromParent];
}

@end
