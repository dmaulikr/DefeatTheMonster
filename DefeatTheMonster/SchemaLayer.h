//
//  SchemaLayer.h
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SchemaLayer : CCLayer
{
    CCMenuItemSprite *_acSpriteCoin;//大富豪
    CCMenuItemSprite *_acSpriteMagic;//大法师
    CCMenuItemSprite *_acSpriteHunter;//怪物猎手
    CCMenuItemSprite *_acSpriteGurader;//守卫者
    CCMenuItemSprite *_acSpriteTactics;//战术大师
    CCMenuItemSprite *_acSpriteFire;//火焰主宰
    CCMenuItemSprite *_acSpriteIce;//冰冻主宰
    CCMenuItemSprite *_acLightning;//闪电主宰
}

+ (id)scene;

@end
