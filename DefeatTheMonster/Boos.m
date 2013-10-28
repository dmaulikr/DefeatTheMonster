//
//  Boos.m
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright (c) 2013 nchu. All rights reserved.
//

#import "Boos.h"
#import "AnimationMaker.h"

#import "GameData.h"
#import "GameLayer.h"
#import "Player.h"
#import "EnemyCache.h"

#import "SimpleAudioEngine.h"

@implementation Boos

+ (id)boosWithSpriteFrameName:(NSString *)spriteFrameName
{
    return [[[Boos alloc] initWithSpriteFrameName:spriteFrameName] autorelease];
}

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName
{
    if (self = [super initWithSpriteFrameName:spriteFrameName]) {
        grade = [GameData shareGameDataInstance].grade;//关卡
        _attack = 20;        //攻击力
        _blood = 200 + grade * 10;         //血量
        _currentBlood = _blood;  //当前血量
        _speed = 70 + grade / 100;         //速度
        _money = 100 + grade * 10;         //怪物金币
        _atkDistance = 5; //攻击距离
        _exp = 100;            //怪物经验值
    
        _isMoving = YES;      //是否在移动
        _isAttacking = NO;   //是否在攻击
        _isLive = YES;       //是否存活
        isBoos = YES;
        _type = EnemyTypeBoos;
        
        _nextAtkTime = 0;
        _atkInterval = 1.5;
        
        nextSkill = 0;
        userSkillInterval = 5;

        CCSprite *monster_blood_frame = [CCSprite spriteWithFile:@"monster_blood_frame.png"];
        CCSprite *healthSp = [CCSprite spriteWithFile:@"z_monster_blood_piece.png" rect:monster_blood_frame.boundingBox];
        healthBar = [CCProgressTimer progressWithSprite:healthSp];
        [healthBar addChild:monster_blood_frame z:1 tag:1];
        monster_blood_frame.position = ccp(healthBar.contentSize.width/2, healthBar.contentSize.height/2);
        healthBar.position = ccp(self.contentSize.width/2, self.contentSize.height - 30);//设置中心坐标
        
        healthBar.type = kCCProgressTimerTypeBar;//设置横向加载
        healthBar.barChangeRate = ccp(1,0);
        healthBar.percentage = 100;
        healthBar.midpoint = ccp(0,0);
        healthBar.visible = NO;
		[self addChild:healthBar];
        
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)run
{
//    emolingzhu_run_0001.png
    CGPoint endPos = ccp(80 + self.contentSize.width/2, self.position.y);
   // CGPoint endPos = ccp(80, 160);
    float distance = ccpDistance(endPos, self.position);
    ccTime duration = distance / _speed;
    NSString *frameName = @"emolingzhu_run_000";

    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:6];
    for (int i = 1; i <= 6; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                spriteFrameByName:[NSString stringWithFormat:@"%@%d.png", frameName, i]];
        [frames addObject:frame];
    }
    
    CCAnimate *ani = [CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.1]];
    [self runAction:[CCRepeatForever actionWithAction:ani]];
    CCCallBlock *afterMove = [CCCallBlock actionWithBlock:^{
        _isMoving = NO;
        _isAttacking = YES;
        [self stopAllActions];
        [self normalAttack];
    }];
    CCSequence *seq = [CCSequence actions: [CCMoveTo actionWithDuration:duration position:endPos], afterMove, nil];
    [self runAction:seq];
}

- (void)normalAttack
{
    if (_nextAtkTime > _atkInterval) {
        _nextAtkTime = 0;
    } else {
        return;
    }
    //emolingzhu_attack_0011.png
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:11];
    for (int i = 1; i <= 11; i++) {
        NSString *frameName;
        if (i < 10) {
            frameName = [NSString stringWithFormat:@"emolingzhu_attack_000%i.png", i];
        } else {
            frameName = [NSString stringWithFormat:@"emolingzhu_attack_00%i.png", i];
        }
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [frames addObject:frame];
    }
    
    CCAnimate *ani = [CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.15]];
    CCCallBlock *atkBlock = [CCCallBlock actionWithBlock:^{
        [[SimpleAudioEngine sharedEngine] playEffect:@"09_wall_behit.mp3"];
        Player *player = [GameLayer shareGameLayer].player;
        player.HP -= _attack;
        [self normalAttack];
    }];
    
    CCSequence *seq = [CCSequence actions:ani, atkBlock, nil];
    [self runAction:seq];
}

- (void)magicAttack
{
//    emolingzhu_skill_0009.png elect_0010.png
    //然后始发动作，然后放出风
    NSMutableArray *boos_frames = [NSMutableArray arrayWithCapacity:9];
    for (int i = 1; i <= 9; i++) {
        NSString *frameName = [NSString stringWithFormat:@"emolingzhu_skill_000%i.png", i];
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [boos_frames addObject:frame];
    }
    CCAnimate *ani = [CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:boos_frames delay:0.15]];
    CCCallBlock *afterMove = [CCCallBlock actionWithBlock:^{
        CCSprite *wind = [CCSprite spriteWithSpriteFrameName:@"boss_store_001.png"];
        NSMutableArray *frames = [NSMutableArray arrayWithCapacity:9];
        for (int i = 3; i <= 10; i++) {
            NSString *frameName;
            if (i<10) {
                frameName = [NSString stringWithFormat:@"elect_000%i.png", i];
            } else {
                frameName = [NSString stringWithFormat:@"elect_00%i.png", i];
            }
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
            [frames addObject:frame];
        }
        CCAnimate *ani = [CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:frames delay:0.1]];
        
        CGPoint endPos = ccp(80, self.position.y);
        // CGPoint endPos = ccp(80, 160);
        float distance = ccpDistance(endPos, wind.position);
        ccTime duration = distance / _speed;
        
        CCMoveTo *windMove = [CCMoveTo actionWithDuration:duration position:endPos];
        CCCallBlock *windBlock = [CCCallBlock actionWithBlock:^{
            [wind removeFromParentAndCleanup:YES];
            [GameLayer shareGameLayer].player.HP -= 20;
        }];
        [wind runAction:[CCRepeatForever actionWithAction:ani]];
        CCSequence *fire_seq = [CCSequence actions:windMove, windBlock, nil];
        [wind runAction:fire_seq];
        [self.parent addChild:wind];
        wind.position = self.position;
    }];
    
    CCCallBlock *finalBlock = [CCCallBlock actionWithBlock:^{
        isUsingSkill = NO;
        [self run];
    }];
    CCSequence *seq = [CCSequence actions:ani, afterMove, finalBlock,nil];
    [self runAction:seq];
}

//summon召唤
- (void)summon
{
    //emolingzhu_summon_0008.png
    NSMutableArray *boos_frames = [NSMutableArray arrayWithCapacity:9];
    for (int i = 1; i <= 8; i++) {
        NSString *frameName = [NSString stringWithFormat:@"emolingzhu_summon_000%i.png", i];
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [boos_frames addObject:frame];
    }
    CCAnimate *ani = [CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:boos_frames delay:0.15]];
    
    CCCallBlock *finalBlock = [CCCallBlock actionWithBlock:^{
        EnemyCache *cache = [[GameLayer shareGameLayer] enemyCache];
        [cache createEnemyWithGrade:grade];
        isUsingSkill = NO;
        [self run];
    }];
    CCSequence *seq = [CCSequence actions:ani, finalBlock, nil];
    [self runAction:seq];
    
}

- (void)die
{
    //emolingzhu_deid_0011.png
    [self unscheduleAllSelectors];
    [self stopAllActions];
    //   healthBar.visible = NO;
    NSString *frameName = @"emolingzhu_deid";

    CCAnimation *deadAnimation = [AnimationMaker moveAnimationWithName:frameName
                                                            frameCount:11
                                                                 delay:0.1];
    CCAnimate *deadAnimate = [CCAnimate actionWithAnimation:deadAnimation];
    CCTintTo *tintToBack = [CCTintTo actionWithDuration:0 red:255 green:255 blue:255];
    CCCallBlock *dieBlock = [CCCallBlock actionWithBlock:^{
        EnemyCache *cache = [[GameLayer shareGameLayer] enemyCache];
        GameData *gameData = [GameData shareGameDataInstance];
        Player *player = [[GameLayer shareGameLayer] player];
        player.killNum++;
        
        gameData.coin += _money;
        player.getCoin += _money;
        [gameData save];
        [cache.enemys removeObject:self];
        [self removeFromParentAndCleanup:YES];
    }];
    [self runAction:[CCSequence actions:tintToBack,
                     deadAnimate,
                     [CCFadeOut actionWithDuration:0.2],
                     dieBlock, nil]];
}

-(void) update:(ccTime)delta
{
    _isPoison = NO;     //是否中毒
    _isFreezed = NO;    //是否冰冻
    _isBurning = NO;
    _nextAtkTime += delta;
    if (self.currentBlood <= 0) {
        [self die];
        return;
    }
    //使用技能
  //  ccTime userSkillInterval;
//    ccTime nextSkill;
    nextSkill += delta;
    if (nextSkill <= userSkillInterval) {
        return;
    }
    nextSkill = 0;
    if ( ! isUsingSkill && self.position.x <= 460) {
        isUsingSkill = YES;
        [self stopAllActions];
        int r = arc4random() % 100;
        if (r < 100 && r >= 70) {
            _isMoving = NO;
            [self magicAttack];
        } else if (r < 70 && r >= 40){
            [self summon];
        } else {
            isUsingSkill = NO;
            [self run];
        }
    }
}

@end
