//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import "ApplicationDelegate.h"
#import "Navigator.h"

@interface ApplicationDelegate ()

@end

@implementation ApplicationDelegate

@synthesize levelId = _levelId;

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setIdleTimerDisabled:YES];

    Navigator *navigator = [Navigator sharedNavigator];
    [navigator startNavigation];

    return YES;
}

@end
