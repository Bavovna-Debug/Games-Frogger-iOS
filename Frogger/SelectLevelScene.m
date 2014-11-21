//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "ApplicationDelegate.h"
#import "AppStore.h"
#import "PreparationScene.h"
#import "SelectLevelButton.h"
#import "SelectLevelScene.h"

@interface SelectLevelScene () <NSXMLParserDelegate>

@end

@implementation SelectLevelScene

#pragma mark - UI events

- (void)didMoveToView:(SKView *)view
{
    [self createBackground:NO];
    [self createTitle];
    [self createLevelList];
    if ([[AppStore sharedAppStore] gameUnlocked] == NO)
        [self createUnlockButton];
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:location];

    if ([touchedNode.name isEqualToString:@"levelButton"] == YES) {
        SelectLevelButton *buttonNode = (SelectLevelButton *)touchedNode;
        NSUInteger levelId = [buttonNode levelId];

        AppStore *appStore = [AppStore sharedAppStore];
        if (([appStore gameUnlocked] == NO) && (levelId > 1))
            return;

        UIApplication *application = [UIApplication sharedApplication];
        ApplicationDelegate *applicationDelegate = (ApplicationDelegate *)[application delegate];
        [applicationDelegate setLevelId:levelId];

        SKAction *action = [SKAction fadeOutWithDuration:0.2f];

        [self runAction:action completion:^{
            SKScene *nextScene = [[PreparationScene alloc]initWithSize:self.size];
            
            [self.view presentScene:nextScene];
        }];
    } else if ([touchedNode.name isEqualToString:@"unlockButton"] == YES) {
        [self showIntroduction];
    }
}

- (void)createUnlockButton
{
    NSString *buttonText = NSLocalizedString(@"APP_STORE_UNLOCK_BUTTON", nil);
    UIColor *textColor = [UIColor colorWithRed:0.502f green:1.000f blue:0.000f alpha:1.0f];
    UIFont *textFont = [UIFont fontWithName:@"Times New Roman" size:18.0f];

    // Make a copy of the default paragraph style.
    //
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    // Set line break mode.
    //
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];

    // Set text alignment.
    //
    [paragraphStyle setAlignment:NSTextAlignmentLeft];

    NSDictionary *buttonAttributes = @{ NSFontAttributeName:textFont,
                                        NSParagraphStyleAttributeName:paragraphStyle,
                                        NSForegroundColorAttributeName:textColor };

    CGSize buttonSize = [buttonText sizeWithAttributes:buttonAttributes];
    CGPoint buttonPosition = CGPointMake(CGRectGetWidth(self.frame) - buttonSize.width / 2 - 8.0f,
                                         buttonSize.height / 2 + 8.0f);

    UIGraphicsBeginImageContext(buttonSize);

    [buttonText drawInRect:CGRectMake(0.0f, 0.0f, buttonSize.width, buttonSize.height)
            withAttributes:buttonAttributes];

    UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    SKTexture *texture = [SKTexture textureWithImage:textureImage];

    SKSpriteNode *buttonNode = [[SKSpriteNode alloc] initWithTexture:texture];

    [buttonNode setName:@"unlockButton"];
    [buttonNode setPosition:buttonPosition];

    [self addChild:buttonNode];
}

- (void)showIntroduction
{
    NSString *buyItButton            = NSLocalizedString(@"APP_STORE_BUY_IT", nil);
    NSString *restorePurchaseButton  = NSLocalizedString(@"APP_STORE_RESTORE_PURCHASE", nil);
    NSString *cancelButton           = NSLocalizedString(@"APP_STORE_CANCEL", nil);
    NSString *message                = NSLocalizedString(@"APP_STORE_BUY_MESSAGE", nil);

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:cancelButton
                                              otherButtonTitles:buyItButton, restorePurchaseButton, nil];

    [alertView setAlertViewStyle:UIAlertViewStyleDefault];
    [alertView show];
}

#pragma mark - Alert

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[AppStore sharedAppStore] purchaseUnlock];
    } else if (buttonIndex == 2) {
        [[AppStore sharedAppStore] restorePurchasedUnlock];
    }
}

#pragma mark - XML

- (void)createLevelList
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    path = [path stringByAppendingPathComponent:@"Levels.xml"];

    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:path];

    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];

    [xmlParser setDelegate:self];

    [xmlParser parse];
}

BOOL parsing;

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributes
{
    if ([elementName isEqualToString:@"Level"] == YES)
    {
        NSString *attrLevelId = [attributes objectForKey:@"Id"];
        NSString *attrLevelTitle = [attributes objectForKey:@"Title"];
        NSScanner *scanner;

        int levelId;

        scanner = [NSScanner scannerWithString:attrLevelId];
        [scanner scanInt:&levelId];

        CGPoint buttonPosition = CGPointMake(CGRectGetMidX(self.frame),
                                             CGRectGetHeight(self.frame) * 0.8f);

        SelectLevelButton *buttonNode = [[SelectLevelButton alloc] initWithLevelId:levelId
                                                                        levelTitle:attrLevelTitle];
        buttonPosition.y -= buttonNode.size.height * (levelId - 1);
        [buttonNode setPosition:buttonPosition];

        [self addChild:buttonNode];
    }
}

@end