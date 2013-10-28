//
//  GameData.m
//  DefeatTheMonster
//
//  Created by aatc on 10/9/13.
//  Copyright (c) 2013 nchu. All rights reserved.
//

/*
 *属性值 = 当前武器属性值 + 人物属性值
 *
 */
#import "GameData.h"
#import "Player.h"
#import "Game_Config.h"

@implementation GameData

@synthesize effectsVolume;
@synthesize backgroundMusicVolume;
@synthesize powerAtk = _powerAtk, multipleArrow = _multipleArrow, deadlyAtk = _deadlyAtk, poisonArrow = _poisonArrow;
@synthesize strength = _strength, agility = _agility;
@synthesize coin = _coin, magicStone = _magicStone;
@synthesize grade = _grade;
@synthesize level = _level, maxExp = _maxExp, currentExp = _currentExp, maxHP = _maxHP, maxMP = _maxMP;
@synthesize currentBowLvl = _currentBowLvl, currentBowType = _currentBowType;
@synthesize defender = _defender;
@synthesize manaSkill_lvl = _manaSkill_lvl;
@synthesize fireSkillOne_lvl = _fireSkillOne_lvl, fireSkillTwo_lvl = _fireSkillTwo_lvl, fireSkillThree_lvl = _fireSkillThree_lvl;
@synthesize iceSkillOne_lvl = _iceSkillOne_lvl, iceSkillTwo_lvl = _iceSkillTwo_lvl, iceSkillThree_lvl = _iceSkillThree_lvl;
@synthesize lightSkillOne_lvl = _lightSkillOne_lvl, lightSkillTwo_lvl = _lightSkillTwo_lvl, lightSkillThree_lvl = _lightSkillThree_lvl;

@synthesize wall = _wall, toewr = _toewr, moat = _moat, magicPower = _magicPower, spurting = _spurting;
@synthesize burn =_burn, eatangling = _eatangling;
@synthesize bowsArray = _bowsArray;
@synthesize getExp, killNum, life, hadClickedAd;

@synthesize firstSkillType = _firstSkillType, secondSkillType = _secondSkillType, thirdSkillType = _thirdSkillType;

+ (GameData *)shareGameDataInstance
{
    static GameData *gameData = nil;
    if ( ! gameData ) {
        gameData = [[GameData alloc] init];
    }
    
    return gameData;
}

- (id)init
{
    if ( self = [super init] ) {
        NSMutableDictionary *dic = [self loadGameData:GAMEDATA_FILENAME];
        if (dic == nil) {
            [self firstGameInit];
            NSMutableDictionary *d = [self convertGameDataToDic];
            [self saveGameData:d saveFileName:GAMEDATA_FILENAME];
            NSLog(@"first init");
        } else {
            [self convertDicToGameData:dic];
        }
        hadClickedAd = NO;
    }
    
    return self;
}

- (void)firstGameInit
{
    //货币
    _coin = 0;//金币
    _magicStone = 0;//宝石
    _grade = 1;//关卡
    _level = 1;//等级
    _currentExp = 0;//当前经验值
    _maxExp = _level * 200 + 300;//升级所需最大经验值
    //玩家属性
    _maxHP = 90;//最大血量
    _maxMP = 80;//最大蓝量
    _strength = 0;//力量等级
    _agility = 0;//敏捷等级
    _powerAtk = 0;//强力击等级
    _deadlyAtk = 0;//致命一击等级
    _multipleArrow = 0;//多重箭等级
    _poisonArrow = 0;//毒箭等级
    _defender = 0;
    //玩家技能
    _manaSkill_lvl = 0;//魔力研究
    _iceSkillOne_lvl = 0;//冰技能等级1
    _iceSkillTwo_lvl = 0;//冰技能等级2
    _iceSkillThree_lvl = 0;//冰技能等级3
    _fireSkillOne_lvl = 0;//火技能等级1
    _fireSkillTwo_lvl = 0;//火技能等级2
    _fireSkillThree_lvl = 0;//火技能等级3
    _lightSkillOne_lvl = 0;//光技能等级1
    _lightSkillTwo_lvl = 0;//光技能等级2
    _lightSkillThree_lvl = 0;//光技能等级3

    _wall = 0;//城墙
    _toewr = 0;//魔法塔
    _moat = 0;//岩浆防御
    _magicPower = 0;//魔法力量
    _spurting = 0;//溅射
    _burn = 0;//灼伤
    _eatangling = 0;//扰乱岩浆
    
    _bowsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 29; i++) {
        if (i < 10) {
            [_bowsArray addObject:[NSNumber numberWithInt:1]];
        } else {
            [_bowsArray addObject:[NSNumber numberWithInt:0]];
        }
    }
    _currentBowLvl = 1;
    _currentBowType = kBowTypeNormal;
    
    _firstSkillType = 1;
    _secondSkillType = 0;
    _thirdSkillType = 0;
    
}

- (NSMutableDictionary *)convertGameDataToDic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSNumber *coin = [NSNumber numberWithInt:_coin];
    [dic setObject:coin forKey:KEY_COIN];

    NSNumber *magicStone = [NSNumber numberWithInt:_magicStone];
    [dic setObject:magicStone forKey:KEY_MAGICSTONE];

    NSNumber *grade = [NSNumber numberWithInt:_grade];
    [dic setObject:grade forKey:KEY_GRADE];

    NSNumber *level = [NSNumber numberWithInt:_level];
    [dic setObject:level forKey:KEY_LEVEL];

    NSNumber *currentExp = [NSNumber numberWithInt:_currentExp];
    [dic setObject:currentExp forKey:KEY_CURRENTEXP];

    NSNumber *maxExp = [NSNumber numberWithInt:_maxExp];
    [dic setObject:maxExp forKey:KEY_MAXEXP];

    NSNumber *maxHP = [NSNumber numberWithInt:_maxHP];
    [dic setObject:maxHP forKey:KEY_MAXHP];

    NSNumber *maxMP = [NSNumber numberWithInt:_maxMP];
    [dic setObject:maxMP forKey:KEY_MAXMP];

    NSNumber *strength = [NSNumber numberWithInt:_strength];
    [dic setObject:strength forKey:KEY_STRENGTH];

    NSNumber *agility = [NSNumber numberWithInt:_agility];
    [dic setObject:agility forKey:KEY_AGILITY];

    NSNumber *powerAtk = [NSNumber numberWithInt:_powerAtk];
    [dic setObject:powerAtk forKey:KEY_POWERATK];

    NSNumber *deadlyAtk = [NSNumber numberWithInt:_deadlyAtk];
    [dic setObject:deadlyAtk forKey:KEY_DEADLYATK];

    NSNumber *multipleArrow = [NSNumber numberWithInt:_multipleArrow];
    [dic setObject:multipleArrow forKey:KEY_MULTIPLEARROW];

    NSNumber *poisonArrow = [NSNumber numberWithInt:_poisonArrow];
    [dic setObject:poisonArrow forKey:KEY_POISONARROW];
    
    NSNumber *defender = [NSNumber numberWithInt:_defender];
    [dic setObject:defender forKey:KEY_DEFENDER];
    //玩家技能－－－－－－－－－－－－－－－－－－－
    NSNumber *manaSkill = [NSNumber numberWithInt:_manaSkill_lvl];
    [dic setObject:manaSkill forKey:KEY_MANASKILL];
    
    NSNumber *iceSkill_One = [NSNumber numberWithInt:_iceSkillOne_lvl];
    [dic setObject:iceSkill_One forKey:KEY_ICESKILLONE];
    NSNumber *iceSkill_Two = [NSNumber numberWithInt:_iceSkillTwo_lvl];
    [dic setObject:iceSkill_Two forKey:KEY_ICESKILLTWO];
    NSNumber *iceSkill_Three = [NSNumber numberWithInt:_iceSkillThree_lvl];
    [dic setObject:iceSkill_Three forKey:KEY_ICESKILLTHREE];
    
    NSNumber *fireSkill_One = [NSNumber numberWithInt:_fireSkillOne_lvl];
    [dic setObject:fireSkill_One forKey:KEY_FIRESKILLONE];
    NSNumber *fireSkill_Two = [NSNumber numberWithInt:_fireSkillTwo_lvl];
    [dic setObject:fireSkill_Two forKey:KEY_FIRESKILLTWO];
    NSNumber *fireSkill_Three = [NSNumber numberWithInt:_fireSkillThree_lvl];
    [dic setObject:fireSkill_Three forKey:KEY_FIRESKILLTHREE];
    
    NSNumber *lightSkill_One = [NSNumber numberWithInt:_lightSkillOne_lvl];
    [dic setObject:lightSkill_One forKey:KEY_LIGHTSKILLONE];
    NSNumber *lightSkill_Two = [NSNumber numberWithInt:_lightSkillTwo_lvl];
    [dic setObject:lightSkill_Two forKey:KEY_LIGHTSKILLTWO];
    NSNumber *lightSkill_Three = [NSNumber numberWithInt:_lightSkillThree_lvl];
    [dic setObject:lightSkill_Three forKey:KEY_LIGHTSKILLTHREE];
    
    NSNumber *wall = [NSNumber numberWithInt:_wall];
    [dic setObject:wall forKey:KEY_WALL];
    NSNumber *toewr = [NSNumber numberWithInt:_toewr];
    [dic setObject:toewr forKey:KEY_TOWER];
    NSNumber *moat = [NSNumber numberWithInt:_moat];
    [dic setObject:moat forKey:KEY_MOAT];
    NSNumber *magicPower = [NSNumber numberWithInt:_magicPower];
    [dic setObject:magicPower forKey:KEY_MAGICPOWER];
    NSNumber *spurting = [NSNumber numberWithInt:_spurting];
    [dic setObject:spurting forKey:KEY_SPURTING];
    NSNumber *burn = [NSNumber numberWithInt:_burn];
    [dic setObject:burn forKey:KEY_BURN];
    NSNumber *eatangling = [NSNumber numberWithInt:_eatangling];
    [dic setObject:eatangling forKey:KEY_EATANGLING];
    
    [dic setObject:_bowsArray forKey:KEY_BOWSARRAY];
    //当前弓箭
    NSNumber *currentBowLvl = [NSNumber numberWithInt:_currentBowLvl];
    [dic setObject:currentBowLvl forKey:KEY_CURRENTBOWLVL];

    NSNumber *currentBowType = [NSNumber numberWithUnsignedInteger:_currentBowType];
    [dic setObject:currentBowType forKey:KEY_CURRENTBOWTYPE];
    
    NSNumber *firstSkillType = [NSNumber numberWithInt:_firstSkillType];
    [dic setObject:firstSkillType forKey:KEY_FIRSTSKILL];
    NSNumber *secondSkillType = [NSNumber numberWithInt:_secondSkillType];
    [dic setObject:secondSkillType forKey:KEY_SECONDSKILL];
    NSNumber *thirdSkillType = [NSNumber numberWithInt:_thirdSkillType];
    [dic setObject:thirdSkillType forKey:KEY_THIRDSKILL];
    
    return dic;
}

- (void)convertDicToGameData:(NSMutableDictionary *)dic
{
    //货币
    _coin = [[dic objectForKey:KEY_COIN] intValue];//金币
    _magicStone = [[dic objectForKey:KEY_MAGICSTONE] intValue];//宝石
    _grade = [[dic objectForKey:KEY_GRADE] intValue];//关卡
    _level = [[dic objectForKey:KEY_LEVEL] intValue];//等级
    _currentExp = [[dic objectForKey:KEY_CURRENTEXP] intValue];//当前经验值
    _maxExp = [[dic objectForKey:KEY_MAXEXP] intValue];//升级所需最大经验值
    //玩家属性
    _maxHP = [[dic objectForKey:KEY_MAXHP] intValue];//最大血量
    _maxMP = [[dic objectForKey:KEY_MAXMP] intValue];//最大蓝量
    _strength = [[dic objectForKey:KEY_STRENGTH] intValue];//力量等级
    _agility = [[dic objectForKey:KEY_AGILITY] intValue];//敏捷等级
    _powerAtk = [[dic objectForKey:KEY_POWERATK] intValue];//强力击等级
    _deadlyAtk = [[dic objectForKey:KEY_DEADLYATK] intValue];//致命一击等级
    _multipleArrow = [[dic objectForKey:KEY_MULTIPLEARROW] intValue];//多重箭等级
    _poisonArrow = [[dic objectForKey:KEY_POISONARROW] intValue];//毒箭等级
    _defender = [[dic objectForKey:KEY_DEFENDER] intValue];//守卫者等级

    _manaSkill_lvl = [[dic objectForKey:KEY_MANASKILL] intValue];//魔力研究
    _iceSkillOne_lvl = [[dic objectForKey:KEY_ICESKILLONE] intValue];//冰技能等级1
    _iceSkillTwo_lvl = [[dic objectForKey:KEY_ICESKILLTWO] intValue];//冰技能等级2
    _iceSkillThree_lvl = [[dic objectForKey:KEY_ICESKILLTHREE] intValue];//冰技能等级3
    _fireSkillOne_lvl = [[dic objectForKey:KEY_FIRESKILLONE] intValue];//火技能等级1
    _fireSkillTwo_lvl = [[dic objectForKey:KEY_FIRESKILLTWO] intValue];//火技能等级2
    _fireSkillThree_lvl = [[dic objectForKey:KEY_FIRESKILLTHREE] intValue];//火技能等级3
    _lightSkillOne_lvl = [[dic objectForKey:KEY_LIGHTSKILLONE] intValue];//光技能等级1
    _lightSkillTwo_lvl = [[dic objectForKey:KEY_LIGHTSKILLTWO] intValue];//光技能等级2
    _lightSkillThree_lvl = [[dic objectForKey:KEY_LIGHTSKILLTHREE] intValue];//光技能等级3
    
    _wall = [[dic objectForKey:KEY_WALL] intValue];//城墙
    _toewr = [[dic objectForKey:KEY_TOWER] intValue];//魔法塔
    _moat = [[dic objectForKey:KEY_MOAT] intValue];//岩浆防御
    _magicPower = [[dic objectForKey:KEY_MAGICPOWER] intValue];//魔法力量
    _spurting = [[dic objectForKey:KEY_SPURTING] intValue];//溅射
    _burn = [[dic objectForKey:KEY_BURN] intValue];//灼伤
    _eatangling = [[dic objectForKey:KEY_EATANGLING] intValue];//扰乱岩浆
    
    _bowsArray = [[NSMutableArray alloc] initWithArray:[dic objectForKey:KEY_BOWSARRAY]];

    _currentBowLvl = [[dic objectForKey:KEY_CURRENTBOWLVL] intValue];
    _currentBowType = [[dic objectForKey:KEY_CURRENTBOWTYPE] unsignedIntegerValue];
    
    _firstSkillType = [[dic objectForKey:KEY_FIRSTSKILL] intValue];
    _secondSkillType = [[dic objectForKey:KEY_SECONDSKILL] intValue];
    _thirdSkillType = [[dic objectForKey:KEY_THIRDSKILL] intValue];
    [self setEffectsVolume:1];
    [self setBackgroundMusicVolume:1];
    [self saveEffectsVolume];
    [self saveBackgroundMusicVolume];
}

- (void)save
{
    NSMutableDictionary *d = [self convertGameDataToDic];
    [self saveGameData:d saveFileName:GAMEDATA_FILENAME];
}

-(void) saveEffectsVolume
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithFloat:effectsVolume] forKey:effectsVolumeKey];
}
-(void) saveBackgroundMusicVolume
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithFloat:backgroundMusicVolume] forKey:backgroundMusicVolumeKey];
}
-(float) getEffectsVolume
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    effectsVolume = [[defaults objectForKey:effectsVolumeKey] floatValue];
    return effectsVolume;
}
-(float) getBackgroundMusicVolume
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    backgroundMusicVolume = [[defaults objectForKey:backgroundMusicVolumeKey] floatValue];
    return backgroundMusicVolume;
}


//保存游戏数据
//参数介绍：
//   (NSMutableArray *)data ：保存的数据
//   (NSString *)fileName ：存储的文件名
-(BOOL) saveGameData:(NSMutableDictionary *)data  saveFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        return NO;
    }
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return ([data writeToFile:appFile atomically:YES]);
}
//读取游戏数据
//参数介绍：
//   (NSString *)fileName ：需要读取数据的文件名
-(NSMutableDictionary *) loadGameData:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSMutableDictionary *myData = [[[NSMutableDictionary alloc] initWithContentsOfFile:appFile] autorelease];
    return myData;
}

- (void)dealloc
{
    [_bowsArray release];
    _bowsArray = nil;
    
    [super dealloc];
}

@end
