//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
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

    self.name = @"levelButton";
    self.levelId = levelId;

    return self;
}

- (SKTexture *)buttonTexture:(NSUInteger)levelId
                  levelTitle:(NSString *)levelTitle
{
    CGSize size = CGSizeMake(300.0f, 72.0f);

    UIGraphicsBeginImageContext(size);

    UIColor *levelIdColor;
    UIColor *levelTitleColor;

#ifdef UNLOCK_REMINDER
    AppStore *appStore = [AppStore sharedAppStore];
    if (([appStore gameUnlocked] == NO) && (levelId > 1))
    {
        levelIdColor = [UIColor darkGrayColor];
        levelTitleColor = [UIColor darkGrayColor];
    }
    else
    {
        levelIdColor = [UIColor orangeColor];
        levelTitleColor = [UIColor whiteColor];
    }
#else
    levelIdColor = [UIColor orangeColor];
    levelTitleColor = [UIColor whiteColor];
#endif

    CGRect levelIdRect = CGRectMake(0.0f, 0.0f, 32.0f, size.height);
    CGRect levelTitleRect = CGRectMake(CGRectGetMaxX(levelIdRect), 0.0f, size.width, size.height);

    UIFont *levelIdFont = [UIFont fontWithName:@"Bradley Hand" size:28.0f];
    UIFont *levelTitleFont = [UIFont fontWithName:@"Bradley Hand" size:28.0f];

    NSString *levelIdString = [NSString stringWithFormat:@"%lu", (unsigned long)levelId];

    // Make a copy of the default paragraph style.
    //
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    // Set line break mode.
    //
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];

    // Set text alignment.
    //
    [paragraphStyle setAlignment:NSTextAlignmentLeft];

    NSDictionary *levelIdAttributes = @{ NSFontAttributeName:levelIdFont,
                                         NSParagraphStyleAttributeName:paragraphStyle,
                                         NSForegroundColorAttributeName:levelIdColor };

    NSDictionary *levelTitleAttributes = @{ NSFontAttributeName:levelTitleFont,
                                            NSParagraphStyleAttributeName:paragraphStyle,
                                            NSForegroundColorAttributeName:levelTitleColor };

    [levelIdString drawInRect:levelIdRect
               withAttributes:levelIdAttributes ];

    [levelTitle drawInRect:levelTitleRect
                  withAttributes:levelTitleAttributes];

    UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    SKTexture *texture = [SKTexture textureWithImage:textureImage];
    
    return texture;
}

@end
