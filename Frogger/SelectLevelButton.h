//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SelectLevelButton : SKSpriteNode

@property (nonatomic, assign, readonly) NSUInteger levelId;

- (id)initWithLevelId:(NSUInteger)levelId
           levelTitle:(NSString *)levelTitle;

@end
