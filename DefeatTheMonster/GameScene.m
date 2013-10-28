//
//  GameScene.m
//  DefeatTheMonster
//
//  Created by aatc on 10/9/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"
#import "ControlLayer.h"

@implementation GameScene

+ (id)scene
{
    CCScene *scene = [CCScene node];
    GameLayer *gameLayer = [GameLayer node];
    ControlLayer *controlLayer = [ControlLayer node];
    [scene addChild:gameLayer z:1];
    [scene addChild:controlLayer z:1 tag:1];
    
    return scene;
}

- (void)dealloc
{
    CCLOG(@"%@ : %@", NSStringFromSelector(_cmd), self);
    [super dealloc];
}
@end
