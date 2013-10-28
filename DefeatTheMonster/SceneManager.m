//
//  SceneManger.m
//  DefeatTheMonster
//
//  Created by aatc on 10/9/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "SceneManager.h"
#import "MenuLayer.h"
#import "GameScene.h"

#import "StatsLayer.h"//测试_胜利场景

@interface SceneManager ()

+ (void)goWithLayer:(CCLayer *)layer;
+ (void)goWithScene:(CCScene *)scene;
+ (CCScene*)wrap:(CCLayer*)layer;

@end

@implementation SceneManager
//切换场景
+ (void)goWithLayer:(CCLayer *)layer
{
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layer];
    if ([director runningScene]) {
        [director replaceScene:newScene];
    }
    else{
        [director runWithScene:newScene];
    }
}
//切换场景
+ (void)goWithScene:(CCScene *)scene
{
    CCDirector *director = [CCDirector sharedDirector];
    if ([director runningScene]) {
        [director replaceScene:scene];
    }
    else{
        [director runWithScene:scene];
    }
}
//添加场景
+ (CCScene*)wrap:(CCLayer *)layer
{
    CCScene *newScene = [CCScene node];
    [newScene addChild:layer];
    return newScene;
}
//切换到菜单场景
+ (void)goMenu
{
    CCLayer *layer = [MenuLayer node];
    [self goWithLayer:layer];
}
//切换到开始游戏场景
+ (void)goStart
{
    CCScene *gameScene = [GameScene scene];
    [self goWithScene:gameScene];
}
//切换到研究场景
+ (void)goResearch
{
    
}
//切换到搜索场景
+ (void)goCredits
{
    
}
//切换到游戏失败场景
+ (void)goGameover
{
    
}
//切换到游戏胜利场景
+ (void)goWin
{
    
    
}

@end
