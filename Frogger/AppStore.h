//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppStore : NSObject

@property (nonatomic, strong, readwrite) id delegate;

@property (nonatomic, assign, readonly)  BOOL gameUnlocked;

+ (AppStore *)sharedAppStore;

- (BOOL)gameUnlocked;

- (void)setGameUnlocked:(BOOL)gameUnlocked;

- (void)purchaseUnlock;

- (void)restorePurchasedUnlock;

@end

@protocol AppStoreDelegate <NSObject>

@required

- (void)gameWasUnlocked;

@end
