//
//  Frogger
//
//  Copyright © 2014-2017 Meine Werke. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GroundNode : SKSpriteNode

typedef enum {
    GroundTypeLargeRoundStones,
    GroundTypeGrass,
    GroundTypeTreeLine,
    GroundTypeForest
} GroundType;

@property (nonatomic, assign, readonly) GroundType  surfaceType;
@property (nonatomic, assign, readonly) CGFloat     surfaceLength;

- (id)initWithAttributes:(NSDictionary *)attributes
              playground:(SKSpriteNode *)playground;

@end
