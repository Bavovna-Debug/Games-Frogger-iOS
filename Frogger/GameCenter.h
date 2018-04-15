//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GameCenter : NSObject

+ (GameCenter *)sharedGameCenter;

- (void)authenticatePlayer:(UIViewController *)viewController;

- (void)reportScore:(NSTimeInterval)sinceGameBegin;

@end
