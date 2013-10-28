//
//  FinishLayer.m
//  DefeatTheMonster
//
//  Created by wujiajing on 13-10-19.
//  Copyright 2013年 nchu. All rights reserved.
//

#import "FinishLayer.h"

#import "StatsLayer.h"
@implementation FinishLayer

- (id)init
{
    if (self = [super init]) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"gameover_bg.png"];
        bg.opacity = 70;
        bg.position = ccp(size.width/2, size.height/2);
        [self addChild:bg z:0];
        
        CCSprite *lose = [CCSprite spriteWithFile:@"gameover_word.png"];
        CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.5 position:ccp(size.width/2, size.height/2)];
       // CCEaseBackOut *ease = [CCEaseBackOut actionWithAction:moveTo];
        CCCallBlock *afterMT = [CCCallBlock actionWithBlock:^{
            CCSprite *tips = [CCSprite spriteWithFile:@"gameover_tips.png"];
            
            CCFadeOut *fout = [CCFadeOut actionWithDuration:0.7];
            //逐渐出现动画
            CCReverseTime *rever = [CCReverseTime actionWithAction:fout];
            CCSequence *seq = [CCSequence actions:fout, rever, nil];
            //无限重复动画
            CCRepeatForever *re = [CCRepeatForever actionWithAction:seq];
            
            [self addChild:tips z:1 tag:1];
            tips.position = ccp(size.width/2, lose.position.y - lose.contentSize.height/2);
            [tips runAction:re];
        }];
        CCFadeIn *fin = [CCFadeIn actionWithDuration:0.2];
        CCSequence *seq = [CCSequence actions:fin, moveTo, afterMT,nil];
        [self addChild:lose];
        lose.position = ccp(size.width/2, size.height/3);
        [lose runAction:seq];
        
        self.touchEnabled = YES;
    }
    
    return self;
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
    CCScene *statsScene = [StatsLayer sceneWithFlag:NO];
    [[CCDirector sharedDirector] replaceScene:statsScene];
}


@end
