//
//  Bow.h
//  DefeatTheMonster
//
//  Created by aatc on 10/9/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum{
    kBowTypeNormal = 0,//普通
    kBowTypeAgi,//幽灵
    kBowTypeMul,//飓风
    kBowTypePow,//火山
    kBowTypeFinal//最终幻想
}BowType;

@interface Bow : CCNode
{
    CCSprite *_bowSprite;
    NSString *_bowName;
    BowType _type;
    int _level;
    int _strength;//力量等级
    int _agility;//敏捷等级
    int _powerAtk;//强力击等级
    int _deadlyAtk;//致命一击等级
    int _multipleArrow;//多重箭等级
}

@property (nonatomic, retain) CCSprite *bowSprite;
@property (nonatomic, copy) NSString *bowName;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int strength;
@property (nonatomic, assign) int agility;
@property (nonatomic, assign) int powerAtk;
@property (nonatomic, assign) int deadlyAtk;
@property (nonatomic, assign) int multipleArrow;

+ (id)bowWithType:(BowType)type bowLvl:(int)level;
- (id)initWithType:(BowType)type bowLvl:(int)level;

@end
