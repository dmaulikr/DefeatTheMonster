//
//  ResearchItem.h
//  DefeatTheMonster
//
//  Created by wujiajing on 13-10-17.
//  Copyright 2013年 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum{
    kCostTypeMagicStrone,     //消耗魔法石
    kCostTypeCoin,    //消耗金币
}CostType;
//int _strength;//力量等级
//int _agility;//敏捷等级
//int _powerAtk;//强力击等级
//int _deadlyAtk;//致命一击等级
//int _multipleArrow;//多重箭等级
//int _poisonArrow;//毒箭等级
////玩家技能
//int _manaSkill_lvl;//魔力研究
//int _iceSkill_lvl;//冰技能等级
//int _fireSkill_lvl;//火技能等级
//int _lightSkill_lvl;//光技能等级
typedef enum{
    kItemTypeNone = 0,
    
    kItemTypeStrength,     //力量等级
    kItemTypeAgility,    //速度等级
    kItemTypePower,    //速度等级
    kItemTypePoison,    //速度等级
    kItemTypeBlow,    //致命等级
    kItemTypeMultiple,    //多重箭等级
    kItemTypeDefender,
    
    kItemTypeManaResearch,
    kItemTypeLightOne,
    kItemTypeLightTow,
    kItemTypeLightThree,
    kItemTypeFireOne,
    kItemTypeFireTow,
    kItemTypeFireThree,
    kItemTypeIceOne,
    kItemTypeIceTow,
    kItemTypeIceThree,
    
    kItemTypeWall,//城墙
    kItemTypeToewr,//魔法塔
    kItemTypeMoat,//岩浆防御
    kItemTypeMagicPower,//魔法力量
    kItemTypeSpurting,//溅射
    kItemTypeBurn,//灼伤
    kItemTypeEatangling,//扰乱岩浆
}ItemType;

@interface ResearchItem : CCMenuItemSprite
{
    CCLabelAtlas *topLabel;
    CCLabelAtlas *bottomLabel;
    ItemType type;
    
    CCSprite *lockSprite;
    BOOL _isLocked;
}

@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, assign) int maxLvl;

+ (id)itemWithType:(ItemType)itemtype normalSprite:(CCNode<CCRGBAProtocol> *)normalSprite selectedSprite:(CCNode<CCRGBAProtocol> *)selectedSprite block:(void (^)(id))block;

@end
