//
//  Tower.m
//  DefeatTheMonster
//
//  Created by wujiajing on 13-10-24.
//  Copyright 2013年 nchu. All rights reserved.
//

#import "Tower.h"

#import "GameLayer.h"
#import "EnemyCache.h"
#import "EnemyBase.h"
#import "GameData.h"

const float SUPRTWIDTH = 50.0;
const float SUPRTHEIGHT = 50.0;

@implementation Tower

- (id)init
{
    if (self = [super init]) {
        
        tower = [CCSprite spriteWithFile:@"normal_lv1.png"];
        [self addChild:tower z:2];
        tower.position = ccp(self.contentSize.width/2+2, self.contentSize.height/2 - tower.contentSize.height+4);
    
        CCSprite *light_bg = [CCSprite spriteWithFile:@"normal_001.png"];
        [self addChild:light_bg z:1];
        light_bg.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        
        NSMutableArray *frames = [NSMutableArray arrayWithCapacity:10];
        for (int i = 1; i <= 10; i++) {
            NSString *file = [NSString stringWithFormat:@"normal_00%i.png", i];
            if (i == 10) {
                file = [NSString stringWithFormat:@"normal_0%i.png", i];
            }
            CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:file];
            CGSize texSize = texture.contentSize;
            CGRect texRect = CGRectMake(0, 0, texSize.width, texSize.height);
            
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rect:texRect];
            [frames addObject:frame];
        }
        CCAnimation *ani = [CCAnimation animationWithSpriteFrames:frames delay:0.2];
        
        [light_bg runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:ani]]];
        
        atkInterval = 5.f;
        atkDistance = self.position.x + 250;
        
        [self scheduleUpdate];
    }
    
    return self;
}

- (BOOL)atk
{
    GameLayer *gameLayer = [GameLayer shareGameLayer];
    GameData *gameData = [GameData shareGameDataInstance];
    //  Player *player = gameLayer.player;
  //  CGRect rect = CGRectMake(0, 0, SUPRTWIDTH, SUPRTHEIGHT);
    NSMutableArray *array = gameLayer.enemyCache.enemys;
    if (array.count == 0) {
        return NO;
    }
    int rand = arc4random() % array.count;
    EnemyBase *enemy = [array objectAtIndex:rand];
    if (enemy.position.x >= atkDistance) {
        return NO;
    }
    CCSprite *sprite = [CCSprite spriteWithFile:@"normal_lv1.png"];
    sprite.position = self.position;
    [self.parent addChild:sprite z:10];

    CGPoint enemyPos = ccpSub(enemy.position, ccp(10,0));//怪物起始坐标 已知
    CGPoint myPos = sprite.position;//我的起始坐标 已知
    CGPoint endPos;//最终相遇坐标
    CGPoint enemyVelocity = enemy.velocity;
    ccTime time;//到达所用时间
    float speed = 300;//子弹速度 已知
    float s = ccpDistance(enemyPos, myPos);//距离 已知
    time = s / speed;//已知
    endPos = ccpAdd(enemyPos, ccpMult(enemyVelocity, time));
    if (endPos.x <= 80.0) {
        float endY = endPos.y;
        endPos = ccp(80, endY);
        time = ccpDistance(enemyPos, endPos) / speed;
    }
    ccBezierConfig bezierConfig = {
        ccpSub(endPos, myPos),
        ccp(10, 10),
        ccp(0, 0),
    };
    CCBezierBy *bezier = [CCBezierBy actionWithDuration:time bezier:bezierConfig];
    CCCallBlock *hit = [CCCallBlock actionWithBlock:^{
        enemy.currentBlood -= gameData.magicPower * 5 + 40;
        [enemy beHurt];
    }];
    //爆炸动画
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:10];
    for (int i = 1; i <= 10; i++) {
        NSString *file = [NSString stringWithFormat:@"fire_blast_0%i.png", i];
        if (i == 10) {
            file = [NSString stringWithFormat:@"fire_blast_%i.png", i];
        }
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
        [frames addObject:frame];
    }
    
    CCAnimation *ani = [CCAnimation animationWithSpriteFrames:frames delay:0.1];
    CCCallBlock *boom = [CCCallBlock actionWithBlock:^{
        CGRect rect = sprite.boundingBox;
        for (EnemyBase *e in array) {
            NSAssert([e isKindOfClass:[EnemyBase class]], @"GameLyaer-110:e is not a EnemyBase instance!");
            if (CGRectIntersectsRect(e.boundingBox, rect)) {
                e.currentBlood -= (gameData.magicPower * 5 + 40) * (gameData.spurting * 5 + 5) / 100;
                [e beHurt];
            }
        }
        [sprite removeFromParentAndCleanup:YES];
    }];
    CCSequence *seq = [CCSequence actions:bezier, hit, [CCAnimate actionWithAnimation:ani], [CCHide action], boom, nil];
    [sprite runAction:seq];
    return YES;
}

- (void)update:(ccTime)delta
{
    nextAtkTime += delta;
    if (nextAtkTime > atkInterval && [self atk]) {
        nextAtkTime = 0;
        return;
    }
}
@end
