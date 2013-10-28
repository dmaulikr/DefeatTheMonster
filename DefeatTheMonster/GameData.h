//
//  GameData.h
//  DefeatTheMonster
//
//  Created by aatc on 10/9/13.
//  Copyright (c) 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Bow.h"

@interface GameData : NSObject
{
    //货币
    int _coin;//金币
    int _magicStone;//宝石
    int _grade;//关卡
    int _level;//等级
    int _currentExp;//当前经验值
    int _maxExp;//升级所需最大经验值
    //玩家属性
    int _maxHP;//最大血量
    int _maxMP;//最大蓝量
    int _strength;//力量等级
    int _agility;//敏捷等级
    int _powerAtk;//强力击等级
    int _deadlyAtk;//致命一击等级
    int _multipleArrow;//多重箭等级
    int _poisonArrow;//毒箭等级
    int _defender;//守卫者等级
    //玩家技能
    int _manaSkill_lvl;//魔力研究
    int _iceSkillOne_lvl;//冰技能等级1
    int _iceSkillTwo_lvl;//冰技能等级2
    int _iceSkillThree_lvl;//冰技能等级3
    int _fireSkillOne_lvl;//火技能等级1
    int _fireSkillTwo_lvl;//火技能等级2
    int _fireSkillThree_lvl;//火技能等级3
    int _lightSkillOne_lvl;//光技能等级1
    int _lightSkillTwo_lvl;//光技能等级2
    int _lightSkillThree_lvl;//光技能等级3
    
    int _wall;//城墙
    int _toewr;//魔法塔
    int _moat;//岩浆防御
    int _magicPower;//魔法力量
    int _spurting;//溅射
    int _burn;//灼伤
    int _eatangling;//扰乱岩浆
    
    //玩家所获取的弓箭
    NSMutableArray *_bowsArray;
    //玩家成就
    BowType _currentBowType;
    int _currentBowLvl;
    
    int _firstSkillType;
    int _secondSkillType;
    int _thirdSkillType;
    
    float backgroundMusicVolume;//开关背景音乐
    float effectsVolume;//开关音效
}

@property (nonatomic, assign) int coin;//金币
@property (nonatomic, assign) int magicStone;//宝石
@property (nonatomic, assign) int grade;//关卡
@property (nonatomic, assign) int level;//等级
@property (nonatomic, assign) int currentExp;//当前经验值
@property (nonatomic, assign) int maxExp;//升级所需最大经验值
//玩家属性
@property (nonatomic, assign) int maxHP;//最大血量
@property (nonatomic, assign) int maxMP;//最大蓝量
@property (nonatomic, assign) int strength;//力量等级
@property (nonatomic, assign) int agility;//敏捷等级
@property (nonatomic, assign) int powerAtk;//强力击等级
@property (nonatomic, assign) int deadlyAtk;//致命一击等级
@property (nonatomic, assign) int multipleArrow;//多重箭等级
@property (nonatomic, assign) int poisonArrow;//毒箭等级
@property (nonatomic, assign) int defender;//守卫者等级
@property (nonatomic, copy) NSMutableArray *bowsArray;

@property (nonatomic, assign) BowType currentBowType;
@property (nonatomic, assign) int currentBowLvl;
//玩家技能
@property (nonatomic, assign) int manaSkill_lvl;//魔力研究
@property (nonatomic, assign) int iceSkillOne_lvl;//冰技能等级1
@property (nonatomic, assign) int iceSkillTwo_lvl;//冰技能等级2
@property (nonatomic, assign) int iceSkillThree_lvl;//冰技能等级3
@property (nonatomic, assign) int fireSkillOne_lvl;//火技能等级1
@property (nonatomic, assign) int fireSkillTwo_lvl;//火技能等级2
@property (nonatomic, assign) int fireSkillThree_lvl;//火技能等级3
@property (nonatomic, assign) int lightSkillOne_lvl;//光技能等级1
@property (nonatomic, assign) int lightSkillTwo_lvl;//光技能等级2
@property (nonatomic, assign) int lightSkillThree_lvl;//光技能等级3

@property (nonatomic, assign) int wall;//城墙
@property (nonatomic, assign) int toewr;//魔法塔
@property (nonatomic, assign) int moat;//岩浆防御
@property (nonatomic, assign) int magicPower;//魔法力量
@property (nonatomic, assign) int spurting;//溅射
@property (nonatomic, assign) int burn;//灼伤
@property (nonatomic, assign) int eatangling;//扰乱岩浆

@property (nonatomic, assign) int firstSkillType;
@property (nonatomic, assign) int secondSkillType;
@property (nonatomic, assign) int thirdSkillType;

@property (nonatomic, readwrite) int getExp;
@property (nonatomic, readwrite) int killNum;
@property (nonatomic, readwrite) int life;
@property (nonatomic, assign) BOOL hadClickedAd;


@property (nonatomic, assign) float backgroundMusicVolume;
@property (nonatomic, assign) float effectsVolume;

- (void) saveEffectsVolume;
- (void) saveBackgroundMusicVolume;
- (float)getEffectsVolume;
- (float)getBackgroundMusicVolume;

+ (GameData *)shareGameDataInstance;

- (void)save;
- (BOOL)saveGameData:(NSMutableDictionary *)data  saveFileName:(NSString *)fileName;
- (NSMutableDictionary *)loadGameData:(NSString *)fileName;

- (NSMutableDictionary *)convertGameDataToDic;
- (void)convertDicToGameData:(NSMutableDictionary *)dic;


@end
