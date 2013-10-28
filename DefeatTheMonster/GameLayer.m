//
//  GameLayer.m
//  DefeatTheMonster
//
//  Created by aatc on 10/9/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "GameLayer.h"
#import "Bow.h"
#import "EnemyCache.h"
#import "ArrowCache.h"
#import "Player.h"

#import "GameData.h"
#import "FinishLayer.h"
#import "StatsLayer.h"
#import "EnemyBase.h"
#import "MenuLayer.h"

#import "Tower.h"

#import "SimpleAudioEngine.h"

#import "Boos.h"

#define BOWPOINT_X 10.f
#define GAMEFRAME 30.f
@implementation GameLayer
@synthesize grade = _grade;

static GameLayer *sharedGameLayer = nil;

+ (GameLayer *)shareGameLayer
{
    NSAssert(sharedGameLayer != nil, @"GameScene instance not yet initialized!");
    return sharedGameLayer;
}

- (id)init
{
    if (self = [super init]) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        sharedGameLayer = self;
        
        player = [[Player alloc] init];
        NSAssert(player != nil, @"player must not be nil");
        GameData *gameData = [GameData shareGameDataInstance];
        _grade = gameData.grade;
        
        CCSprite *bg = [CCSprite spriteWithFile:@"bg1.png"];
        bg.position = ccp(size.width/2, size.height/2);
        [self addChild:bg z:0 tag:1];
        int l = 0;
        if (gameData.grade >= 100) {
            l = 1;
        } else if (gameData.grade >= 200) {
            l = 2;
        }
        CCSprite *wall = [CCSprite spriteWithFile:[NSString stringWithFormat:@"bg_lv%d.png", l]];
        wall.position = ccp(wall.contentSize.width/2, size.height/2);
        [self addChild:wall z:0 tag:1];
        
        CCSprite *wall_broken = [CCSprite spriteWithFile:@"wall_broken_1.png"];
        wall_broken.position = ccp(wall_broken.contentSize.width, size.height/2);
        [self addChild:wall_broken z:0 tag:GameSceneNodeTagWallBroken1];
        wall_broken.visible = NO;
        
        CCSprite *wall_broken2 = [CCSprite spriteWithFile:@"wall_broken_2.png"];
        wall_broken2.position = ccp(wall_broken2.contentSize.width/2, size.height/2);
        [self addChild:wall_broken2 z:0 tag:GameSceneNodeTagWallBroken2];
        wall_broken2.visible = NO;
        //岩浆河
        if (gameData.moat >= 1) {
            CCSprite *river = [CCSprite spriteWithFile:[NSString stringWithFormat:@"river_lv%d.jpg", gameData.moat]];
            river.position = ccp(wall.contentSize.width + river.contentSize.width/2-1, size.height/2);
            [self addChild:river z:0 tag:GameSceneNodeTagRiver];
            
            NSMutableArray *frames = [NSMutableArray arrayWithCapacity:2];
            CCTexture2D *texture1 = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"river_lv%d.jpg", gameData.moat]];
            CCTexture2D *texture2 = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"river_lv%da.jpg", gameData.moat]];
            CCSpriteFrame *frame1 = [CCSpriteFrame frameWithTexture:texture1 rect:CGRectMake(0, 0, texture1.contentSize.width, texture1.contentSize.height)];
            CCSpriteFrame *frame2 = [CCSpriteFrame frameWithTexture:texture2 rect:CGRectMake(0, 0, texture2.contentSize.width, texture2.contentSize.height)];
            [frames addObject:frame1];
            [frames addObject:frame2];
            CCAnimation *riverAni = [CCAnimation animationWithSpriteFrames:frames delay:0.45];
            [river runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:riverAni]]];
        }
        
        _bow = [Bow bowWithType:gameData.currentBowType bowLvl:gameData.currentBowLvl];
        _bow.position = ccp(BOWPOINT_X, size.height/2);
        [self addChild:_bow z:3];
        //下塔
        switch (gameData.toewr) {
            case 1:
            {
                Tower *tower = [Tower node];
                [self addChild:tower z:5];
                tower.position = ccp(52, 116);
                CCMoveBy *by1 = [CCMoveBy actionWithDuration:1 position:ccp(0, 5)];
                CCMoveBy *by2 = [CCMoveBy actionWithDuration:1 position:ccp(0, -5)];
                CCSequence *seqBy = [CCSequence actions:by1, by2, nil];
                [tower runAction:[CCRepeatForever actionWithAction:seqBy]];
            }
                break;
            case 2:
            {
                for (int i = 0; i < 2; i++) {
                    Tower *tower = [Tower node];
                    [self addChild:tower z:5];
                    tower.position = ccp(52, 116 + i * 183);
                    CCMoveBy *by1 = [CCMoveBy actionWithDuration:1 position:ccp(0, 5)];
                    CCMoveBy *by2 = [CCMoveBy actionWithDuration:1 position:ccp(0, -5)];
                    CCSequence *seqBy = [CCSequence actions:by1, by2, nil];
                    [tower runAction:[CCRepeatForever actionWithAction:seqBy]];
                }
            }
                break;
            default:
                break;
        }
    }

    return self;
}
- (void)onEnter
{
    [super onEnter];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"game_bgm.caf" loop:YES];
    CGSize size = [[CCDirector sharedDirector]winSize];
    int singleMaxArrows = size.width / (player.atkSpeed * GAMEFRAME * player.atkInterval) + 100;//30为帧数
    int maxArrows = player.multipleArrow * singleMaxArrows;
    
    GameData *gameData = [GameData shareGameDataInstance];
    
    CCNode *beginSp = [CCSprite spriteWithFile:@"zzzz_stage_title_black.png"];
    CCSprite *grade_word = [CCSprite spriteWithFile:@"stage_title.png"];
    grade_word.position = ccp(beginSp.contentSize.width - 100, beginSp.contentSize.height/2);
    //z_number_list2.png 538 48
    CCLabelAtlas *grade_num = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%i", gameData.grade]
                                  charMapFile:@"z_number_list2.png"
                                    itemWidth:(538.0/10.0/2)
                                   itemHeight:(48/2.0)
                                 startCharMap:'0'];
    grade_num.position = ccp(beginSp.contentSize.width/2+30, beginSp.contentSize.height/2+5);
    grade_num.scaleX = 0.8;
    grade_num.anchorPoint = ccp(0, 0.5);
    
    [beginSp addChild:grade_word];
    [beginSp addChild:grade_num];
    
    [self addChild:beginSp z:5];
    beginSp.position = ccp(size.width/2, size.height/2);
    beginSp.scaleX = 1;
    beginSp.scaleY = 0;
    ArrowCache *arrowCache = [ArrowCache arrowWithMaxArrows:maxArrows name:_bow.bowName level:_bow.level];
    [self initGamePanel];
    
    [self addChild:arrowCache z:2 tag:GameSceneNodeTagArrowCache];
    //开始动画
    CCScaleTo *sc_begin = [CCScaleTo actionWithDuration:0.5 scaleX:1 scaleY:1];
    CCScaleTo *sc = [CCScaleTo actionWithDuration:0.5 scaleX:1 scaleY:0];
    CCCallBlock *block = [CCCallBlock actionWithBlock:^{
        
        EnemyCache *enemyCache = [EnemyCache enemyWithMaxEnemys:10 grade:1];
        [self addChild:enemyCache z:1 tag:GameSceneNodeTagEnemyCache];
        [self scheduleUpdate];
    }];
    
    CCCallBlock *disAppear = [CCCallBlock actionWithBlock:^{
        [beginSp removeFromParentAndCleanup:YES];
    }];
    
    CCSequence *seq = [CCSequence actions:sc_begin, block, [CCDelayTime actionWithDuration:0.8], sc, disAppear, nil];
    [beginSp runAction:seq];
}
//z_number_list.png
- (void) initGamePanel
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCSprite *hp_mp_panel = [CCSprite spriteWithFile:@"blood_panel.png"];
    hp_mp_panel.position = ccp(size.width/2 - 105, size.height/2 - 153);
    [self addChild:hp_mp_panel z:4];

    //=========================================================================================
    //游戏进度
    CCSprite *game_progress_panel = [CCSprite spriteWithFile:@"sword_logo.png"];
    game_progress_panel.position = ccp(size.width/2 + 228, size.height - game_progress_panel.contentSize.height/2 - 5);
    [self addChild:game_progress_panel z:3];
    
    CCSprite *monster_logo = [CCSprite spriteWithFile:@"monster_logo.png"];
    [self addChild:monster_logo z:4 tag:GameSceneNodeTagMonster];
    monster_logo.position = ccp(size.width - 30, size.height - monster_logo.contentSize.height/2);
    
    //=========================================================================================
    //硬币精灵
    CCSprite *coin = [CCSprite spriteWithFile:@"coin.png"];
    coin.position = ccp(size.width/2 - 155, size.height/2 + 145);
    [self addChild:coin z:3];
    
    coin_label = [CCLabelAtlas labelWithString:@"0"
                                   charMapFile:@"z_number3.png"
                                     itemWidth:11
                                    itemHeight:14
                                  startCharMap:'0'];
    coin_label.position = ccp(coin.position.x + coin.contentSize.width/2, coin.position.y);
    coin_label.anchorPoint = ccp(0, 0.5);
    [self addChild:coin_label z:3];
    //=========================================================================================
    //石头精灵
    CCSprite *mana_stone = [CCSprite spriteWithFile:@"mana_stone.png"];
    mana_stone.position = ccp(size.width/2 - 80, coin.position.y);
    [self addChild:mana_stone];
    magicStone_label = [CCLabelAtlas labelWithString:@"0"
                                         charMapFile:@"z_number3.png"
                                           itemWidth:11
                                          itemHeight:14
                                        startCharMap:'0'];
    magicStone_label.position = ccp(mana_stone.position.x + mana_stone.contentSize.width/2, coin.position.y);
    magicStone_label.anchorPoint = ccp(0, 0.5);
    [self addChild:magicStone_label z:3];
    //=========================================================================================
    //关卡精灵
    CCSprite *grade = [CCSprite spriteWithFile:@"small_stage.png"];
    grade.position = ccp(size.width/2 , coin.position.y);
    [self addChild:grade z:3];
    
    grade_label = [CCLabelAtlas labelWithString:@"0"
                                    charMapFile:@"z_number3.png"
                                      itemWidth:11
                                     itemHeight:14
                                   startCharMap:'0'];
    grade_label.position = ccp(grade.position.x + grade.contentSize.width/4, coin.position.y);
    grade_label.anchorPoint = ccp(0, 0.5);
    [self addChild:grade_label z:3];
    
    //=========================================================================================
    //血
    hp_label = [CCLabelAtlas labelWithString:@"0"
                                 charMapFile:@"z_number3.png"
                                   itemWidth:11
                                  itemHeight:14
                                startCharMap:'0'];
    hp_label.scale = 0.6;
    hp_label.position = ccp(hp_mp_panel.position.x - 65, hp_mp_panel.position.y + 15);;
    hp_label.anchorPoint = ccp(0, 0.5);
    [self addChild:hp_label z:4];
    //蓝
    mp_label = [CCLabelAtlas labelWithString:@"0"
                                 charMapFile:@"z_number3.png"
                                   itemWidth:11
                                  itemHeight:14
                                startCharMap:'0'];
    mp_label.scale = 0.6;
    mp_label.position = ccp(hp_mp_panel.position.x - 65, hp_mp_panel.position.y + 5);
    mp_label.anchorPoint = ccp(0, 0.5);
    [self addChild:mp_label z:4];
    
    hp_progressTimer = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"z_blood_piece.png"
                                                                               rect:CGRectMake(0, 0, 90, 7)]];
    hp_progressTimer.position = ccp(hp_label.position.x + 12, hp_label.position.y - 1);//设置中心坐标
    hp_progressTimer.type = kCCProgressTimerTypeBar;//设置横向加载
    hp_progressTimer.barChangeRate = ccp(1,0);
    hp_progressTimer.percentage = 100;
    hp_progressTimer.midpoint = ccp(0,0);
    [self addChild:hp_progressTimer z:3];
    
    mp_progressTimer = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"z_magic_piece.png"
                                                                               rect:CGRectMake(0, 0, 80, 7)]];
    mp_progressTimer.position = ccp(mp_label.position.x + 8, mp_label.position.y);//设置中心坐标
    mp_progressTimer.type = kCCProgressTimerTypeBar;//设置横向加载
    mp_progressTimer.barChangeRate = ccp(1,0);
    mp_progressTimer.percentage = 100;
    mp_progressTimer.midpoint = ccp(0,0);
    [self addChild:mp_progressTimer z:3];
 
    [self resetAltasLabel];
}

- (void)resetAltasLabel
{
    GameData *data = [GameData shareGameDataInstance];
    NSAssert(data != nil, @"Gamedata didnt init");
    
    NSString *coin_str = [NSString stringWithFormat:@"%d", data.coin];
    NSString *magicStone_str = [NSString stringWithFormat:@"%d", data.magicStone];
    NSString *grade_str = [NSString stringWithFormat:@"%d", data.grade];
    
    if (player.HP <= 0) {
        player.HP = 0;
    }
    if (player.MP <= 0) {
        player.MP = 0;
    }
    
    NSString *hp_str = [NSString stringWithFormat:@"%d", player.HP];
    NSString *mp_str = [NSString stringWithFormat:@"%d", player.MP];
    
    
    [coin_label setString:coin_str];
    [magicStone_label setString:magicStone_str];
    [grade_label setString:grade_str];
    [hp_label setString:hp_str];
    [mp_label setString:mp_str];
}

- (void)update:(ccTime)delta
{
    GameData *data = [GameData shareGameDataInstance];
    
    NSAssert(data != nil, @"Gamedata didnt init");
    
    [self resetAltasLabel];
    //游戏胜利
    EnemyCache *enemyCache = [self enemyCache];
    if (enemyCache.wave >= 10 && enemyCache.enemys.count == 0) {
        [self showGameOver:YES];
    }
    //游戏结束
    if ( player.HP <= 0) {
        [self showGameOver:NO];
    }
    
    if (player.HP <= 70 && player.HP > 40) {
        CCNode *node = [self getChildByTag:GameSceneNodeTagWallBroken1];
        node.visible = YES;
    } else if (player.HP <= 40){
        CCNode *node = [self getChildByTag:GameSceneNodeTagWallBroken2];
        node.visible = YES;
    }

    hp_progressTimer.percentage = player.HP / (float)data.maxHP * 100.0f;
    mp_progressTimer.percentage = player.MP / (float)data.maxMP * 100.0f;
    nextAddMpTime += delta;
    if (nextAddMpTime >= 5 && player.MP < data.maxMP) {
        nextAddMpTime = 0;
        player.MP += 1;
    }
    EnemyCache *eCac = [self enemyCache];
    float dis = eCac.wave / (float)10.0;
    
    //256
    CCNode *node = [self getChildByTag:GameSceneNodeTagMonster];
    float x = 450 - (dis * 100.0);
    float y = node.position.y;
    node.position = ccp(x, y);
    
    
    [self checkMoat];
}

- (void)checkMoat
{
    GameData *gameData = [GameData shareGameDataInstance];
    
    CCNode *river = [self getChildByTag:GameSceneNodeTagRiver];
    if (river == nil) {
        return;
    }
    for (EnemyBase *enemy in self.enemyCache.enemys) {
        if (CGRectIntersectsRect(river.boundingBox, enemy.boundingBox) && enemy.isLive) {
            if ( ! enemy.isBurning ) {
                enemy.isBurning = YES;
                [enemy burn:gameData.burn * 5 + 20];
            }
        }
    }
}

- (void)showGameOver:(BOOL)isWin
{
    [self unscheduleAllSelectors];
    EnemyCache *enemyCache = [self enemyCache];
    [enemyCache unscheduleAllSelectors];
    [enemyCache.enemys removeAllObjects];
    if (isWin) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"stagecomplete_bgm.caf"];
        [GameData shareGameDataInstance].grade++;
        CCScene *statsScene = [StatsLayer sceneWithFlag:YES];
        [[CCDirector sharedDirector] replaceScene:statsScene];
    } else {
        [[SimpleAudioEngine sharedEngine] playEffect:@"gameover_bgm.caf"];
        FinishLayer *finish = [FinishLayer node];
        [self.parent addChild:finish z:3];
    }
}
- (ArrowCache *)arrowCache
{
    CCNode* node = [self getChildByTag:GameSceneNodeTagArrowCache];
    NSAssert([node isKindOfClass:[ArrowCache class]], @"not a ArrowCache");
    return (ArrowCache *)node;
}

- (EnemyCache *)enemyCache
{
    CCNode* node = [self getChildByTag:GameSceneNodeTagEnemyCache];
    NSAssert([node isKindOfClass:[EnemyCache class]], @"not a EnemyCache");
    return (EnemyCache *)node;
}

- (Player *)player
{
    return player;
}

- (void)onExit
{
    [super onExit];
    CCLOG(@"%@ : %@", NSStringFromSelector(_cmd), self);
    [self removeAllChildrenWithCleanup:YES];
}

- (void)dealloc
{
    CCLOG(@"%@ : %@", NSStringFromSelector(_cmd), self);
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [sharedGameLayer release];
    sharedGameLayer = nil;
    
    [player release];
    player = nil;
    
    [super dealloc];
}

@end
