//
//  LoadingScene.m
//  3213
//
//  Created by aatc on 9/4/13.
//  Copyright 2013 nchu. All rights reserved.
//

#define getWinSieze() [[CCDirector sharedDirector] winSize]

#import "LoadingScene.h"
#import "SimpleAudioEngine.h"

#import "GADBannerView.h"

#define MY_BANNER_UNIT_ID  @"a1526a4010378f1"

@implementation LoadingScene

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    LoadingScene *layer = [LoadingScene node];
    [scene addChild:layer];
    return scene;
}

-(void) onEnter
{
    [super onEnter];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [frameCache addSpriteFramesWithFile:@"arrow_bow.plist"];
    [frameCache addSpriteFramesWithFile:@"magic.plist"];
    [frameCache addSpriteFramesWithFile:@"magic2.plist"];
    [frameCache addSpriteFramesWithFile:@"magic3.plist"];
    [frameCache addSpriteFramesWithFile:@"magic4.plist"];
    [frameCache addSpriteFramesWithFile:@"emolingzhu.plist"];
    [frameCache addSpriteFramesWithFile:@"emolingzhu1.plist"];
    [frameCache addSpriteFramesWithFile:@"wind.plist"];
    for (int i = 1; i <= 5; i++) {
        [frameCache addSpriteFramesWithFile:[NSString stringWithFormat:@"monster%i.plist", i]];
    }
    
    
}

+(CCScene *) sceneWithTargetScene:(CCScene *)targetScene
{
    return [[self alloc] initWithTargetScene:targetScene];
}
-(id) initWithTargetScene:(CCScene *)targetScene
{
    if ((self = [super init])) {
        self.targetScene = targetScene;
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        CGSize winSize = getWinSieze();
        
        //背景
        CCSprite *backGround = [CCSprite spriteWithFile:@"loadbg.png"];
        //backGround.anchorPoint = CGPointZero;
        backGround.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:backGround z:0];
        //图片人物
        //进度条外框
        CCSprite *loadingBar_bg = [CCSprite spriteWithFile:@"loading_probarback.png"];
        loadingBar_bg.position = ccp(winSize.width * 0.5, winSize.height / 2);
        [self addChild:loadingBar_bg z:1];
        //进度条色块
        CCSprite *loadingBar = [CCSprite spriteWithFile:@"loading_probar.png"];
        CCProgressTimer *loadingBarProgress = [CCProgressTimer progressWithSprite:loadingBar];
        loadingBarProgress.position = ccp(winSize.width * 0.5, winSize.height / 2);

        loadingBarProgress.type = kCCProgressTimerTypeBar;
        loadingBarProgress.barChangeRate = ccp(1,0);
        loadingBarProgress.percentage = 0;
        loadingBarProgress.midpoint = ccp(0,0);
        [self addChild:loadingBarProgress z:5 tag:5];
        
        //loading 字样
        CCLabelTTF *loadTTF = [CCLabelTTF labelWithString:NSLocalizedString(@"loading...", @"") fontName:@"Marker Felt" fontSize:12];
        loadTTF.position = loadingBar_bg.position;

        [self addChild:loadTTF z:6];
        
        GADBannerView *v = (GADBannerView *)[[[CCDirector sharedDirector] view] viewWithTag:1];
        if (v == nil) {
            CGRect frame = [[[CCDirector sharedDirector] view] frame];
            v = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
            v.adUnitID = MY_BANNER_UNIT_ID;
            v.rootViewController = [CCDirector sharedDirector];
            v.center = CGPointMake(frame.size.width/2, frame.size.height-50);
            GADRequest *request = [GADRequest request];
            
            [v loadRequest:request];
            v.tag = 1;
            [[[CCDirector sharedDirector] view] addSubview:v];
        }
        
        [self scheduleUpdate];
    }
    
    return self;
}

-(void) update:(ccTime)delta
{
    //发送正在进度条中
 //   [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICE_PROCESSING_UPDATE" object:nil];
    
    CCProgressTimer *timer1 = (CCProgressTimer*) [self getChildByTag:5];
    //timer1.percentage += delta * 50;
    //外部已经完成耗时操作
   
    if(_finishedSigle)
    {
        if (timer1.percentage < 100)
        {
            timer1.percentage += delta * 60;
        }
        else
        {
            [self unscheduleUpdate];
            [[CCDirector sharedDirector] replaceScene:self.targetScene];
            _finishedSigle = NO;
        }
    }
    else
    {
        if((arc4random() % 10) > 4)
        {
            timer1.percentage += delta * 60;
        }
        if (timer1.percentage == 100) {
            _finishedSigle = YES;
        }
    }
}

- (void)onExit
{
    [super onExit];
    GADBannerView *v = (GADBannerView *)[[[CCDirector sharedDirector] view] viewWithTag:1];
    [v removeFromSuperview];
}

-(void) NOTICE_finisheddoSomethingTimeConsuming:(NSNotification *) notice
{
    _finishedSigle = YES;
}
-(void)dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    GADBannerView *v = (GADBannerView *)[[[CCDirector sharedDirector] view] viewWithTag:1];
    [v removeFromSuperview];
    self.targetScene = nil;
    [super dealloc];
}

@end
