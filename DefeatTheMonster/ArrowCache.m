//
//  ArrowCache.m
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "ArrowCache.h"
#import "Arrow.h"

@implementation ArrowCache

+ (id)arrowWithMaxArrows:(int)num name:(NSString *)name level:(int)level
{
    return [[[self alloc] initWithMaxArrows:num name:name level:level] autorelease];
}

- (id)initWithMaxArrows:(int)num name:(NSString *)name level:(int)level
{
    
    if ( self = [super init]) {
        NSString *frameName;
        if ([name isEqualToString:@"normal"] || [name isEqualToString:@"final"]) {
            frameName = [NSString stringWithFormat:@"arrow_%@.png", name];
        } else {
            frameName = [NSString stringWithFormat:@"arrow_%@_0%d.png", name, level];
        }
        
        CCSpriteFrame* arrowFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                      spriteFrameByName:frameName];
        // use the bullet's texture
        batch = [CCSpriteBatchNode batchNodeWithTexture:arrowFrame.texture];
        [self addChild:batch];
        
        // Create a number of bullets up front and re-use them
        for (int i = 0; i < num; i++)
        {
            Arrow *arrow = [Arrow arrowWithSpriteFrame:arrowFrame];
            arrow.visible = NO;
            [batch addChild:arrow];
        }

    }
    
    return self;
}

-(void) shootArrowFrom:(CGPoint)startPosition
			   velocity:(CGPoint)velocity
			   rotation:(float)angle
{
    CCArray* bullets = batch.children;
    
    CCNode* node = [bullets objectAtIndex:nextInactiveBullet];
    NSAssert([node isKindOfClass:[Arrow class]], @"not a Arrow!");
    
    Arrow *arrow = (Arrow *)node;
    [arrow shootArrowFrom:startPosition velocity:velocity rotation:angle];
    nextInactiveBullet++;
    if (nextInactiveBullet >= bullets.count)
    {
        nextInactiveBullet = 0;
    }
}

-(BOOL) isArrowsCollidingWithRect:(CGRect)rect
{
    BOOL isColliding = NO;
    
    for (Arrow *arrow in batch.children)
    {
        if (arrow.visible)
        {
            if (CGRectIntersectsRect([arrow boundingBox], rect))
            {
                isColliding = YES;
                // remove the bullet
                arrow.visible = NO;
                break;
            }
        }
    }
    
    return isColliding;
}

@end
