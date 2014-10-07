//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "SelectLevelScene.h"
#import "WelcomeScene.h"

@implementation WelcomeScene

#pragma mark UI events

- (void)didMoveToView:(SKView *)view
{
    [self createBackground:YES];
    [self createTitle];

    NSString *label = NSLocalizedString(@"SCENE_LABEL_TAP_SCREEN", nil);
    [self makeLabel:label];
}

- (SKTexture *)adButtonTexture
{
    UIGraphicsBeginImageContext(CGSizeMake(50.0f, 50.0f));
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect logoRect = CGRectMake(0, 0, 50, 50);

    CGContextDrawImage(context,
                       logoRect,
                       [[UIImage imageNamed:@"Tree-0001"] CGImage]);

    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    SKTexture *texture = [SKTexture textureWithImage:backgroundImage];

    return texture;
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    SKAction *action = [SKAction fadeOutWithDuration:0.5f];

    [self runAction:action completion:^{
        SKScene *nextScene = [[SelectLevelScene alloc]initWithSize:self.size];

        [self.view presentScene:nextScene];
    }];
}

@end