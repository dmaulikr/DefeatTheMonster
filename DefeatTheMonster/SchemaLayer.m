//
//  SchemaLayer.m
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "SchemaLayer.h"

#import "SceneManager.h"
#import "ResearchLayer.h"
#import "GameData.h"
#import "SimpleAudioEngine.h"
@implementation SchemaLayer

+ (id)scene
{
    CCScene *scene = [CCScene node];
    SchemaLayer *layer = [SchemaLayer node];
    [scene addChild:layer];
    
    return scene;
}

- (id)init
{
    if ( self = [super init] )
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        GameData *gameData = [GameData shareGameDataInstance];
        NSAssert(gameData != nil, @"data is not init");
        //菜单背景
        CCSprite *sp = [CCSprite spriteWithFile:@"z_online_data_bg.png"];
        sp.position =ccp(size.width/2, size.height /2);
        [self addChild:sp z:0 tag:1];
        //创建角色名菜单按钮
        CCLabelTTF *stayLbl = [CCLabelTTF labelWithString:@"守卫者II" fontName:@"Marker Felt" fontSize:18];
        
        CCMenuItemLabel * heroNameItem = [CCMenuItemLabel itemWithLabel:stayLbl block:^(id sender) {
            
        }];
        CCMenu *menu1 = [CCMenu menuWithItems:heroNameItem, nil];
        menu1.position = ccp(size.width/2-105,267);
        [self addChild:menu1];
        //当前等级label
        CCLabelTTF *nowGradeLabel = [CCLabelTTF labelWithString:@"等级" fontName:@"Marker Felt" fontSize:12];
        [self addChild:nowGradeLabel];
        nowGradeLabel.position = ccp(size.width/2, 267);
        
        CCLabelAtlas *level = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@".%d", gameData.level]
                                                charMapFile:@"z_number7.png"
                                                  itemWidth:11
                                                 itemHeight:14
                                               startCharMap:'+'];
        level.position = ccp(nowGradeLabel.position.x+14, nowGradeLabel.position.y);
        level.scale = 0.7;
        level.anchorPoint = ccp(0, 0.5);
        [self addChild:level];
        
        //关卡2字label
        CCLabelTTF *passLabel = [CCLabelTTF labelWithString:@"关卡"
                                                   fontName:@"Marker Felt"
                                                   fontSize:14];
        [self addChild:passLabel];
        passLabel.position = ccp(size.width/2-112, 140);
        
        CCLabelAtlas *grade = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",gameData.level]
                                     charMapFile:@"z_number3.png"
                                       itemWidth:11
                                      itemHeight:14
                                    startCharMap:'0'];
        grade.scale = 1.2;
        grade.position = ccp(passLabel.position.x + 16, passLabel.position.y);
        grade.anchorPoint = ccp(0, 0.5);
        [self addChild:grade z:4];
        
        /////////设置经验进度条///////////
        //等级经验进度外框
        CCSprite *experienceSprite = [CCSprite spriteWithFile:@"z_ex_panel.png"];
        experienceSprite.position = ccp(size.width/2+125, 267);
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
        
        float to = gameData.currentExp / (float)(gameData.level * 200 + 300) * 100;
        CCProgressFromTo *fromTo = [CCProgressFromTo actionWithDuration:0.6 from:0 to:to];
        [time runAction:fromTo];

        CCLabelAtlas *exp_label = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%i/%i", gameData.currentExp, gameData.maxExp]
                                     charMapFile:@"z_number7.png"
                                       itemWidth:11
                                      itemHeight:14
                                    startCharMap:'+'];
        exp_label.scale = 0.5;
        exp_label.position = ccp(size.width/2+115, 270);
        exp_label.anchorPoint = ccp(0.5, 0.5);
        [self addChild:exp_label z:4];
        
        
        //菜单-开始本地游戏按钮
        CCMenuItemImage *startButton1 = [CCMenuItemImage itemWithNormalImage:@"button_start_up.png"
                                                               selectedImage:@"button_start_down.png"
                                                                       block:^(id sender) {
                                                                           [[SimpleAudioEngine sharedEngine] playEffect:@"01_button.mp3"];
                                                                           CCTransitionFadeBL *fabl = [CCTransitionMoveInR transitionWithDuration:0.2 scene:[ResearchLayer scene]];
                                                                           [[CCDirector sharedDirector] replaceScene:fabl];
                                                                       }];
        CCMenu *menu2 = [CCMenu menuWithItems:startButton1, nil];
        menu2.position = ccp(size.width/2-75, 80);
        [self addChild:menu2];
        //菜单--开始对战按钮
        CCMenuItemImage *startButton2 = [CCMenuItemImage itemWithNormalImage:@"button_start_up.png"
                                                               selectedImage:@"button_start_up.png"
                                                                       block:^(id sender) {
                                                                       }];
        startButton2.color = ccGRAY;
        CCMenu *menu3 = [CCMenu menuWithItems:startButton2,nil];
        menu3.position =ccp(size.width/2+125, 80);
        [self addChild:menu3];
        //highest score
        CCLabelTTF *highword = [CCLabelTTF labelWithString:@"击杀数\n待续" fontName:@"Marker Felt" fontSize:14];
        [self addChild:highword];
        highword.position = ccp(340, 150);
        CCLabelAtlas *highscore = [CCLabelAtlas labelWithString:@"9527"
                                                    charMapFile:@"z_number8.png"
                                                      itemWidth:33
                                                     itemHeight:45
                                                   startCharMap:'+'];
        
        [self addChild:highscore];
        highscore.scale = 0.5;
        highscore.position = ccp(highword.position.x, highword.position.y - highword.contentSize.height-10);
        highscore.anchorPoint = ccp(0.5, 0.5);
        [self achieveInit];
    }
    
    return self;
}

- (void)onEnter
{
    [super onEnter];
}

- (void)dealloc
{
    CCLOG(@"%@ : %@", NSStringFromSelector(_cmd), self);
    [super dealloc];
}
#pragma mark - 成就初始化及触发事件
//成就初始化
- (void)achieveInit
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    for (int i = 0; i < 8; i++)
    {
        //成就背景框精灵
        CCSprite *backGroundSp = [CCSprite spriteWithFile:@"achieve_bg_panel.png"];
        float x = 90 + i * (backGroundSp.contentSize.width + 11);
        float y = 225;
        [backGroundSp setPosition:ccp(x, y)];
        [self addChild:backGroundSp z:1];
    }
    
    _acSpriteCoin = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"achieve_logo_gold_0.png"]
                                            selectedSprite:nil
                                                     block:^(id sender) {
                                                         
                                                         
                                                     }];
    _acSpriteMagic = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"achieve_logo_stone_0.png"]
                                             selectedSprite:nil
                                                      block:^(id sender) {
                                                          
                                                      }];



    _acSpriteHunter = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"achieve_logo_kill_0.png"]
                                              selectedSprite:nil
                                                       block:^(id sender) {
                                                           
                                                       }];



    _acSpriteGurader = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"achieve_logo_stage_0.png"]
                                               selectedSprite:nil
                                                        block:^(id sender) {
                                                            
                                                        }];

//.png  achieve_logo_cast_0 achieve_logo_cast_0
    _acSpriteTactics = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"achieve_logo_ring_1.png"]
                                               selectedSprite:nil
                                                        block:^(id sender) {
                                                            
                                                        }];



    _acSpriteFire = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"achieve_logo_cast_0.png"]
                                            selectedSprite:nil
                                                     block:^(id sender) {
                                                         
                                                     }];



    _acSpriteIce = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"achieve_logo_cast_0.png"]
                                           selectedSprite:nil
                                                    block:^(id sender) {
                                                        
                                                    }];



    _acLightning = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"achieve_logo_cast_0.png"]
                                           selectedSprite:nil
                                                    block:^(id sender) {
                                                        
                                                    }];

    CCMenu *achieve_logo_menu = [CCMenu menuWithItems:_acSpriteCoin, _acSpriteMagic, _acSpriteHunter, _acSpriteGurader, _acSpriteTactics, _acSpriteFire, _acSpriteIce, _acLightning, nil];

    [self addChild:achieve_logo_menu z:2];
    achieve_logo_menu.position = ccp(size.width/2+3, 223);
    [achieve_logo_menu alignItemsHorizontallyWithPadding:11];
    
}

@end
