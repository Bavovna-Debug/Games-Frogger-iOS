//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import "AppStore.h"
#import "GameScene.h"
#import "Globals.h"
#import "Navigator.h"
#import "PreparationScene.h"

@interface PreparationScene () <UIAlertViewDelegate, NavigatorCalibrationDelegate>

@property (assign, nonatomic) Boolean mustShowIntroduction;

@end

@implementation PreparationScene

#pragma mark - UI events

- (void)didMoveToView:(SKView *)view
{
    [self createBackground:YES];
    [self createTitle];

    NSString *label = NSLocalizedString(@"SCENE_LABEL_PREPARING", nil);
    [self makeLabel:label];

/*
    if ([[AppStore sharedAppStore] gameUnlocked] == NO)
    {
        if ([self mustShowIntroduction] == YES)
            [self showIntroduction];
    }
    else
    {
        [self startCalibration];
    }
*/

    [self showIntroduction];
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

-(Boolean)mustShowIntroduction
{
    NSInteger introductionCounter = [[NSUserDefaults standardUserDefaults] integerForKey:IntroductionCounterKey];

    if (introductionCounter < TimesToShowIntroduction)
    {
        introductionCounter++;

        [[NSUserDefaults standardUserDefaults] setInteger:introductionCounter
                                                   forKey:IntroductionCounterKey];
        [[NSUserDefaults standardUserDefaults] synchronize];

        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)setGameUnlocked:(BOOL)gameUnlocked
{
    [[NSUserDefaults standardUserDefaults] setBool:gameUnlocked
                                            forKey:GameUnlockedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

#pragma mark - Alert

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self startCalibration];
}

@end
