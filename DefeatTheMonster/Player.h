//
//  Player.h
//  DefeatTheMonster
//
//  Created by aatc on 10/10/13.
//  Copyright (c) 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bow;
@interface Player : NSObject
{
    int _HP;//最大血量
    int _MP;//最大蓝量
    int _strength;//力量等级
    int _agility;//敏捷等级
    int _powerAtk;//强力击等级
    int _deadlyAtk;//致命一击等级
    int _multipleArrow;//多重箭等级
    int _poisonArrow;//毒箭等级
    int _defender;
    
    int curBurn;
    int curIce;
    int curLight;
    
    int _firstSkillType;
    int _secondSkillType;
    int _thirdSkillType;
    
    int _atk;//伤害
    
    float _atkInterval;//攻击间隔
    float _atkSpeed;
    Bow *_currentBow;
}

@property (nonatomic, assign) int HP;
@property (nonatomic, assign) int MP;
@property (nonatomic, readonly) int strength;
@property (nonatomic, readonly) int agility;
@property (nonatomic, readonly) int powerAtk;
@property (nonatomic, readonly) int deadlyAtk;
@property (nonatomic, readonly) int multipleArrow;
@property (nonatomic, readonly) float atkInterval;//攻击间隔
@property (nonatomic, readonly) float atkSpeed;//射击速度
@property (nonatomic, readonly) int poisonArrow;//毒箭等级
@property (nonatomic, retain) Bow *currentBow;

@property (nonatomic, readonly) int atk;

@property (nonatomic, assign) int curBurn;
@property (nonatomic, assign) int curIce;
@property (nonatomic, assign) int curLight;

@property (nonatomic, readonly) int firstSkillType;
@property (nonatomic, readonly) int secondSkillType;
@property (nonatomic, readonly) int thirdSkillType;

@property (nonatomic, readwrite) int getCoin;
@property (nonatomic, readwrite) int killNum;
@property (nonatomic, readwrite) int life;

@end
