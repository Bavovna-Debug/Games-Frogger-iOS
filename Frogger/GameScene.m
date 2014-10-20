//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
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

        self.backgroundMusicPlayer =
        [[AVAudioPlayer alloc] initWithContentsOfURL:[self.playground levelMusicURL]
                                               error:nil];
        [self.backgroundMusicPlayer setNumberOfLoops:5];

        SKSpriteNode *stopButton = [SKSpriteNode spriteNodeWithImageNamed:@"Stop"];
        [stopButton setName:@"stopButton"];
        [stopButton setZPosition:NodeStopButton];
        [stopButton setPosition:CGPointMake(CGRectGetWidth(stopButton.frame) / 2,
                                            CGRectGetHeight(self.frame) - CGRectGetHeight(stopButton.frame) / 2)];
        [self addChild:stopButton];
    }

    [self.backgroundMusicPlayer play];

    self.gameBegin = [NSDate date];

    AppStore *appStore = [AppStore sharedAppStore];
    if ([appStore gameUnlocked] == NO)
    {
        [self showBanner];
        [self startUnlockReminder];
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
    PlayerNode *playerNode = [[PlayerNode alloc] initWithPlayground:self.playground];

    [self.playground addChild:playerNode];
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

#pragma mark SKPhysicsContactDelegate delegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *bodyA = [contact bodyA];
    SKPhysicsBody *bodyB = [contact bodyB];

    NSString *nameA = [[bodyA node] name];
    NSString *nameB = [[bodyB node] name];

    if ([nameA isEqualToString:@"vehicleNode"] == YES) {
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
    } else if ([nameA isEqualToString:@"playerNode"] == YES) {
        if ([nameB isEqualToString:@"playgroundNode"] == YES) {
            NSLog(@"Left playground");
            [self.playground repositionPlayer];
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

    [self stopUnlockReminder];

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

    [self stopUnlockReminder];

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

    [self stopUnlockReminder];

    [self.playground quit];

    [self.scene removeFromParent];
}

/*
- (void)rotateFrontViewOnXAxis
{
    self.rotAngle -= 10;

    float angle = (M_PI / 180.0f) * self.rotAngle/10;

    CATransform3D r = CATransform3DMakeRotation(angle, 1.0, 0.0, 0.0);
    CATransform3D t = CATransform3DMakeTranslation(10, 0.0, 0.0);

    self.view.layer.transform = t;
}
*/

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

#pragma mark App Store

- (void)gameWasUnlocked
{
    [self hideBanner];
}

@end
