//
//  Player.m
//  DefeatTheMonster
//
//  Created by aatc on 10/10/13.
//  Copyright (c) 2013 nchu. All rights reserved.
//

#import "Player.h"
#import "GameData.h"
#import "Bow.h"

@implementation Player

@synthesize HP = _HP, MP = _MP;
@synthesize agility = _agility, strength = _strength, atk = _atk;
@synthesize deadlyAtk = _deadlyAtk, multipleArrow = _multipleArrow, powerAtk = _powerAtk, poisonArrow = _poisonArrow;
@synthesize atkInterval = _atkInterval, atkSpeed = _atkSpeed;
@synthesize currentBow = _currentBow;
@synthesize getCoin, killNum, life;
@synthesize curBurn, curIce, curLight;
@synthesize firstSkillType = _firstSkillType, secondSkillType = _secondSkillType, thirdSkillType = _thirdSkillType;
- (id)init
{
    if ( self = [super init] ) {
        GameData *gd = [GameData shareGameDataInstance];
        NSAssert(gd != nil, @"gamedata didnt init");
        _HP = gd.maxHP + gd.wall * 10;
        _MP = gd.maxMP + gd.manaSkill_lvl * 20;

        _currentBow = [Bow bowWithType:gd.currentBowType bowLvl:gd.currentBowLvl];
        
        _agility = _currentBow.agility + gd.agility;
        _strength = _currentBow.strength + gd.strength;
        _deadlyAtk = _currentBow.deadlyAtk + gd.deadlyAtk;
        int multipleArrowLvl = _currentBow.multipleArrow + gd.multipleArrow;
        float xishu;
        if (multipleArrowLvl <= 0) {
            _multipleArrow = 1;
            xishu = 1;
        } else if (multipleArrowLvl >= 1 && multipleArrowLvl < 4) {
            _multipleArrow = 2;
            xishu = 0.05 * (multipleArrowLvl-1) + 0.5;
        } else if (multipleArrowLvl >= 4 && multipleArrowLvl < 8) {
            _multipleArrow = 3;
            xishu = 0.05 * (multipleArrowLvl-4) + 0.5;
        } else if (multipleArrowLvl >= 8 && multipleArrowLvl <= 12) {
            _multipleArrow = 4;
            xishu = 0.05 * (multipleArrowLvl-8) + 0.5;
        } else {
            _multipleArrow = 5;
            xishu = 0.02 * (multipleArrowLvl - 5) + 0.5;
        }
        _powerAtk = _currentBow.powerAtk + gd.powerAtk;
        _poisonArrow = gd.poisonArrow;
        _atkInterval = 1.200f - (gd.agility * 2.5 + 15) / (float)86.0;
        _atkSpeed = 10 + (gd.agility * 2.5 + 15) / (float)10;
        //攻击力 ＝ （ 力量＊4 ＋ 20 ）＊ 多重箭系数
        _atk = (_strength * 4 + 20) * xishu;
        
        switch (gd.firstSkillType) {
            case 1:
                curBurn = gd.fireSkillOne_lvl * 30 + 80;
                break;
            case 2:
                curBurn = gd.fireSkillTwo_lvl * 60 + 160;
                break;
            case 3:
                curBurn = gd.fireSkillThree_lvl * 120 + 320;
                break;
            default:
                break;
        }
        switch (gd.secondSkillType) {
            case 1:
                curIce = gd.iceSkillOne_lvl * 15 + 40;
                break;
            case 2:
                curIce = gd.iceSkillTwo_lvl * 30 + 80;
                break;
            case 3:
                curIce = gd.iceSkillThree_lvl * 60 + 160;
                break;
            default:
                break;
        }
        switch (gd.thirdSkillType) {
            case 1:
                curLight = gd.lightSkillOne_lvl * 50 + 100;
                break;
            case 2:
                curLight = gd.lightSkillTwo_lvl * 100 + 200;
                break;
            case 3:
                curLight = gd.lightSkillThree_lvl * 200 + 400;
                break;
            default:
                break;
        }
        _firstSkillType = gd.firstSkillType;
        _secondSkillType = gd.secondSkillType;
        _thirdSkillType = gd.thirdSkillType;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
