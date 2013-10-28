//
//  PauseLayer.m
//  DefeatTheMonster
//
//  Created by wujiajing on 13-10-24.
//  Copyright 2013年 nchu. All rights reserved.
//

#import "PauseLayer.h"

#import "ResearchLayer.h"
#import "GameScene.h"
#import "GameLayer.h"
#import "MenuLayer.h"
#import "SchemaLayer.h"
#import "SimpleAudioEngine.h"

@implementation PauseLayer

- (id)init
{
    if (self = [super init]) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *bg = [CCSprite spriteWithFile:@"pause_bg.png"];
        [self addChild:bg];
        bg.position = ccp(size.width/2, size.height/2);
        //返回主页
        CCMenuItemImage *home = [CCMenuItemImage itemWithNormalImage:@"button_home_up.png"
                                                       selectedImage:@"button_home_down.png"
                                                               block:^(id sender) {
                                                                   [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
                                                                   [[CCDirector sharedDirector] resume];
                                                                   [self removeFromParentAndCleanup:YES];
                                                                   CCTransitionFadeBL *fabl = [CCTransitionMoveInR transitionWithDuration:0.2 scene:[SchemaLayer scene]];
                                                                   [[CCDirector sharedDirector] replaceScene:fabl];
                                                               }];
        //重新开始
        CCMenuItemImage *retry = [CCMenuItemImage itemWithNormalImage:@"button_retry_up.png"
                                                        selectedImage:@"button_retry_down.png"
                                                                block:^(id sender) {
                                                                    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
                                                                    [[CCDirector sharedDirector] resume];
                                                                    [self removeFromParentAndCleanup:YES];
                                                                    [[CCDirector sharedDirector] replaceScene:[ResearchLayer scene]];
                                                                }];
        //继续
        CCMenuItemImage *resume = [CCMenuItemImage itemWithNormalImage:@"button_resume_up.png"
                                                         selectedImage:@"button_resume_down.png"
                                                                 block:^(id sender) {
                                                                     [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
                                                                     [[CCDirector sharedDirector] resume];
                                                                     [self removeFromParentAndCleanup:YES];
                                                                 }];
        CCMenu *menu = [CCMenu menuWithItems:home, retry, resume, nil];
        
        [self addChild:menu];
        menu.position = ccp(size.width/2, size.height/2);
        [menu alignItemsHorizontallyWithPadding:20.0f];
        
    }
    
    return self;
}

@end

