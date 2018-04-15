//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import "Globals.h"
#import "LaneMarkingNode.h"
#import "Playground.h"

@interface LaneMarkingNode ()

@property (nonatomic, assign, readwrite) LaneMarkingType laneMarkingType;

@end

@implementation LaneMarkingNode

- (id)initWithAttributes:(NSDictionary *)attributes
              playground:(SKSpriteNode *)playground
{
    CGFloat playgroundWidth = CGRectGetWidth(playground.frame);

    self = [super init];
    if (self == nil)
        return nil;

    [self parseAttributes:attributes];

    [self setName:@"laneMarkingNode"];
    [self setZPosition:NodeZLane];

    CGFloat lineWidth;
    switch (self.laneMarkingType)
    {
        case LaneMarkingTypeDouble:
            lineWidth = 12.0f;
            break;

        case LaneMarkingTypeSolid:
            lineWidth = 10.0f;
            break;

        case LaneMarkingTypeDash:
            lineWidth = 8.0f;
            break;
    }
    CGSize size = CGSizeMake(playgroundWidth, lineWidth);

    [self setSize:size];

    [self setPhysicsBody:[self preparePhysicsBody:size]];

    [self setTexture:[self backgroundTexture]];

    return self;
}

- (void)parseAttributes:(NSDictionary *)attributes
{
    NSString *attrType = [attributes objectForKey:@"Type"];

    if ([attrType isEqualToString:@"Dash"]) {
        self.laneMarkingType = LaneMarkingTypeDash;
    } else if ([attrType isEqualToString:@"Solid"]) {
        self.laneMarkingType = LaneMarkingTypeSolid;
    } else if ([attrType isEqualToString:@"Double"]) {
        self.laneMarkingType = LaneMarkingTypeDouble;
    } else {
        // Error
    }
}

- (SKPhysicsBody *)preparePhysicsBody:(CGSize)size
{
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    
    [physicsBody setUsesPreciseCollisionDetection:YES];

    [physicsBody setCategoryBitMask:NodeCategoryLaneMarking];
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
    SKColor *stripesColor = [SKColor colorWithRed:0.800f green:0.800f blue:0.800f alpha:0.7f];

    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [stripesColor setFill];

    switch (self.laneMarkingType)
    {
        case LaneMarkingTypeDouble:
        {
            CGRect stripeFrame = CGRectMake(0,
                                            CGRectGetHeight(self.frame) / 2 - 3.0f,
                                            CGRectGetWidth(self.frame),
                                            2.0f);
            CGContextFillRect(context, stripeFrame);

            stripeFrame = CGRectOffset(stripeFrame, 0, 4.0f);
            CGContextFillRect(context, stripeFrame);

            break;
        }

        case LaneMarkingTypeSolid:
        {
            CGRect stripeFrame = CGRectMake(0,
                                            CGRectGetHeight(self.frame) / 2 - 1.0f,
                                            CGRectGetWidth(self.frame),
                                            2.0f);
            CGContextFillRect(context, stripeFrame);

            break;
        }

        case LaneMarkingTypeDash:
        {
            CGRect stripeFrame = CGRectMake(0,
                                            CGRectGetHeight(self.frame) / 2 - 1.0f,
                                            24.0f,
                                            2.0f);
            while (CGRectGetMinX(stripeFrame) < CGRectGetWidth(self.frame))
            {
                CGContextFillRect(context, CGRectInset(stripeFrame, 6.0f, 0.0f));
                stripeFrame = CGRectOffset(stripeFrame, CGRectGetWidth(stripeFrame), 0.0f);
            }
            
            break;
        }
    }

    UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    SKTexture *texture = [SKTexture textureWithImage:textureImage];

    return texture;
}

@end
