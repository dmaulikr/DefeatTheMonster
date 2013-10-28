//
//  SceneManger.h
//  DefeatTheMonster
//
//  Created by aatc on 10/9/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SceneManager : CCScene
{
    
}

+ (void)goWithScene:(CCScene *)scene;
+ (void)goMenu;
+ (void)goStart;
+ (void)goResearch;
+ (void)goCredits;
+ (void)goGameover;
+ (void)goWin;


@end
