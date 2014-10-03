//
//  Frogger
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "DestinationNode.h"
#import "Globals.h"
#import "GroundNode.h"
#import "LaneNode.h"
#import "LaneMarkingNode.h"
#import "Navigator.h"
#import "Playground.h"
#import "RoadNode.h"

@interface Playground () <NSXMLParserDelegate>

@property (nonatomic, assign, readwrite) CLLocationCoordinate2D  centerCoordinate;
@property (nonatomic, assign, readwrite) CLLocationDirection     direction;

@property (nonatomic, assign, readwrite) CLLocationDistance      widthInMeter;
@property (nonatomic, assign, readwrite) CLLocationDistance      lengthInMeter;

@property (nonatomic, assign, readwrite) CGFloat                 scaleFactor;

@property (nonatomic, strong) Navigator *navigator;

@property (nonatomic, strong) NSString         *levelMusicTitle;
@property (nonatomic, strong) GroundNode       *parsingGround;
@property (nonatomic, strong) RoadNode         *parsingRoad;
@property (nonatomic, strong) LaneNode         *parsingLane;
@property (nonatomic, strong) LaneMarkingNode  *parsingLaneMarking;
@property (nonatomic, strong) DestinationNode  *parsingDestination;

@end

@implementation Playground

#pragma mark Object cunstructors/destructors

- (id)initWithSize:(CGSize)size
      widthInMeter:(CGFloat)widthInMeter
{
    self = [super init];
    if (self == nil)
        return nil;

    [self setSize:size];

    [self setName:@"playgroundNode"];
    [self setZPosition:NodeZPlayground];

    [self setPhysicsBody:[self preparePhysicsBody]];

    [self parseLevels];

    self.navigator = [Navigator sharedNavigator];

    CGFloat lengthToWidthRatio = size.height / size.width;
    [self setWidthInMeter:widthInMeter];
    [self setLengthInMeter:widthInMeter * lengthToWidthRatio];
    [self setScaleFactor:size.width / widthInMeter];

    CLLocationCoordinate2D currentCoordinate = [self.navigator deviceCoordinate];
    CLLocationDirection currentDirection = [self.navigator deviceDirection];

    currentCoordinate = [self.navigator shift:currentCoordinate
                                      heading:currentDirection
                                     distance:self.lengthInMeter / 2 - 4.0f];
    [self setCenterCoordinate:currentCoordinate];
    [self setDirection:currentDirection];

    return self;
}

- (SKPhysicsBody *)preparePhysicsBody
{
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];

    [physicsBody setUsesPreciseCollisionDetection:YES];

    [physicsBody setCategoryBitMask:NodeCategoryPlayground];
    [physicsBody setCollisionBitMask:0];
    [physicsBody setContactTestBitMask:0];

    [physicsBody setDynamic:YES];
    [physicsBody setFriction:0.0f];
    [physicsBody setRestitution:0.0f];
    [physicsBody setLinearDamping:0.0f];
    [physicsBody setAllowsRotation:NO];

    return physicsBody;
}

- (void)addChild:(SKNode *)node
{
    SKSpriteNode *nextNode = (SKSpriteNode *)node;
    SKSpriteNode *lastNode = [[self children] lastObject];
    CGPoint nodePosition;

    if ([node.name isEqualToString:@"playerNode"] == YES) {
        [nextNode setPosition:CGPointMake(CGRectGetMidX(self.frame),
                                          CGRectGetMinY(self.frame))];
    } else {
        if (lastNode == nil) {
            nodePosition = CGPointMake(CGRectGetWidth(self.frame) / 2,
                                       CGRectGetHeight(nextNode.frame) / 2);
        } else {
            nodePosition = CGPointMake(CGRectGetWidth(self.frame) / 2,
                                       CGRectGetMaxY(lastNode.frame) + CGRectGetHeight(nextNode.frame) / 2);
        }
    }

    [nextNode setPosition:nodePosition];

    [super addChild:node];
}

- (void)quit
{
    for (SKSpriteNode *node in [self children])
    {
        if ([node.name isEqualToString:@"roadNode"] == YES) {
            LaneNode *road = (LaneNode *)node;
            [road stopTraffic];
        }
        
        [node removeFromParent];
    }

    [self removeFromParent];
}

- (NSURL *)levelMusicURL
{
    return [NSURL fileURLWithPath:
            [[NSBundle mainBundle] pathForResource:self.levelMusicTitle
                                            ofType:@"mp3"]];
}

#pragma mark GPS

- (void)moveCenterWithHeading:(CLLocationDegrees)heading
                     distance:(CLLocationDistance)distance
{
    CLLocationCoordinate2D centerCoordinate = self.centerCoordinate;
    centerCoordinate = [self.navigator shift:centerCoordinate
                                     heading:heading
                                    distance:distance];
    [self setCenterCoordinate:centerCoordinate];
}

- (CGPoint)positionFromCoordinate:(CLLocationCoordinate2D)coordinate
{
    CGPoint position;
    CLLocationDirection directionFromCenter;
    CLLocationDistance distanceFromCenter;

    directionFromCenter = [self.navigator directionFrom:[self centerCoordinate]
                                                     to:coordinate
                                             forHeading:[self direction]];

    distanceFromCenter = [self.navigator distanceFrom:[self centerCoordinate]
                                                   to:coordinate];

    CGFloat x = distanceFromCenter * cos((90.0f - directionFromCenter) * M_PI / 180);
    CGFloat y = distanceFromCenter * sin((90.0f - directionFromCenter) * M_PI / 180);

    position.x = [self widthInMeter] * [self scaleFactor] / 2;
    position.y = [self lengthInMeter] * [self scaleFactor] / 2;
    position.x += x * [self scaleFactor];
    position.y += y * [self scaleFactor];

    return position;
}

#pragma mark XML parsing

- (void)parseLevels
{
    NSString *Path = [[NSBundle mainBundle] bundlePath];
    NSString *DataPath = [ Path stringByAppendingPathComponent:@"Levels.xml"];

    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:DataPath];

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
    if ([elementName isEqualToString:@"Level"] == YES) {
        parsing = YES;

        self.levelMusicTitle = [attributes objectForKey:@"MusicTitle"];

        return;
    }

    if (parsing == NO)
        return;

    if ([elementName isEqualToString:@"Ground"] == YES) {
        self.parsingGround =
        [[GroundNode alloc] initWithAttributes:attributes
                                    playground:self];
    } else if ([elementName isEqualToString:@"Road"] == YES) {
        self.parsingRoad =
        [[RoadNode alloc] initWithAttributes:attributes
                                  playground:self];
    } else if ([elementName isEqualToString:@"Lane"] == YES) {
        self.parsingLane =
        [[LaneNode alloc] initWithAttributes:attributes
                                  playground:self];
    } else if ([elementName isEqualToString:@"LaneMarking"] == YES) {
        self.parsingLaneMarking =
        [[LaneMarkingNode alloc] initWithAttributes:attributes
                                         playground:self];
    } else if ([elementName isEqualToString:@"Destination"] == YES) {
        self.parsingDestination =
        [[DestinationNode alloc] initWithWidth:CGRectGetWidth(self.frame)
                                        height:[self freeSpace]];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
{
    if ([elementName isEqualToString:@"Level"] == YES) {
        parsing = NO;
        return;
    }

    if ([elementName isEqualToString:@"Ground"] == YES) {
        [self addChild:self.parsingGround];
    } else if ([elementName isEqualToString:@"Road"] == YES) {
        [self addChild:self.parsingRoad];
        [self.parsingRoad startTraffic];
    } else if ([elementName isEqualToString:@"Lane"] == YES) {
        [self.parsingRoad addChild:self.parsingLane];
    } else if ([elementName isEqualToString:@"LaneMarking"] == YES) {
        [self.parsingRoad addChild:self.parsingLaneMarking];
    } else if ([elementName isEqualToString:@"Destination"] == YES) {
        [self addChild:self.parsingDestination];
    }
}

- (CGFloat)freeSpace
{
    SKSpriteNode *lastNode = [[self children] lastObject];

    return CGRectGetHeight(self.frame) - CGRectGetMaxY(lastNode.frame);
}

@end
