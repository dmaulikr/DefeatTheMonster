//
//  Arrow.h
//  DefeatTheMonster
//
//  Created by aatc on 10/10/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Arrow : CCSprite
{
 	CGPoint velocity;
}

@property (readwrite, nonatomic) CGPoint velocity;

+ (id)arrowWithSpriteFrame:(CCSpriteFrame *)frame;

- (void)shootArrowFrom:(CGPoint)startPosition
              velocity:(CGPoint)vel
              rotation:(float)angle;

@end
