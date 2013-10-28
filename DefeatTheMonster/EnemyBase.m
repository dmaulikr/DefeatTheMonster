//
//  EnemyBase.m
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "EnemyBase.h"
#import "MoveComponent.h"
#import "AnimationMaker.h"
#import "GameLayer.h"
#import "Player.h"

#import "GameData.h"
#import "EnemyCache.h"

#import "SimpleAudioEngine.h"

#define WALL_WIDTH 80.f
#define HEALTHBAR_WIDTH 60
#define HEALTHBAR_HEIGHT 5

@implementation EnemyBase

@synthesize isLive = _isLive, isBurning = _isBurning, isFreezed = _isFreezed, isPoison = _isPoison;
@synthesize currentBlood = _currentBlood;
@synthesize money = _money;
@synthesize atkInterval = _atkInterval;
@synthesize type = _type;
@synthesize burnInterval = _burnInterval;
@synthesize freezedInterval = _freezedInterval;
@synthesize velocity = _velocity;

+ (id)enemyWithType:(EnemyType)enemyType
{
    return [[[self alloc] initWithType:enemyType] autorelease];
}

- (id)initWithType:(EnemyType)enemyType
{
    _type = enemyType;
    NSString *name;
    NSString *color;
    NSString *enemyFrameName;
    GameData *data = [GameData shareGameDataInstance];
    int x = data.grade / 80;
    switch (_type) {
        case EnemyTypeDuyanguai:
            name = @"duyanguai";
            color = @"huang";
            enemyFrameName = [NSString stringWithFormat:@"%@_run_%@_0001.png", name, color];
            _attack = 4;        //攻击力
            _blood = 45 + data.grade * 2.25;         //血量
            _speed = 1 + x * 0.2;         //速度
            _atkInterval = 2;   //攻击间隔
            _atkDistance = 1;   //攻击距离
            _money = 4 + arc4random() % 2;
            _exp = 5;
            
            frameCount_run = 7;
            frameCount_attack = 12;
            frameCount_dead = 10;
            break;
        case EnemyTypeManzutu://manzutu_attack_hong_0004.png
            name = @"manzutu";
            color = @"hong";
            enemyFrameName = [NSString stringWithFormat:@"%@_run_%@_0001.png", name, color];
            _attack = 3;        //攻击力
            _blood = 40  + data.grade * 2.25;         //血量
            int maxSpeed = 3.2;
            int speedC = grade / 100;
            int currentSpeed = 2 + speedC * 0.5;
            _speed = currentSpeed <= maxSpeed ? currentSpeed : maxSpeed;         //速度
            _atkInterval = 1.5;   //攻击间隔
            _atkDistance = -10;   //攻击距离
            _money = 3 + arc4random() % 1;
            _exp = 5;
            
            frameCount_run = 6;
            frameCount_attack = 6;
            frameCount_dead = 7;
            break;
        case EnemyTypeQuanjiniao://quanjiniao_attack_lan_0006.png
            name = @"quanjiniao";
            color = @"lan";
            enemyFrameName = [NSString stringWithFormat:@"%@_run_%@_0001.png", name, color];
            _attack = 3;        //攻击力
            _blood = 45  + data.grade * 2.25;         //血量
            _speed = 1.8 + x * 0.2;         //速度
            _atkInterval = 1.5;   //攻击间隔
            _atkDistance = 1;   //攻击距离
            _money = 3 + arc4random() % 1;
            _exp = 5;
            
            frameCount_run = 6;
            frameCount_attack = 10;
            frameCount_dead = 3;
            break;
        case EnemyTypeToushiche://zz_toushiche_stand_0004.png
            name = @"toushiche";
            color = nil;
            enemyFrameName = [NSString stringWithFormat:@"zz_%@_run_0001.png", name];
            _attack = 20 - arc4random() % 4;        //攻击力
            _blood = 160 + data.grade * 2.25 * 4;         //血量
            _speed = 1.5 + x * 0.2;         //速度
            _atkInterval = 5;   //攻击间隔
            _atkDistance = 200;   //攻击距离
            _money = 10 + arc4random() % 2;
            _exp = 10;
            
            frameCount_run = 3;
            frameCount_attack = 6;
            frameCount_dead = 4;
            break;
        case EnemyTypeXiaoemo://xiaoemo_run_zi_0006.png
            name = @"xiaoemo";
            color = @"zi";
            enemyFrameName = [NSString stringWithFormat:@"%@_run_%@_0001.png", name, color];
            _attack = 3;        //攻击力
            _blood = 45 + data.grade * 2.25;         //血量
            _speed = 1 + x * 0.2;         //速度
            _atkInterval = 2;   //攻击间隔
            _atkDistance = 200;   //攻击距离
            _money = 3 + arc4random() % 3;
            _exp = 5;

            frameCount_run = 6;
            frameCount_attack = 10;
            frameCount_dead = 12;
            break;
        default:
            break;
    }
    
    if ( self = [super initWithSpriteFrameName:enemyFrameName] ) {
        _velocity = ccp(-30, 0);
        enemyName = name;
        enemyColor = color;
        _isLive = YES;
        _currentBlood = _blood;
        _isMoving = YES;
        _isAttacking = NO;
        _isLive = YES;
        _isPoison = NO;
        _isFreezed = NO;
        _isBurning = NO;

        switch (data.firstSkillType) {
            case 1:
                _burnInterval = data.fireSkillOne_lvl / 2.0 + 4;
                break;
            case 2:
                _burnInterval = data.fireSkillTwo_lvl / 2.0 + 4;
                break;
            case 3:
                _burnInterval = data.fireSkillThree_lvl / 2.0 + 4;
                break;
            default:
                break;
        }
        switch (data.secondSkillType) {
            case 1:
                _freezedInterval = data.iceSkillOne_lvl / 2.0 + 3;
                break;
            case 2:
                _freezedInterval = data.iceSkillTwo_lvl / 2.0 + 3;
                break;
            case 3:
                _freezedInterval = data.iceSkillThree_lvl / 2.0 + 3;
                break;
            default:
                break;
        }
        _burnInterval = 3;
        _freezedInterval = 3;
        // Create the game logic components
        
        CCSprite *monster_blood_frame = [CCSprite spriteWithFile:@"monster_blood_frame.png"];
        CCSprite *healthSp = [CCSprite spriteWithFile:@"z_monster_blood_piece.png" rect:monster_blood_frame.boundingBox];
        healthBar = [CCProgressTimer progressWithSprite:healthSp];
        [healthBar addChild:monster_blood_frame z:1 tag:1];
        monster_blood_frame.position = ccp(healthBar.contentSize.width/2, healthBar.contentSize.height/2);
        if ( _type == EnemyTypeToushiche) {
            healthBar.position = ccp(self.contentSize.width/2 - 10, self.contentSize.height - 25);//设置中心坐标
        } else {
            healthBar.position = ccp(self.contentSize.width/2, self.contentSize.height);//设置中心坐标
        }
        
        healthBar.type = kCCProgressTimerTypeBar;//设置横向加载
        healthBar.barChangeRate = ccp(1,0);
        healthBar.percentage = 100;
        healthBar.midpoint = ccp(0,0);
        healthBar.visible = NO;
		[self addChild:healthBar];
		// enemies start invisible
		self.visible = YES;
        [self scheduleUpdate];
        [self run];
    }
    
    return self;
}

- (CGRect)getRect
{
    CGRect bbox = [super boundingBox];
    
    int width = bbox.size.width/2;
    int height = bbox.size.height;
    
    int x = bbox.origin.x + width + self.offsetPosition.x;
    int y = bbox.origin.y;
    CGRect realBoundingBox;
    if (_type == EnemyTypeToushiche) {
        height /= 2;
        realBoundingBox = CGRectMake(x, y, width, height);
    } else {
        realBoundingBox = CGRectMake(x, y - 10, width, height - 10);
    }
    
    return realBoundingBox;
}

-(void) update:(ccTime)delta
{
    if (self.currentBlood <= 0) {
        [self die];
        return;
    }
    //不可见时
    if ( ! self.visible || ! _isLive) {
        [self die];
        return;
    }
    _totalTime += delta;
    //是否冰冻
    if ( _isFreezed && _type != EnemyTypeToushiche) {
        if (_blood <= 0) {
            [self die];
            return;
        }
        [self stopAllActions];
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@_dong_%@_0001.png",enemyName,enemyColor]]];
        [self scheduleOnce:@selector(unfreeze:) delay:_freezedInterval];
        [self unscheduleUpdate];
        
        return;
    }
    //检测攻击范围内
    float dis = self.position.x - self.contentSize.width / 2 - _atkDistance;
    if ( dis <= WALL_WIDTH) {
        if ( _isMoving ) {
            [self stopAllActions];
            _isMoving = NO;
        }
        if ( ! _isAttacking ) {
            if (_type == EnemyTypeToushiche) {
                _nextAtkTime = _totalTime + _atkInterval;
                [self stand];
            }
            _isAttacking = YES;
        }
        if (_totalTime > _nextAtkTime)
        {
            _nextAtkTime = _totalTime + _atkInterval;
            if (_type == EnemyTypeToushiche || _type == EnemyTypeXiaoemo) {
                if ( _type == EnemyTypeToushiche) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"stone_fix.caf"];
                }
                [self magicAttack];
            } else {
                [self normalAttack];
            }
        }
    } else {
        if ( ! _isMoving ) {
            _isMoving = YES;
            [self run];
        }
    }
    if (_isMoving){
        self.position = ccpAdd(self.position, ccpMult(_velocity, delta * _speed));
        if (EnemyTypeToushiche == _type) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"stone_move.caf"];
        }
    }
}

- (void)burn:(float)hurtPerTime
{
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"burn_0001.png"];
    CCAnimation *animation = [AnimationMaker animationWithFrame:@"burn_000" frameCount:6 delay:0.15];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
    CCCallBlock *deHPBlock = [CCCallBlock actionWithBlock:^{
        _currentBlood -= (int)hurtPerTime;
        //死亡
        [self beHurt];
        if (_currentBlood <= 0)
        {
            _isLive = NO;
            _isBurning = NO;
            [self die];
            [sprite removeFromParentAndCleanup:YES];
        }
    }];
    CCSequence *se = [CCSequence actions:animate, deHPBlock, nil];
    CCRepeat *re = [CCRepeat actionWithAction:se times:(NSInteger)(_burnInterval/0.9)];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        _isBurning = NO;
        [sprite removeFromParentAndCleanup:YES];
    }];
    CCSequence *seq = [CCSequence actions:re, block, nil];
    [self addChild:sprite];
    sprite.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [sprite runAction:seq];
}

- (void)unfreeze:(ccTime)delta
{
    if (_currentBlood <= 0) {
        [self die];
        return;
    }
    
    _isFreezed = NO;
    if ( _isMoving ) {
        [self run];
    }
    if ( _isAttacking ) {
        [self normalAttack];
    }
    [self unscheduleUpdate];
    [self scheduleUpdate];
}

- (void)showHealthBar
{
    CCNode *node = [healthBar getChildByTag:1];
    NSAssert(node != nil, @"healthBar node is empty");
    healthBar.percentage = _currentBlood / (float)_blood * 100;
    CCFadeOut *fout = [CCFadeOut actionWithDuration:2];
    CCCallBlock *showBlock = [CCCallBlock actionWithBlock:^{
        [node runAction:[CCShow action]];
    }];
    CCCallBlock *hideBlock = [CCCallBlock actionWithBlock:^{
        [node runAction:[CCFadeOut actionWithDuration:2]];
    }];
    CCSpawn *sp = [CCSpawn actions:hideBlock, fout, nil];
    CCSequence *seq = [CCSequence actions:showBlock, [CCShow action], sp, nil];
    [healthBar runAction:seq];
}

- (void)gotHit
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"behit.wav"];
    Player *player = [GameLayer shareGameLayer].player;
    
    int r = arc4random() % 100;
    
    if (r <= (player.deadlyAtk * 5 + 5)) {
        _currentBlood = _currentBlood - player.atk * 2;
        CCSprite *doublehit = [CCSprite spriteWithFile:@"critical_hit.png"];
        
        CCMoveBy *moveBy = [CCMoveBy actionWithDuration:0.2 position:ccp(doublehit.position.x, doublehit.position.y + 10)];
        CCCallBlock *block = [CCCallBlock actionWithBlock:^{
            [doublehit removeFromParentAndCleanup:YES];
        }];
        CCSpawn *spawn = [CCSpawn actions:moveBy, [CCFadeIn actionWithDuration:0.1], nil];
        CCSequence *seq = [CCSequence actions:spawn, [CCFadeOut actionWithDuration:0.5], block, nil];
        [doublehit runAction:seq];
        [self.parent addChild:doublehit];
        doublehit.position = ccp(self.position.x + 20, self.position.y + self.contentSize.height/2);
    } else {
        _currentBlood -= player.atk ;
    }
	
    //死亡
    [self beHurt];
	if (_currentBlood <= 0)
	{
        _isLive = NO;
        [self die];
        return;
	}
    //击退
    if (_type != EnemyTypeToushiche && player.powerAtk == 0) {
        CGPoint pos = self.position;
        if (isBoos) {
            self.position = ccp(pos.x + player.powerAtk / 2 + 1, pos.y);
        } else {
            self.position = ccp(pos.x + player.powerAtk + 1, pos.y);
        }
    }
    //减慢攻击速度
    if ( ! _isPoison && player.poisonArrow >= 1) {
        _isPoison = YES;
        _atkInterval = (player.poisonArrow * 5.f / 100.f + 1) * _atkInterval;
    }

}
//duyanguai_run_huang_0001.png
//zz_toushiche_run_0003.png

- (void)beHurt
{
    CCTintTo *tintTo = [CCTintTo actionWithDuration:0.2 red:158 green:11 blue:15];
    CCTintTo *tintToBack = [CCTintTo actionWithDuration:0.1 red:255 green:255 blue:255];
    CCAction *re = [CCSequence actions:tintTo, tintToBack, nil];
    [self runAction:re];
    
    [self showHealthBar];
}

- (void)run
{
    float delay = 1.0 / frameCount_run;
    NSString *frameName;
    if ( _type == EnemyTypeToushiche ) {
         frameName = @"zz_toushiche_run";
    } else {
        frameName = [NSString stringWithFormat:@"%@_run_%@", enemyName, enemyColor];
    }
    CCAnimation *moveAnimation = [AnimationMaker moveAnimationWithName:frameName
                                                      frameCount:frameCount_run
                                                           delay:delay];
    CCAnimate *moveAnimate = [CCAnimate actionWithAnimation:moveAnimation];
    
    [self runAction:[CCRepeatForever actionWithAction:moveAnimate]];
}

- (void)normalAttack
{
    float delay = 1.0 / frameCount_attack;
    NSString *frameName;
    if ( _type == EnemyTypeToushiche ) {
        frameName = @"zz_toushiche_attack";
    } else {
        frameName = [NSString stringWithFormat:@"%@_attack_%@", enemyName, enemyColor];
    }
    CCAnimation *attackAnimation = [AnimationMaker moveAnimationWithName:frameName
                                                            frameCount:frameCount_attack
                                                                 delay:delay];
    CCAnimate *attackAnimate = [CCAnimate actionWithAnimation:attackAnimation];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        GameLayer *gameLayer = [GameLayer shareGameLayer];
        gameLayer.player.HP -= _attack;
        if (gameLayer.player.HP <= 0) {
            gameLayer.player.HP = 0;
        }
    }];
    CCTintTo *tintToBack = [CCTintTo actionWithDuration:0.1 red:255 green:255 blue:255];
    CCSequence *seq = [CCSequence actions:tintToBack, attackAnimate, block, nil];
    [self runAction:seq];
}

- (void)magicAttack
{
//    fire_devil_0001-6.png
    float delay = 1.0 / frameCount_attack;
    NSString *frameName;
    GameLayer *gameLayer = [GameLayer shareGameLayer];
    if ( _type == EnemyTypeToushiche ) {
        frameName = @"zz_toushiche_attack";
    } else {
        frameName = [NSString stringWithFormat:@"%@_attack_%@", enemyName, enemyColor];
    }
    
    CCAnimation *attackAnimation = [AnimationMaker moveAnimationWithName:frameName
                                                              frameCount:frameCount_attack
                                                                   delay:delay];
    CCAnimate *attackAnimate = [CCAnimate actionWithAnimation:attackAnimation];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        
        if (_type == EnemyTypeXiaoemo) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"devil_fireball_shot.wav"];
            CCSprite *sp = [CCSprite spriteWithSpriteFrameName:@"fire_devil_0001.png"];
            CCAnimation *ani = [AnimationMaker animationWithFrame:@"fire_devil_000" frameCount:6 delay:0.1];
            CCMoveTo *mt = [CCMoveTo actionWithDuration:0.5 position:ccp(85, self.position.y)];
            CCCallBlock *block = [CCCallBlock actionWithBlock:^{
                CGPoint p = sp.position;
                [sp removeFromParentAndCleanup:YES];//fire_devil_blast_0001-6.png
                CCSprite *boom = [CCSprite spriteWithSpriteFrameName:@"fire_devil_blast_0001.png"];
                CCAnimation *ani_boom = [AnimationMaker animationWithFrame:@"fire_devil_blast_000" frameCount:6 delay:0.1];
                CCCallBlock *block_boom = [CCCallBlock actionWithBlock:^{
                    gameLayer.player.HP -= _attack;
                    if (gameLayer.player.HP <= 0) {
                        gameLayer.player.HP = 0;
                    }
                    [boom removeFromParentAndCleanup:YES];
                }];
                CCSequence *seq_boom = [CCSequence actions:[CCAnimate actionWithAnimation:ani_boom], block_boom,nil];
                [boom runAction:seq_boom];
                [self.parent addChild:boom];
                boom.position = p;
            }];
            [sp runAction:[CCAnimate actionWithAnimation:ani]];
            CCSequence *seq = [CCSequence actions:mt, block, nil];
            [sp runAction:seq];
            [self.parent addChild:sp];
            sp.position = ccp(self.position.x - 5, self.position.y+20);
        } else if (_type == EnemyTypeToushiche){
            [[SimpleAudioEngine sharedEngine] playEffect:@"devil_fireball_blast.wav"];
            CCSprite *sp = [CCSprite spriteWithSpriteFrameName:@"zz_stone_001.png"];
            CCAnimation *ani = [AnimationMaker animationWithFrame:@"zz_stone_00" frameCount:5 delay:0.1];
            sp.rotation = 30;
            CCRotateBy *rotate = [CCRotateBy actionWithDuration:(0.5f/8.0f) angle:-6];
            CCRepeat *repeat = [CCRepeat actionWithAction:rotate times:8];
            ccBezierConfig c = {
                ccp(-270, 5),
                ccp(-100, 70),
                ccp(-150, 120)
            };
            CCBezierBy *by = [CCBezierBy actionWithDuration:0.5f bezier:c];
            CCSpawn *byandre = [CCSpawn actions:repeat, by, nil];
            CCCallBlock *block = [CCCallBlock actionWithBlock:^{
                [sp removeFromParentAndCleanup:YES];//fire_devil_blast_0001-6.png
                gameLayer.player.HP -= _attack;
                if (gameLayer.player.HP <= 0) {
                    gameLayer.player.HP = 0;
                }
            }];
            [sp runAction:[CCAnimate actionWithAnimation:ani]];
            CCSequence *seq = [CCSequence actions:byandre, block, nil];
            [sp runAction:seq];
            [self.parent addChild:sp];
            sp.position = ccp(self.position.x + 10, self.position.y+20);
        }
    }];
    CCSequence *seq = [CCSequence actions:[CCDelayTime actionWithDuration:0.4], block, nil];
    CCSpawn *spawn = [CCSpawn actions:attackAnimate, seq, nil];
    [self runAction:spawn];
}

- (void)die
{
    [self unscheduleAllSelectors];
    [self stopAllActions];
 //   healthBar.visible = NO;
    NSString *frameName;
    if ( _type == EnemyTypeToushiche ) {
        frameName = @"zz_toushiche_dead";
    } else {
        frameName = [NSString stringWithFormat:@"%@_dead_%@", enemyName, enemyColor];
    }
    CCAnimation *deadAnimation = [AnimationMaker moveAnimationWithName:frameName
                                                            frameCount:frameCount_dead
                                                                 delay:0.15];
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

- (void)stand
{
    float delay = 1.0 / frameCount_attack;
    CCAnimation *standAnimation = [AnimationMaker moveAnimationWithName:@"zz_toushiche_stand"
                                                            frameCount:frameCount_attack
                                                                 delay:delay];
    CCAnimate *standAnimate = [CCAnimate actionWithAnimation:standAnimation];
    [self runAction:standAnimate];
}

- (void)dealloc
{
    [enemyName release];
    enemyName = nil;
    [enemyColor release];
    enemyColor = nil;
    
    [super dealloc];
}

@end
