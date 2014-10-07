//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "LaneNode.h"
#import "RoadNode.h"

@interface RoadNode ()

@property (nonatomic, assign, readwrite) RoadType roadType;

@end

@implementation RoadNode

- (id)initWithAttributes:(NSDictionary *)attributes
              playground:(SKSpriteNode *)playground
{
    CGFloat playgroundWidth = CGRectGetWidth(playground.frame);

    self = [super init];
    if (self == nil)
        return nil;

    [self parseAttributes:attributes];

    [self setName:@"roadNode"];
    [self setZPosition:NodeZRoad];

    CGSize size = CGSizeMake(playgroundWidth, 0.0f);

    [self setSize:size];

    [self setPhysicsBody:[self preparePhysicsBody:self.size]];

    return self;
}

- (void)parseAttributes:(NSDictionary *)attributes
{
    NSString *attrRoadType = [attributes objectForKey:@"RoadType"];

    if ([attrRoadType isEqualToString:@"CityStreet"]) {
        self.roadType = RoadTypeCityStreet;
    } else if ([attrRoadType isEqualToString:@"Highway"]) {
        self.roadType = RoadTypeHighway;
    } else if ([attrRoadType isEqualToString:@"Railway"]) {
        self.roadType = RoadTypeRailway;
    } else {
        // Error;
    }
}

- (SKPhysicsBody *)preparePhysicsBody:(CGSize)roadSize
{
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:roadSize];

    [physicsBody setUsesPreciseCollisionDetection:YES];

    [physicsBody setCategoryBitMask:NodeCategoryRoad];
    [physicsBody setCollisionBitMask:0];
    [physicsBody setContactTestBitMask:0];

    [physicsBody setDynamic:YES];
    [physicsBody setFriction:0.0f];
    [physicsBody setRestitution:0.0f];
    [physicsBody setLinearDamping:0.0f];
    [physicsBody setAllowsRotation:NO];

    return physicsBody;
}

- (SKTexture *)backgroundTexture
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    switch (self.roadType)
    {
        case RoadTypeCityStreet:
        case RoadTypeHighway:
        {
            UIImage *templateImage = [UIImage imageNamed:@"Asphalt"];

            CGContextDrawTiledImage(context,
                                    (CGRect){ CGPointZero, templateImage.size },
                                    [templateImage CGImage]);

            if ([self withPedestrian] == YES)
            {
                SKColor *stripesColor = [SKColor colorWithRed:0.800f green:0.800f blue:0.800f alpha:0.8f];
                [stripesColor setFill];

                CGRect stripeFrame = CGRectMake(CGRectGetMidX(self.frame) - 16.0f,
                                                0.0f,
                                                48.0f,
                                                16.0f);
                stripeFrame.origin.x += randomBetween(-CGRectGetWidth(self.frame) * 0.4f,
                                                      CGRectGetWidth(self.frame) * 0.4f);
                while (CGRectGetMinY(stripeFrame) < CGRectGetHeight(self.frame))
                {
                    CGContextFillRect(context, CGRectInset(stripeFrame, 0.0f, 4.0f));
                    stripeFrame = CGRectOffset(stripeFrame, 0.0f, CGRectGetHeight(stripeFrame));
                }
            }

            break;
        }

        case RoadTypeRailway:
        {
            UIImage *templateImage = [UIImage imageNamed:@"Gravel"];

            CGContextDrawTiledImage(context,
                                    (CGRect){ CGPointZero, templateImage.size },
                                    [templateImage CGImage]);

            break;
        }
    }

    UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    SKTexture *texture = [SKTexture textureWithImage:textureImage];
    
    return texture;
}

- (void)addChild:(SKNode *)node
{
    [super addChild:node];

    SKSpriteNode *spriteNode = (SKSpriteNode *)node;

    [self setSize:CGSizeMake(CGRectGetWidth(self.frame),
                             CGRectGetHeight(self.frame) + spriteNode.size.height)];

    CGFloat offset = -(CGRectGetHeight(self.frame) / 2);
    for (SKSpriteNode *child in [self children])
    {
        CGPoint point = CGPointMake(0.0f, offset + child.size.height / 2);
        [child setPosition:point];
        offset += child.size.height;
    }
}

- (void)startTraffic
{
    [self setTexture:[self backgroundTexture]];

    for (SKSpriteNode *node in [self children])
    {
        if ([node.name isEqualToString:@"laneNode"] == YES) {
            LaneNode *lane = (LaneNode *)node;
            [lane startTraffic];
        }
    }
}

- (void)stopTraffic
{
    for (SKSpriteNode *node in [self children])
    {
        if ([node.name isEqualToString:@"laneNode"] == YES) {
            LaneNode *lane = (LaneNode *)node;
            [lane stopTraffic];
        }

        [node removeFromParent];
    }
}

@end
