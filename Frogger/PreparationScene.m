//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "AppStore.h"
#import "GameScene.h"
#import "Navigator.h"
#import "PreparationScene.h"

@interface PreparationScene () <UIAlertViewDelegate, NavigatorCalibrationDelegate>

@end

@implementation PreparationScene

#pragma mark UI events

- (void)didMoveToView:(SKView *)view
{
    [self createBackground:YES];
    [self createTitle];

    NSString *label = NSLocalizedString(@"SCENE_LABEL_PREPARING", nil);
    [self makeLabel:label];

    if ([[AppStore sharedAppStore] gameUnlocked] == NO) {
        [self showIntroduction];
    } else {
        [self startCalibration];
    }
}

- (void)startCalibration
{
    Navigator *navigator = [Navigator sharedNavigator];
    [navigator setCalibrationDelegate:self];
    [navigator calibrate];
}

- (void)navigatorDidCompleteCalibration
{
    SKScene *gameScene = [[GameScene alloc] initWithSize:self.size];

    SKTransition *doors = [SKTransition doorwayWithDuration:0.5f];

    [self.view presentScene:gameScene transition:doors];
}

- (void)showIntroduction
{
    NSString *okButton = NSLocalizedString(@"ALERT_BUTTON_OK", nil);
    NSString *message = NSLocalizedString(@"ALERT_INTRODUCTION", nil);

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:okButton
                                              otherButtonTitles:nil];

    [alertView setAlertViewStyle:UIAlertViewStyleDefault];
    [alertView show];
}

#pragma mark Alert

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self startCalibration];
}

@end
