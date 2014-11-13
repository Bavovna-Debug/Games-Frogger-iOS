//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <iAd/iAd.h>

#import "AppStore.h"
#import "Globals.h"
#import "SceneWithAds.h"

@interface SceneWithAds () <ADBannerViewDelegate, UIAlertViewDelegate>

@end

@implementation SceneWithAds
{
    CGRect        bannerFrame;
    ADBannerView  *bannerView;
    BOOL          bannerIsVisible;
    NSTimer       *unlockReminderTimer;
}

- (void)showBanner
{
    bannerFrame = CGRectMake(0.0f,
                             0.0f,
                             CGRectGetWidth(self.view.frame),
                             50.0f);
    bannerView = [[ADBannerView alloc] initWithFrame:bannerFrame];
    [bannerView setDelegate:self];
    [self.view addSubview:bannerView];
}

- (void)hideBanner
{
    [bannerView setAlpha:0.0f];
}

- (void)startUnlockReminder
{
    if (unlockReminderTimer == nil) {
        unlockReminderTimer =
        [NSTimer scheduledTimerWithTimeInterval:UnlockReminderInterval
                                         target:self
                                       selector:@selector(unlockReminder)
                                       userInfo:nil
                                        repeats:NO];
    }
}

- (void)stopUnlockReminder
{
    if (unlockReminderTimer != nil) {
        NSTimer *timer = unlockReminderTimer;
        unlockReminderTimer = nil;
        [timer invalidate];

    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (bannerIsVisible == NO)
    {
        if (bannerView.superview == nil)
            [self.view addSubview:bannerView];

        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];

        [bannerView setFrame:bannerFrame];

        [UIView commitAnimations];

        bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Failed to retrieve ad");

    if (bannerIsVisible == YES)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];

        [bannerView setFrame:bannerFrame];

        [UIView commitAnimations];

        bannerIsVisible = NO;
    }
}

- (void)unlockReminder
{
    if ([[AppStore sharedAppStore] gameUnlocked] == YES)
    {
        [self hideBanner];
        return;
    }

    NSString *message = NSLocalizedString(@"AD_OFF_MESSAGE", nil);
    NSString *cancelButton = NSLocalizedString(@"AD_OFF_BUTTON_NOT_YET", nil);
    NSString *submitButton = NSLocalizedString(@"AD_OFF_BUTTON_DETAILS", nil);

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:cancelButton
                                              otherButtonTitles:submitButton, nil];

    [alertView setAlertViewStyle:UIAlertViewStyleDefault];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    unlockReminderTimer =
    [NSTimer scheduledTimerWithTimeInterval:30.0f
                                     target:self
                                   selector:@selector(unlockReminder)
                                   userInfo:nil
                                    repeats:NO];
    if (buttonIndex == 1)
        [[AppStore sharedAppStore] purchaseUnlock];
}

@end
