//
//  Tower.h
//  DefeatTheMonster
//
//  Created by wujiajing on 13-10-24.
//  Copyright 2013年 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum{
    kTowerTypeBottom,
    TowerTypeTop
}TowerType;

@interface Tower : CCNode
{
    CCSprite *tower;
    
    float atkDistance;//攻击距离
    ccTime nextAtkTime;
    ccTime atkInterval;//攻击间隔
    int atk;//攻击力
    
}

@end
