//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "AppStore.h"
#import "SelectLevelButton.h"

@interface SelectLevelButton ()

@property (nonatomic, assign, readwrite) NSUInteger levelId;

@end

@implementation SelectLevelButton

- (id)initWithLevelId:(NSUInteger)levelId
           levelTitle:(NSString *)levelTitle
{
    self = [super initWithTexture:[self buttonTexture:levelId
                                           levelTitle:levelTitle]];
    if (self == nil)
        return nil;

    self.levelId = levelId;

    return self;
}

- (SKTexture *)buttonTexture:(NSUInteger)levelId
                  levelTitle:(NSString *)levelTitle
{
    CGSize size = CGSizeMake(300.0f, 80.0f);

    UIGraphicsBeginImageContext(size);
    //CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor *levelIdColor;
    UIColor *levelTitleColor;

    AppStore *appStore = [AppStore sharedAppStore];
    if (([appStore gameUnlocked] == NO) && (levelId > 1)) {
        levelIdColor = [UIColor darkGrayColor];
        levelTitleColor = [UIColor darkGrayColor];
    } else {
        levelIdColor = [UIColor orangeColor];
        levelTitleColor = [UIColor whiteColor];
    }

    CGRect levelIdRect = CGRectMake(0.0f, 0.0f, 32.0f, size.height);
    CGRect levelTitleRect = CGRectMake(CGRectGetMaxX(levelIdRect), 0.0f, size.width, size.height);

    UIFont *levelIdFont = [UIFont fontWithName:@"Bradley Hand" size:28.0f];
    UIFont *levelTitleFont = [UIFont fontWithName:@"Bradley Hand" size:28.0f];

    NSString *levelIdString = [NSString stringWithFormat:@"%lu", (unsigned long)levelId];
    [levelIdColor set];
    [levelIdString drawInRect:levelIdRect
                     withFont:levelIdFont];

    [levelTitleColor set];
    [levelTitle drawInRect:levelTitleRect
                  withFont:levelTitleFont];

    UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    SKTexture *texture = [SKTexture textureWithImage:textureImage];
    
    return texture;
}

@end
