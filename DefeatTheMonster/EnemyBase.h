//
//  EnemyBase.h
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum{
    EnemyTypeQuanjiniao,
    EnemyTypeManzutu,
    EnemyTypeDuyanguai,
    EnemyTypeXiaoemo,
    EnemyTypeToushiche,
    EnemyTypeBoos
}EnemyType;

@interface EnemyBase : CCSprite
{
    int _attack;        //攻击力
    int _blood;         //血量
    int _currentBlood;  //当前血量
    int _speed;         //速度
    int _money;         //怪物金币
    float _atkDistance; //攻击距离
    int _exp;            //怪物经验值
    
    int grade;          //关卡
    
    ccTime _atkInterval;   //攻击间隔
    ccTime _totalTime;
    ccTime _nextAtkTime;
    
    CGPoint _velocity;
    EnemyType _type;
    
    BOOL _isMoving;      //是否在移动
    BOOL _isAttacking;   //是否在攻击
    BOOL _isLive;       //是否存活
    BOOL _isPoison;     //是否中毒
    BOOL _isFreezed;    //是否冰冻
    BOOL _isBurning;       //是否灼烧
    
    ccTime _burnInterval;    //灼烧
    ccTime _freezedInterval; //冰冻
    //帧动画
    int frameCount_run;
    int frameCount_attack;
    int frameCount_dead;
    NSString *enemyName;
    NSString *enemyColor;
    
    BOOL isBoos;
    
    CCProgressTimer *healthBar;//生命条
}

@property (nonatomic, assign) BOOL isLive;
@property (nonatomic, assign) BOOL isPoison;     //是否中毒
@property (nonatomic, assign) BOOL isFreezed;    //是否冰冻
@property (nonatomic, assign) BOOL isBurning;    //是否灼烧

@property (nonatomic, assign) int money;
@property (nonatomic, assign) int blood;
@property (nonatomic, assign) int currentBlood;
@property (nonatomic, assign) ccTime atkInterval;
@property (nonatomic, assign) EnemyType type;
@property (nonatomic, assign) ccTime burnInterval;
@property (nonatomic, assign) ccTime freezedInterval;
@property (nonatomic, assign) CGPoint velocity;

+ (id)enemyWithType:(EnemyType)type;

- (CGRect)getRect;
- (void)beHurt;
- (void)burn:(float)hurtPerTime;
- (void)showHealthBar;
- (void)gotHit;
- (void)run;
- (void)normalAttack;
- (void)magicAttack;
- (void)die;
- (void)stand;//只有投石车有

@end
