//
//  StatsLayer.m
//  DefeatTheMonster
//
//  Created by 彭生辉 on 13-10-15.
//  Copyright 2013年 nchu. All rights reserved.
//

#import "StatsLayer.h"
#import "ResearchLayer.h"

#import "GameData.h"
#import "Player.h"
#import "GameLayer.h"
#import "SimpleAudioEngine.h"

@implementation StatsLayer

+ (id)sceneWithFlag:(BOOL)isWin
{
    CCScene *scene = [CCScene node];
    StatsLayer *statsLayer = [[[StatsLayer alloc] initWithFlag:isWin] autorelease];
    [scene addChild:statsLayer];
    
    return scene;
}
- (id)initWithFlag:(BOOL)isWin
{
    self = [super init];
    if (self)
    {
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        GameData *gameData = [GameData shareGameDataInstance];
        NSAssert(gameData != nil, @"StatsLayer : initExperence : gameData is nil");
            //背景
        CCSprite *bgSprite = [CCSprite spriteWithFile:@"stats_local_bg.png"];
        bgSprite.position = ccp(winSize.width/2,winSize.height/2);
        [self addChild:bgSprite z:0];
        _isWin = isWin;
        if (_isWin)
        {
            //关卡胜利
            CCSprite *winSprite = [CCSprite spriteWithFile:@"stats_win_fg.png"];
            [winSprite setPosition:ccp(winSize.width/2, winSize.height/2+90)];
            [self addChild:winSprite];
        }
        else
        {
            //关卡失败
            CCSprite *failSprite = [CCSprite spriteWithFile:@"stats_failed_fg.png"];
            [failSprite setPosition:ccp(winSize.width/2, winSize.height/2+90)];
            [self addChild:failSprite];
        }
        
        //杀敌
        CCSprite *killSprite = [CCSprite spriteWithFile:@"stats_piece_kills.png"];
        [killSprite setPosition:ccp(winSize.width/2, 125)];
        [self addChild:killSprite];
        //生命
        CCSprite *lifeSprite = [CCSprite spriteWithFile:@"stats_piece_life.png"];
        [lifeSprite setPosition:ccp(winSize.width/2, 95)];
        [self addChild:lifeSprite];
        ////点击屏幕继续////
        CCLabelTTF *continueLabel = [CCLabelTTF labelWithString:@"点击屏幕继续" fontName:@"Marker Felt" fontSize:14];
        [self addChild:continueLabel];
        continueLabel.position = ccp(winSize.width/2, 15);
        //逐渐消失动画//blink是直接闪烁，没有渐变效果
        CCFadeOut *fout = [CCFadeOut actionWithDuration:0.5];
        //逐渐出现动画
        CCReverseTime *rever = [CCReverseTime actionWithAction:fout];
        CCSequence *seq = [CCSequence actions:fout, rever, nil];
        //无限重复动画
        CCRepeatForever *re = [CCRepeatForever actionWithAction:seq];
        [continueLabel runAction:re];
        self.touchEnabled = YES;
        [self initExperence:isWin];
    }
    
    return self;
}

- (void)initExperence:(BOOL)isWin
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    GameData *gameData = [GameData shareGameDataInstance];
    NSAssert(gameData != nil, @"StatsLayer : initExperence : gameData is nil");
    GameLayer *gameLayer = [GameLayer shareGameLayer];
    Player *player = [gameLayer player];
    //等级经验进度外框
    CCSprite *experienceSprite = [CCSprite spriteWithFile:@"z_ex_panel.png"];
    experienceSprite.position = ccp(size.width/2, 198);
    [self addChild:experienceSprite z:1];
    //进度的显示
    CGRect rect = CGRectMake(0, 0, experienceSprite.contentSize.width-35, experienceSprite.contentSize.height);
    CCSprite *pieceSprite = [CCSprite spriteWithFile:@"z_ex_piece.png" rect:rect];
    CCProgressTimer *time = [CCProgressTimer progressWithSprite:pieceSprite];
    
    time.position = ccp(experienceSprite.position.x-15, experienceSprite.position.y - 2);//设置中心坐标
    time.type = kCCProgressTimerTypeBar;//设置横向加载
    time.barChangeRate = ccp(1,0);
    time.percentage = 0;
    time.midpoint = ccp(0,0);
    [self addChild:time z:0];
    time.position = ccp(experienceSprite.position.x-15, 198);

    float from;
    float to;
    int jiangliXishu = player.HP/(float)gameData.maxHP * 100.0f;
    if (isWin) {
        jiangliXishu = jiangliXishu<= 50 ? 50:jiangliXishu;
    } else {
        jiangliXishu = 20;
    }
    _maxEXP = gameData.maxExp;//当前升级所需最大经验
    _getEXP = player.killNum * jiangliXishu / 100;//本关获得经验
    //XP
    CCSprite *XPSprite = [CCSprite spriteWithFile:@"stats_piece_xp.png"];
    [XPSprite setPosition:ccp(size.width/2, 165)];
    [self addChild:XPSprite];
    //XP值
    CCLabelTTF *XPLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", _getEXP]
                                             fontName:@"Marker Felt"
                                             fontSize:11];
    [self addChild:XPLabel];
    XPLabel.position = ccp(size.width/2-50, 172);
    _upEXP = (gameData.level+1) * 200 + 300;//升下级所需经验
    _currentEXP = gameData.currentExp;
    
    CCLabelAtlas *exp_label = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%i/%i", gameData.currentExp, gameData.maxExp]
                                                charMapFile:@"z_number7.png"
                                                  itemWidth:11
                                                 itemHeight:14
                                               startCharMap:'+'];
    exp_label.scale = 0.5;
    exp_label.position = ccp(size.width/2 - 10, 200);
    exp_label.anchorPoint = ccp(0.5, 0.5);
    [self addChild:exp_label z:4];
    
    //等级
    CCLabelTTF *nowGradeLabel = [CCLabelTTF labelWithString:@"等级"
                                                   fontName:@"Marker Felt"
                                                   fontSize:15];
    nowGradeLabel.color =ccc3(0, 0, 0);
    [self addChild:nowGradeLabel];
    nowGradeLabel.position = ccp(size.width/2-105, 200);
    
    CCLabelAtlas *grade = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", gameData.level]
                                            charMapFile:@"z_number2.png"
                                              itemWidth:20
                                             itemHeight:28
                                           startCharMap:'+'];
    grade.position = ccp(nowGradeLabel.position.x+16, nowGradeLabel.position.y);
    grade.scale = 0.5;
    grade.anchorPoint = ccp(0, 0.5);
    [self addChild:grade];
    if (_currentEXP + _getEXP >= _maxEXP) {
        
        from = gameData.currentExp / (float)(gameData.level * 200) * 100;
        to = (gameData.currentExp + _getEXP) / (float)(gameData.level * 200) * 100;
        CCProgressFromTo *fromTo = [CCProgressFromTo actionWithDuration:1 from:from to:to];

        CCCallBlock *block = [CCCallBlock actionWithBlock:^{
            gameData.level++;
            [[SimpleAudioEngine sharedEngine] playEffect:@"level_up.caf"];
            [grade setString:[NSString stringWithFormat:@"%d", gameData.level]];
            _getEXP = (_currentEXP + _getEXP) - _maxEXP;
            gameData.currentExp = _getEXP;
            float to = _getEXP / (float)(gameData.level * 200) * 100;
            CCProgressFromTo *fromTo2 = [CCProgressFromTo actionWithDuration:1 from:0 to:to];
            [time runAction:fromTo2];
            [exp_label setString:[NSString stringWithFormat:@"%i/%i", gameData.currentExp, gameData.maxExp]];
        }];
        
        CCSequence *seq = [CCSequence actions:fromTo, block, nil];
        [time runAction:seq];
        
    } else {
        from = gameData.currentExp / (float)(gameData.level * 200 + 300) * 100;
        gameData.currentExp += _getEXP;
        to = gameData.currentExp / (float)(gameData.level * 200 + 300) * 100;
        CCProgressFromTo *fromTo = [CCProgressFromTo actionWithDuration:1 from:from to:to];
        [time runAction:fromTo];
    }
    
    //奖励
    CCSprite *awardSprite = [CCSprite spriteWithFile:@"stats_piece_bonus.png"];
    [awardSprite setPosition:ccp(size.width/2, 60)];
    [self addChild:awardSprite];
    //奖励金币值
    int getCoin = player.getCoin * jiangliXishu / 100;
    CCLabelTTF *iconLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", getCoin]
                                               fontName:@"Marker Felt"
                                               fontSize:11];
    [self addChild:iconLabel];
    iconLabel.position = ccp(size.width/2-35, 65);
    gameData.coin += getCoin;
    //奖励石头值
    int getStone = 0;
    if (isWin) {
        if (gameData.grade % 10 == 0) {
            getStone = 3;
        } else {
            getStone = 2;
        }
    }
    CCLabelTTF *stoneLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", getStone]
                                                fontName:@"Marker Felt"
                                                fontSize:11];
    [self addChild:stoneLabel];
    stoneLabel.position = ccp(size.width/2+30, 65);
    gameData.magicStone += getStone;
    int hp = (int)(player.HP/(float)gameData.maxHP * 100);
    hp = hp <= 0 ? 0:hp;
    //生命值
    CCLabelTTF *lifeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", hp]
                                               fontName:@"Marker Felt"
                                               fontSize:11];
    [self addChild:lifeLabel];
    lifeLabel.position = ccp(size.width/2-50, 102);
    
    //杀敌值
    CCLabelTTF *killLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", player.killNum] fontName:@"Marker Felt" fontSize:11];
    [self addChild:killLabel];
    killLabel.position = ccp(size.width/2-50, 132);
    
   // z_number2.png
    
    [[GameData shareGameDataInstance] save];
    
}
#pragma mark - touchDispatcher
-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    CCScene *reScene = [ResearchLayer scene];
    [[CCDirector sharedDirector] replaceScene:reScene];
}

- (void)dealloc
{
    CCLOG(@"%@ : %@", NSStringFromSelector(_cmd), self);
    [super dealloc];
}
@end
