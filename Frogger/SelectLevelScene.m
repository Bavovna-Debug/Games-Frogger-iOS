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

#pragma mark UI events

- (void)didMoveToView:(SKView *)view
{
    [self createBackground:NO];
    [self createTitle];

    [self parseLevelList];
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SelectLevelButton *buttonNode = (SelectLevelButton *)[self nodeAtPoint:location];
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
}

#pragma mark XML

- (void)parseLevelList
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