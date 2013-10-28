//
//  ResearchLayer.h
//  testCCScollView
//
//  Created by wujiajing on 13-10-16.
//  Copyright 2013年 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GADBannerView.h"
typedef enum{
    kResearchLayerNodeTagStrength,     //力量等级
    kResearchLayerNodeTagAgility,    //速度等级
    kResearchLayerNodeTagPower,    //速度等级
    kResearchLayerNodeTagPoison,    //速度等级
    kResearchLayerNodeTagBlow,    //致命等级
    kResearchLayerNodeTagMultiple,    //多重箭等级
    kResearchLayerNodeTagpeDefender,    //守卫者等级
}kResearchLayerNodeTag;

@class SWScrollView;

@interface ResearchLayer : CCLayer<GADBannerViewDelegate>
{
    //上部技能属性菜单
    CCMenu *menuFire;
    CCMenu *menuIce;
    CCMenu *menuLight;
    CCMenuItemSprite *weapon, *weapon1, *weapon2, *weapon3;
    //左侧控制滚动菜单
    CCSprite *defender_down;
    CCSprite *magic_down;
    CCSprite *wall_down;
    CCSprite *bow_down;
    //4个滚动菜单
    SWScrollView *defenderSV;
    SWScrollView *magicSV;
    SWScrollView *wallSV;
    SWScrollView *bowSV;
    //分值
    CCLabelAtlas *gradeLabel;
    CCLabelAtlas *coinLabel;
    CCLabelAtlas *magicStroneLabel;
    //技能信息显示面板
    CCSprite *info;
    CCLabelTTF *info_name;
    CCLabelTTF *info_describe;
    CCLabelTTF *info_grade;
    
    CCLabelAtlas *current;
    CCLabelAtlas *next;
    CCSprite *coin;
    CCMenuItemImage *buy;
    CCMenuItemImage *zhuangbei;
    CCLabelAtlas *price;
    CCLabelTTF *priceInfo;
    
    CGSize size;
}

+(CCScene *) scene;

@end
