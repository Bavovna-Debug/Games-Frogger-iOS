//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SceneWithAds : SKScene

- (void)showBanner;

- (void)hideBanner;

#ifdef UNLOCK_REMINDER

- (void)startUnlockReminder;

- (void)stopUnlockReminder;

#endif

@end
