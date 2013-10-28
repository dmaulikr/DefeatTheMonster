//
//  MenuLayer.m
//  DefeatTheMonster
//
//  Created by aatc on 10/9/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "MenuLayer.h"
#import "SceneManager.h"
#import "GameData.h"

#import "SchemaLayer.h"
#import "SimpleAudioEngine.h"

#define MY_BANNER_UNIT_ID  @"a1526a4010378f1"

@implementation MenuLayer

+ (id)scene
{
    CCScene *scene = [CCScene node];
    MenuLayer *layer = [MenuLayer node];
    [scene addChild:layer];
    
    return scene;
}

- (id)init
{
    if (self = [super init]) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"cover_bgm.caf" loop:YES];
        CGSize size = [[CCDirector sharedDirector] winSize];
        //菜单背景
        CCSprite *sp = [CCSprite spriteWithFile:@"cover.png"];
        sp.position =ccp(size.width/2, size.height /2);
        [self addChild:sp z:0 tag:1];
        
        //建立开始菜单
        CCMenuItemImage *newGame = [CCMenuItemImage itemWithNormalImage:@"cover_button_start_up.png"selectedImage:@"cover_button_start_down.png"target:self selector:@selector(onStart)];
        CCMenu *menu1 = [CCMenu menuWithItems:newGame,nil];
        [self addChild:menu1];
        menu1.position =ccp(size.width-50, size.height -97);
        
        //建立成就菜单
        CCMenuItemImage *honor = [CCMenuItemImage itemWithNormalImage:@"cover_button_honor_up.png"
                                                        selectedImage:@"cover_button_honor_down.png"
                                                                block:^(id sender) {
                                                                    [GameData shareGameDataInstance].magicStone += 10;
                                                                    [GameData shareGameDataInstance].coin += 1000;
                                                                }];
        CCMenu *menu2 = [CCMenu menuWithItems:honor,nil];
        [self addChild:menu2];
        menu2.position =ccp(size.width-58, size.height -158);

        CCMenuItemImage *share = [CCMenuItemImage itemWithNormalImage:@"cover_button_share_up.png" selectedImage:@"cover_button_share_down.png" target:self selector:@selector(onShare)];
        CCMenu *menu4 = [CCMenu menuWithItems:share,nil];
        [self addChild:menu4];
        menu4.position = ccp(size.width-73, size.height -213);
        
        //音乐
        CCMenuItem *music_on = [CCMenuItemImage itemWithNormalImage:@"zzz_button_music_on.png" selectedImage:nil];
        CCMenuItem *music_off = [CCMenuItemImage itemWithNormalImage:@"zzz_button_music_off.png" selectedImage:nil];
        CCMenuItemToggle *item1 = [CCMenuItemToggle  itemWithTarget:self selector:@selector(meunItem1Touched:) items:music_on,music_off, nil];
        [CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
        [CCMenuItemFont setFontSize:20];
        int backgroundMusicVolume = [[GameData shareGameDataInstance] getBackgroundMusicVolume];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:backgroundMusicVolume];
        if (backgroundMusicVolume <= 0) {
            [item1 setSelectedIndex:1];
        } else {
            [item1 setSelectedIndex:0];
        }
        
        //60 180 90 175
        CCMenuItem *effect_on = [CCMenuItemImage itemWithNormalImage:@"button_sound_on.png" selectedImage:nil];
        CCMenuItem *effect_off = [CCMenuItemImage itemWithNormalImage:@"button_sound_off.png" selectedImage:nil];
        
        CCMenuItemToggle *item3 = [CCMenuItemToggle  itemWithTarget:self selector:@selector(meunItem3Touched:) items:effect_on,effect_off, nil];
        int effectsVolume = [[GameData shareGameDataInstance] getEffectsVolume];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:effectsVolume];
        if (effectsVolume <= 0) {
            [item3 setSelectedIndex:1];
        } else {
            [item3 setSelectedIndex:0];
        }
        
        CCMenu *menu_music = [CCMenu menuWithItems:item1,item3, nil];
        menu_music.position = CGPointZero;
        [self addChild:menu_music];
        
        item1.position = ccp(60, 180);
        item3.position = ccp(90, 175);
        if (bannerView_ == nil) {
            [self initAd];
        }
    }
    
    return self;
}

//背景音乐设置
-(void)meunItem1Touched:(id)sender
{
    CCMenuItemToggle *tempToggle = (CCMenuItemToggle *)sender;
    int index = [tempToggle selectedIndex];
    switch (index) {
        case 1:
            [[GameData shareGameDataInstance] setBackgroundMusicVolume:0];
            [[GameData shareGameDataInstance] saveBackgroundMusicVolume];
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0];
            break;
        case 0:
            [[GameData shareGameDataInstance] setBackgroundMusicVolume:1];
            [[GameData shareGameDataInstance] saveBackgroundMusicVolume];
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1];
            break;
            
        default:
            break;
    }
}

//游戏音效
-(void)meunItem3Touched:(id)sender
{
    CCMenuItemToggle *tempToggle = (CCMenuItemToggle *)sender;
    int index = [tempToggle selectedIndex];
    switch (index) {
        case 1:
            [[GameData shareGameDataInstance] setEffectsVolume:0.0f];
            [[GameData shareGameDataInstance] saveEffectsVolume];
            [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.0f];
            break;
        case 0:
            [[GameData shareGameDataInstance] setEffectsVolume:1];
            [[GameData shareGameDataInstance] saveEffectsVolume];
            [[SimpleAudioEngine sharedEngine] setEffectsVolume:1];
            break;
            
        default:
            break;
    }
}

- (void)initAd
{
    CGRect frame = [[[CCDirector sharedDirector] view] frame];
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    bannerView_.rootViewController = [CCDirector sharedDirector];
    bannerView_.center = CGPointMake(frame.size.width/2, frame.size.height-50);
   // bannerView_.delegate = self;
    GADRequest *request = [GADRequest request];
    
    [bannerView_ loadRequest:request];
    bannerView_.tag = 1;
    [[[CCDirector sharedDirector] view] addSubview:bannerView_];
}

#pragma mark - ad view

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    CGRect frame = [[[CCDirector sharedDirector] view] frame];
    [UIView beginAnimations:@"BannerSlide" context:nil];
    bannerView.frame = CGRectMake(frame.size.width / 2 - bannerView.frame.size.width / 2,
                                  frame.size.height -
                                  bannerView.frame.size.height,
                                  bannerView.frame.size.width,
                                  bannerView.frame.size.height);
    [UIView commitAnimations];
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
    bannerView_.hidden = YES;
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}

#pragma mark - 菜单事件
//进入游戏
- (void)onStart
{
    CCTransitionMoveInR *fabl = [CCTransitionMoveInR transitionWithDuration:0.2 scene:[SchemaLayer scene]];
    [[CCDirector sharedDirector] replaceScene:fabl];
}
//进入成就榜
- (void)onHonor
{
    NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=587767923"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
}
//分享成就
- (void)onShare
{
    return;
}

- (void)dealloc
{
    CCLOG(@"%@ : %@", NSStringFromSelector(_cmd), self);
    [super dealloc];
}

@end
