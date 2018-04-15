//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import <GameKit/GameKit.h>

#import "GameCenter.h"

@interface GameCenter ()

@property (nonatomic, assign) Boolean   gameCenterEnabled;
@property (nonatomic, strong) NSString  *leaderboardIdentifier;

@end

@implementation GameCenter

+ (GameCenter *)sharedGameCenter
{
    static dispatch_once_t onceToken;
    static GameCenter *gameCenter;

    dispatch_once(&onceToken, ^{
        gameCenter = [[GameCenter alloc] init];
    });

    return gameCenter;
}

- (void)authenticatePlayer:(UIViewController *)mainViewController
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];

    localPlayer.authenticateHandler =
    ^(UIViewController *viewController, NSError *error)
    {
        if (viewController != nil) {
            [mainViewController presentViewController:viewController
                                             animated:YES
                                           completion:nil];
        } else {
            if ([GKLocalPlayer localPlayer].authenticated == NO) {
                self.gameCenterEnabled = YES;
            } else {
                self.gameCenterEnabled = YES;

                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:
                 ^(NSString *leaderboardIdentifier, NSError *error)
                 {
                     if (error == nil)
                         self.leaderboardIdentifier = leaderboardIdentifier;
                 }];
            }
        }
    };
}

- (void)reportScore:(NSTimeInterval)sinceGameBegin
{
    if (self.gameCenterEnabled == NO)
        return;

    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:self.leaderboardIdentifier];
    [score setValue:lround(sinceGameBegin * 100)];

    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
    }];
}

@end
