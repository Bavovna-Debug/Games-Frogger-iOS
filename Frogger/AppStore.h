//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppStore : NSObject

#define RemoveAdsProductIdentifier  @"Zeppelinium.Frogger.Unlock"
#define GameUnlockedKey             @"gameUnlocked"

@property (nonatomic, strong, readwrite) id delegate;

@property (nonatomic, assign) BOOL gameUnlocked;

+ (AppStore *)sharedAppStore;

- (id)init;

- (BOOL)gameUnlocked;

- (void)setGameUnlocked:(BOOL)gameUnlocked;

- (void)purchaseUnlock;

@end

@protocol AppStoreDelegate <NSObject>

@required

- (void)gameWasUnlocked;

@end
