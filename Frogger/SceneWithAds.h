//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SceneWithAds : SKScene

#define UnlockReminderInterval 40.0f

- (void)showBanner;

- (void)hideBanner;

- (void)startUnlockReminder;

- (void)stopUnlockReminder;

@end
