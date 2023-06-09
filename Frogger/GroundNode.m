//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import "FloraNode.h"
#import "Globals.h"
#import "GroundNode.h"

@interface GroundNode ()

@property (nonatomic, assign, readwrite) GroundType  surfaceType;
@property (nonatomic, assign, readwrite) CGFloat     surfaceLength;

@end

@implementation GroundNode

- (id)initWithAttributes:(NSDictionary *)attributes
              playground:(SKSpriteNode *)playground
{
    CGFloat playgroundWidth = CGRectGetWidth(playground.frame);

    self = [super init];
    if (self == nil)
        return nil;

    [self parseAttributes:attributes];

    [self setName:@"laneMarkingNode"];
    [self setZPosition:NodeZGround];

    CGSize size = CGSizeMake(playgroundWidth, self.surfaceLength);

    [self setSize:size];

    [self setPhysicsBody:[self preparePhysicsBody:size]];

    [self draw];

    return self;
}

- (void)parseAttributes:(NSDictionary *)attributes
{
    NSString *attrSurface = [attributes objectForKey:@"Surface"];
    NSString *attrLength = [attributes objectForKey:@"Length"];
    NSScanner *scanner;

    if ([attrSurface isEqualToString:@"Stones"]) {
        self.surfaceType = GroundTypeLargeRoundStones;
    } else if ([attrSurface isEqualToString:@"Grass"]) {
        self.surfaceType = GroundTypeGrass;
    } else if ([attrSurface isEqualToString:@"TreeLine"]) {
        self.surfaceType = GroundTypeTreeLine;
    } else if ([attrSurface isEqualToString:@"Forest"]) {
        self.surfaceType = GroundTypeForest;
    } else {
        // Error
    }

    float surfaceLength;

    scanner = [NSScanner scannerWithString:attrLength];
    [scanner scanFloat:&surfaceLength];

    self.surfaceLength = surfaceLength;
}

- (SKPhysicsBody *)preparePhysicsBody:(CGSize)size
{
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    
    [physicsBody setUsesPreciseCollisionDetection:YES];

    [physicsBody setCategoryBitMask:NodeCategoryGround];
    [physicsBody setCollisionBitMask:0];
    [physicsBody setContactTestBitMask:0];

    [physicsBody setDynamic:YES];
    [physicsBody setFriction:0.0f];
    [physicsBody setRestitution:0.0f];
    [physicsBody setLinearDamping:0.0f];
    [physicsBody setAllowsRotation:NO];

    return physicsBody;
}

- (void)draw
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    switch (self.surfaceType)
    {
        case GroundTypeLargeRoundStones:
        {
            UIImage *templateImage = [UIImage imageNamed:@"Stones"];

            CGContextDrawTiledImage(context,
                                    (CGRect){ CGPointZero, templateImage.size },
                                    [templateImage CGImage]);

            FloraNode *tree;

            tree = [[FloraNode alloc] init];
            [self addChild:tree];
            [tree setPosition:CGPointMake(-(CGRectGetWidth(self.frame) / 2 - 25.0f), CGRectGetMidY(self.frame))];

            tree = [[FloraNode alloc] init];
            [self addChild:tree];
            [tree setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2 - 24.0f, CGRectGetMidY(self.frame))];
            
            break;
        }

        case GroundTypeGrass:
        {
            UIImage *templateImage = [UIImage imageNamed:@"Grass"];

            CGContextDrawTiledImage(context,
                                    (CGRect){ CGPointZero, templateImage.size },
                                    [templateImage CGImage]);

            FloraNode *tree;

            tree = [[FloraNode alloc] init];
            [self addChild:tree];
            [tree setPosition:CGPointMake(-(CGRectGetWidth(self.frame) / 2 - 25.0f), CGRectGetMidY(self.frame))];

            tree = [[FloraNode alloc] init];
            [self addChild:tree];
            [tree setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2 - 24.0f, CGRectGetMidY(self.frame))];

            break;
        }

        case GroundTypeTreeLine:
        {
            UIImage *templateImage = [UIImage imageNamed:@"Grass"];

            CGContextDrawTiledImage(context,
                                    (CGRect){ CGPointZero, templateImage.size },
                                    [templateImage CGImage]);

            for (int x = CGRectGetMinX(self.frame) + 10.0f; x < CGRectGetMaxX(self.frame) + 20.0f; x += 100.0f)
            {
                FloraNode *tree = [[FloraNode alloc] init];
                [tree setPosition:CGPointMake(x + round(RandomBetween(-10.0f, 10.0f)),
                                              CGRectGetMidY(self.frame))];
                [self addChild:tree];
            }

            break;
        }

        case GroundTypeForest:
        {
            break;
        }
    }

    UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    SKTexture *texture = [SKTexture textureWithImage:textureImage];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:texture];
    [self addChild:background];
}

@end
