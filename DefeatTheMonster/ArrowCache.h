//
//  ArrowCache.h
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ArrowCache : CCNode
{
    CCSpriteBatchNode* batch;
	NSUInteger nextInactiveBullet;
}

+ (id)arrowWithMaxArrows:(int)num name:(NSString *)name level:(int)level;
- (id)initWithMaxArrows:(int)num name:(NSString *)name level:(int)level;

- (void)shootArrowFrom:(CGPoint)startPosition
              velocity:(CGPoint)velocity
              rotation:(float)angle;

-(BOOL) isArrowsCollidingWithRect:(CGRect)rect;

@end
