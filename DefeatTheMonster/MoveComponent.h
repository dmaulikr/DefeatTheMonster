//
//  MoveComponent.h
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MoveComponent : CCSprite
{
    CGPoint _velocity;
}

+ (id)moveComponentWithVelocity:(CGPoint)velocity;

@end
