//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import "DestinationNode.h"
#import "FloraNode.h"
#import "Globals.h"

@implementation DestinationNode

- (id)initWithWidth:(CGFloat)width
             height:(CGFloat)height
{
    CGSize destinationSize = CGSizeMake(width, height);
    self = [super initWithTexture:[self backgroundTexture:destinationSize]];
    if (self == nil)
        return nil;

    [self setName:@"destinationNode"];
    [self setZPosition:NodeZGround];

    [self setPhysicsBody:[self preparePhysicsBody]];

    [self placeTrees];
    
    return self;
}

- (SKPhysicsBody *)preparePhysicsBody
{
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    
    [physicsBody setUsesPreciseCollisionDetection:YES];

    [physicsBody setCategoryBitMask:NodeCategoryDestination];
    [physicsBody setCollisionBitMask:0];
    [physicsBody setContactTestBitMask:0];

    [physicsBody setDynamic:YES];
    [physicsBody setFriction:0.0f];
    [physicsBody setRestitution:0.0f];
    [physicsBody setLinearDamping:0.0f];
    [physicsBody setAllowsRotation:NO];

    return physicsBody;
}

- (SKTexture *)backgroundTexture:(CGSize)destinationSize
{
    UIGraphicsBeginImageContext(destinationSize);
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIImage *templateImage = [UIImage imageNamed:@"Grass"];

    CGContextDrawTiledImage(context,
                            (CGRect){ CGPointZero, templateImage.size },
                            [templateImage CGImage]);

    UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    SKTexture *texture = [SKTexture textureWithImage:textureImage];
    
    return texture;
}

- (void)placeTrees
{
    for (int x = CGRectGetMinX(self.frame) - 20.0f; x < CGRectGetMaxX(self.frame) + 20.0f; x += 50.0f)
    {
        for (int y = CGRectGetMinY(self.frame) + 20.0f; y < CGRectGetMaxY(self.frame); y += 50.0f)
        {
            FloraNode *tree = [[FloraNode alloc] init];
            [tree setPosition:CGPointMake(x + round(RandomBetween(-10.0f, 10.0f)),
                                          y + round(RandomBetween(-10.0f, 10.0f)))];
            [self addChild:tree];
        }
    }
}

@end
