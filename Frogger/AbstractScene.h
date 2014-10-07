//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AbstractScene : SKScene

- (void)playAudioWithName:(NSString *)resourceName
                   ofType:(NSString *)resourceType;

- (void)createBackground:(Boolean)withLogo;

- (void)createTitle;

- (void)makeLabel:(NSString *)text;

@end
