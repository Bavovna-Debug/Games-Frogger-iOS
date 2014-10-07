//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SelectLevelButton : SKSpriteNode

@property (nonatomic, assign, readonly) NSUInteger levelId;

- (id)initWithLevelId:(NSUInteger)levelId
           levelTitle:(NSString *)levelTitle;

@end
