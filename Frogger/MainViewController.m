//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import "GameCenter.h"
#import "MainViewController.h"
#import "WelcomeScene.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark - UI events

- (void)viewDidLoad
{
    [super viewDidLoad];

#ifndef DEBUG
    [[GameCenter sharedGameCenter] authenticatePlayer:self];
#endif

    SKView *view = (SKView *) self.view;
    view.ignoresSiblingOrder = YES;

    WelcomeScene *scene =
    [[WelcomeScene alloc] initWithSize:CGSizeMake(view.bounds.size.width,
                                                  view.bounds.size.height)];

    [view presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationMaskAllButUpsideDown;
    else
        return UIInterfaceOrientationMaskAll;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
