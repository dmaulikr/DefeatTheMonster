//
//  ControlLayer.h
//  DefeatTheMonster
//
//  Created by aatc on 10/9/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    kContorlLayerNodeTagIceSkill,
    kContorlLayerNodeTagFireSkill,
    kContorlLayerNodeTagLightSkill,
    kContorlLayerNodeTagMagicRing,
    kContorlLayerNodeTagAddMana,
}ContorlLayerNodeTag;

@interface ControlLayer : CCLayer
{
    
    ccTime totalTime;
	ccTime nextShotTime;
    BOOL isTouching;
    
    BOOL isUsingSkill;
    
    CCSprite *_blood;
    CCSprite *_sword;
    CCSprite *_skill;
    
    
    
    int flag;
}

@end
