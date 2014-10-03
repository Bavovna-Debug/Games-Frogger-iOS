//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "GameScene.h"
#import "Navigator.h"
#import "PreparationScene.h"

@interface PreparationScene () <NavigatorCalibrationDelegate>

@end

@implementation PreparationScene

#pragma mark UI events

- (void)didMoveToView:(SKView *)view
{
    [self makeBackground];

    NSString *label = NSLocalizedString(@"SCENE_LABEL_PREPARING", nil);
    [self makeLabel:label];

    Navigator *navigator = [Navigator sharedNavigator];
    [navigator setCalibrationDelegate:self];
    [navigator calibrate];
}

- (void)navigatorDidCompleteCalibration
{
    SKScene *gameScene = [[GameScene alloc]initWithSize:self.size];

    SKTransition *doors = [SKTransition doorwayWithDuration:0.5f];

    [self.view presentScene:gameScene transition:doors];
}

@end
