//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import <AVFoundation/AVAudioPlayer.h>

#import "ApplicationDelegate.h"
#import "AppStore.h"
#import "GameCenter.h"
#import "GameOverScene.h"
#import "GameScene.h"
#import "Globals.h"
#import "MissionCompleteScene.h"
#import "PlayerNode.h"
#import "Playground.h"
#import "SelectLevelScene.h"
#import "VehicleNode.h"

@interface GameScene () <SKPhysicsContactDelegate, AppStoreDelegate>

@property (nonatomic, strong) Playground     *playground;
@property (nonatomic, strong) PlayerNode     *player;
@property (nonatomic, strong) AVAudioPlayer  *backgroundMusicPlayer;
@property (nonatomic, strong) NSDate         *gameBegin;

@end

@implementation GameScene
{
    BOOL sceneReady;
}

- (void)didMoveToView:(SKView *)view
{
    if (sceneReady == NO)
    {
        [self setBackgroundColor:[SKColor clearColor]];
        [self setScaleMode:SKSceneScaleModeAspectFill];

        [self.physicsWorld setGravity:CGVectorMake(0.0f, 0.0f)];
        [self.physicsWorld setContactDelegate:self];

        [self initPlayground];

        [self initPlayer];

        sceneReady = YES;

#ifdef PLAY_MUSIC
        self.backgroundMusicPlayer =
        [[AVAudioPlayer alloc] initWithContentsOfURL:[self.playground levelMusicURL]
                                               error:nil];
        [self.backgroundMusicPlayer setNumberOfLoops:5];
#endif

        SKSpriteNode *stopButton = [SKSpriteNode spriteNodeWithImageNamed:@"Stop"];
        CGPoint stopButtonPoint = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(stopButton.frame) / 2,
                                              CGRectGetHeight(stopButton.frame) / 2);
        [stopButton setName:@"stopButton"];
        [stopButton setZPosition:NodeStopButton];
        [stopButton setPosition:stopButtonPoint];
        [self addChild:stopButton];
    }

#ifdef PLAY_MUSIC
    [self.backgroundMusicPlayer play];
#endif

    self.gameBegin = [NSDate date];

    AppStore *appStore = [AppStore sharedAppStore];
    if ([appStore gameUnlocked] == NO)
    {
        [self showBanner];
#ifdef UNLOCK_REMINDER
        [self startUnlockReminder];
#endif
        [appStore setDelegate:self];
    }
}

- (void)initPlayground
{
    UIApplication *application = [UIApplication sharedApplication];
    ApplicationDelegate *applicationDelegate = (ApplicationDelegate *)[application delegate];

    self.playground = [[Playground alloc] initWithLevelId:[applicationDelegate levelId]
                                                     size:self.size];
    [self addChild:self.playground];
}

- (void)initPlayer
{
    self.player = [[PlayerNode alloc] initWithPlayground:self.playground];

    [self.playground addChild:self.player];

    CGPoint startPosition = [self.playground repositionPlayer];

    [self.player moveToPosition:startPosition];
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if (node != nil) {
        if ([node.name isEqualToString:@"stopButton"] == YES) {
            [self stopGame];
        } else {
            [self dontTouchScreenAlert];
        }
    }
}

#pragma mark - SKPhysicsContactDelegate delegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *bodyA = [contact bodyA];
    SKPhysicsBody *bodyB = [contact bodyB];

    NSString *nameA = [[bodyA node] name];
    NSString *nameB = [[bodyB node] name];

    if ([nameA isEqualToString:@"playgroundNode"] == YES) {
        if ([nameB isEqualToString:@"playerNode"] == YES) {
            NSLog(@"Left playground");
            //[self.playground repositionPlayer];
        }
    } else if ([nameA isEqualToString:@"vehicleNode"] == YES) {
        if ([nameB isEqualToString:@"playerNode"] == YES) {
            [self gameOver];
        }
    } else if ([nameA isEqualToString:@"destinationNode"] == YES) {
        if ([nameB isEqualToString:@"playerNode"] == YES) {
            [self missionComplete];
        }
    } else if ([nameA isEqualToString:@"laneMarkingNode"] == YES) {
        if ([nameB isEqualToString:@"vehicleNode"] == YES) {
            VehicleNode *vehicle = (VehicleNode *)bodyB.node;
            [vehicle steerOpposite];
        }
    } else if ([nameA isEqualToString:@"vehicleNode"] == YES) {
        if ([nameB isEqualToString:@"vehicleNode"] == YES) {
            VehicleNode *vehicleA = (VehicleNode *)bodyA.node;
            VehicleNode *vehicleB = (VehicleNode *)bodyB.node;

            [vehicleA slowDown];
            [vehicleB accelerate];
        }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *bodyA = [contact bodyA];
    SKPhysicsBody *bodyB = [contact bodyB];

    NSString *nameA = [[bodyA node] name];
    NSString *nameB = [[bodyB node] name];

    if ([nameA isEqualToString:@"laneNode"] == YES) {
        if ([nameB isEqualToString:@"vehicleNode"] == YES) {
            VehicleNode *vehicle = (VehicleNode *)bodyB.node;

            [vehicle stopVehicle];
            [vehicle removeFromParent];
        }
    }
}

- (void)stopGame
{
    SKAction *action = [SKAction fadeOutWithDuration:0.2f];

    [self.scene runAction:action completion:^{
        SKScene *nextScene = [[SelectLevelScene alloc]initWithSize:self.size];

        [self.view presentScene:nextScene];
    }];

#ifdef UNLOCK_REMINDER
    [self stopUnlockReminder];
#endif

    [self.player stop];

    [self.playground quit];

    [self.scene removeFromParent];
}

- (void)gameOver
{
    NSDate *now = [NSDate date];
    NSTimeInterval sinceGameBegin = [now timeIntervalSinceDate:self.gameBegin];

    if (sinceGameBegin < 2.0f)
        return;

    SKAction *action = [SKAction fadeOutWithDuration:0.2f];

    [self.scene runAction:action completion:^{
        SKScene *nextScene = [[GameOverScene alloc]initWithSize:self.size];

        [self.view presentScene:nextScene];
    }];

#ifdef UNLOCK_REMINDER
    [self stopUnlockReminder];
#endif

    [self.player stop];

    [self.playground quit];

    [self.scene removeFromParent];
}

- (void)missionComplete
{
    NSDate *now = [NSDate date];
    NSTimeInterval sinceGameBegin = [now timeIntervalSinceDate:self.gameBegin];

    if (sinceGameBegin < 2.0f)
        return;

    [[GameCenter sharedGameCenter] reportScore:sinceGameBegin];

    SKAction *action = [SKAction fadeOutWithDuration:0.2f];

    [self.scene runAction:action completion:^{
        SKScene *missionCompleteScene = [[MissionCompleteScene alloc]initWithSize:self.size];

        [self.view presentScene:missionCompleteScene];
    }];

#ifdef UNLOCK_REMINDER
    [self stopUnlockReminder];
#endif
    
    [self.playground quit];

    [self.scene removeFromParent];
}

- (void)dontTouchScreenAlert
{
    NSString *okButton = NSLocalizedString(@"ALERT_BUTTON_OK", nil);
    NSString *message = NSLocalizedString(@"ALERT_DONT_TOUCH_SCREEN", nil);
    message = [NSString stringWithFormat:message,
               [self.playground widthInMeter],
               [self.playground lengthInMeter]];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:okButton
                                              otherButtonTitles:nil];

    [alertView setAlertViewStyle:UIAlertViewStyleDefault];
    [alertView show];
}

#pragma mark - App Store

- (void)gameWasUnlocked
{
    [self hideBanner];
}

@end
