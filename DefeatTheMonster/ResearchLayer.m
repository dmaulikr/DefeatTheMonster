//
//  ResearchLayer.m
//  testCCScollView
//
//  Created by wujiajing on 13-10-16.
//  Copyright 2013年 nchu. All rights reserved.
//

#import "ResearchLayer.h"

#import "SWScrollView.h"
#import "ResearchItem.h"
#import "GameScene.h"
#import "GameData.h"
#import "MenuLayer.h"
#import "LoadingScene.h"
#import "SimpleAudioEngine.h"

#define MY_BANNER_UNIT_ID  @"a1526a4010378f1"

@interface ResearchLayer ()
{
    ItemType chooseType;
    BowType chooseBowType;
    int chooseBowLvl;
}

- (void)showBowInfo:(BowType)bowType lvl:(int)bowLvl;

@end


@implementation ResearchLayer
int n;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ResearchLayer *layer = [ResearchLayer node];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

- (void)onEnter
{
    [super onEnter];
    
}

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
}

- (id)init
{
    if (self = [super init]) {
        GameData *gameData = [GameData shareGameDataInstance];
        self.TouchEnabled=YES;
        
        size = [[CCDirector sharedDirector] winSize];
        [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
        [[CCTextureCache sharedTextureCache] removeUnusedTextures];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"research1.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"research2.plist"];
        
        CCSprite *background = [CCSprite spriteWithFile:@"research_bg.jpg"];
        [self addChild:background z:0];
        background.position = ccp(size.width/2, size.height/2);
        
        NSString *weapon2_frameName, *weapon3_frameName, *weapon4_frameName;
        if (gameData.firstSkillType == 0) {
            weapon2_frameName = @"icon_lock.png";
        } else {
            weapon2_frameName = [NSString stringWithFormat:@"icon_fire_0%d.png", gameData.firstSkillType];
        }
        
        if (gameData.secondSkillType == 0) {
            weapon3_frameName = @"icon_lock.png";
        } else {
            weapon3_frameName = [NSString stringWithFormat:@"icon_ice_0%d.png", gameData.secondSkillType];
        }
        
        if (gameData.thirdSkillType == 0) {
            weapon4_frameName = @"icon_lock.png";
        } else {
            weapon4_frameName = [NSString stringWithFormat:@"icon_light_0%d.png", gameData.thirdSkillType];
        }
        
        weapon = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"weapon.png"]
                                         selectedSprite:nil
                                                block:^(id sender){
                                                    [self weapon:0];
                                                }];
        weapon1 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:weapon2_frameName]
                                         selectedSprite:nil
                                                 block:^(id sender){
                                                     [self weapon:1];
                                                 }];
        weapon2 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:weapon3_frameName]
                                         selectedSprite:nil
                                                 block:^(id sender){
                                                     [self weapon:2];
                                                 }];
        weapon3 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:weapon4_frameName]
                                         selectedSprite:nil
                                                 block:^(id sender){
                                                     [self weapon:3];
                                                 }];
        CCMenu *menu2 = [CCMenu menuWithItems:weapon, weapon1, weapon2, weapon3,nil];
        [menu2 alignItemsHorizontallyWithPadding:1.0f];
        [self addChild:menu2];
        menu2.position =ccp(165,295);
      //  icon_light_03.png
        NSString *fire1_frameName, *fire2_frameName, *fire3_frameName;
        NSString *ice1_frameName, *ice2_frameName, *ice3_frameName;
        NSString *light1_frameName, *light2_frameName, *light3_frameName;
        fire1_frameName = @"icon_fire_01.png";
        if (gameData.fireSkillTwo_lvl > 0) {
            fire2_frameName = @"icon_fire_02.png";
        } else {
            fire2_frameName = @"icon_lock.png";
        }
        if (gameData.fireSkillThree_lvl > 0) {
            fire3_frameName = @"icon_fire_03.png";
        } else {
            fire3_frameName = @"icon_lock.png";
        }
        if (gameData.iceSkillOne_lvl > 0) {
            ice1_frameName = @"icon_ice_01.png";
        } else {
            ice1_frameName = @"icon_lock.png";
        }
        if (gameData.iceSkillTwo_lvl > 0) {
            ice2_frameName = @"icon_ice_02.png";
        } else {
            ice2_frameName = @"icon_lock.png";
        }
        if (gameData.iceSkillThree_lvl > 0) {
            ice3_frameName = @"icon_ice_03.png";
        } else {
            ice3_frameName = @"icon_lock.png";
        }
        if (gameData.lightSkillOne_lvl > 0) {
            light1_frameName = @"icon_light_01.png";
        } else {
            light1_frameName = @"icon_lock.png";
        }
        if (gameData.lightSkillTwo_lvl > 0) {
            light2_frameName = @"icon_light_02.png";
        } else {
            light2_frameName = @"icon_lock.png";
        }
        if (gameData.lightSkillThree_lvl > 0) {
            light3_frameName = @"icon_light_03.png";
        } else {
            light3_frameName = @"icon_lock.png";
        }
        //火技能子菜单
        CCMenuItemSprite * fire1 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:fire1_frameName]
                                                          selectedSprite:nil
                                                                   block:^(id sender) {
                                                                       if (gameData.fireSkillOne_lvl > 0) {
                                                                           gameData.firstSkillType = 1;
                                                                           [gameData save];
                                                                           menuFire.visible = NO;
                                                                           [weapon1 setNormalImage:[CCSprite spriteWithSpriteFrameName:@"icon_fire_01.png"]];
                                                                       }
                                                                   }];
        CCMenuItemSprite * fire2 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:fire2_frameName]
                                                          selectedSprite:nil
                                                                   block:^(id sender) {
                                                                       if (gameData.fireSkillTwo_lvl > 0) {
                                                                           gameData.firstSkillType = 2;
                                                                           [gameData save];
                                                                           menuFire.visible = NO;
                                                                           [weapon1 setNormalImage:[CCSprite spriteWithSpriteFrameName:@"icon_fire_02.png"]];
                                                                       }
                                                                   }];
        CCMenuItemSprite * fire3 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:fire3_frameName]
                                                          selectedSprite:nil
                                                                   block:^(id sender) {
                                                                       if (gameData.fireSkillThree_lvl > 0) {
                                                                           gameData.firstSkillType = 3;
                                                                           [gameData save];
                                                                           menuFire.visible = NO;
                                                                           [weapon1 setNormalImage:[CCSprite spriteWithSpriteFrameName:@"icon_fire_03.png"]];
                                                                       }
                                                                   }];
        menuFire = [CCMenu menuWithItems:fire1, fire2, fire3, nil];
        [menuFire alignItemsVerticallyWithPadding:2.0f];
        [self addChild:menuFire z:100];
        menuFire.position = ccp(38, 140);
       // menuFire.position = ccp(144,210);
        menuFire.visible = NO;
        //冰技能
        CCMenuItemImage *ice1 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:ice1_frameName]
                                                        selectedSprite:nil
                                                                 block:^(id sender) {
                                                                     if (gameData.iceSkillOne_lvl > 0) {
                                                                         gameData.secondSkillType = 1;
                                                                         [gameData save];
                                                                         menuIce.visible = NO;
                                                                         [weapon2 setNormalImage:[CCSprite spriteWithSpriteFrameName:@"icon_ice_01.png"]];
                                                                     }
                                                                     
                                                                 }];
        CCMenuItemImage *ice2 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:ice2_frameName]
                                                        selectedSprite:nil
                                                                 block:^(id sender) {
                                                                     if (gameData.iceSkillTwo_lvl > 0) {
                                                                         gameData.secondSkillType = 2;
                                                                         [gameData save];
                                                                         menuIce.visible = NO;
                                                                         [weapon2 setNormalImage:[CCSprite spriteWithSpriteFrameName:@"icon_ice_02.png"]];
                                                                     }
                                                                     
                                                                 }];
        CCMenuItemImage *ice3 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:ice3_frameName]
                                                        selectedSprite:nil
                                                                 block:^(id sender) {
                                                                     if (gameData.iceSkillThree_lvl > 0) {
                                                                         gameData.secondSkillType = 3;
                                                                         [gameData save];
                                                                         menuIce.visible = NO;
                                                                         [weapon2 setNormalImage:[CCSprite spriteWithSpriteFrameName:@"icon_ice_03.png"]];
                                                                     }
                                                                     
                                                                 }];
        menuIce = [CCMenu menuWithItems:ice1, ice2, ice3, nil];
        [menuIce alignItemsVerticallyWithPadding:2.0f];
        [self addChild:menuIce z:100];
        menuIce.position = ccp(80, 140);
        menuIce.visible = NO;
        //雷技能
        CCMenuItemImage *light1 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:light1_frameName]
                                                          selectedSprite:nil
                                                                   block:^(id sender) {
                                                                       if (gameData.lightSkillOne_lvl > 0) {
                                                                           gameData.thirdSkillType = 1;
                                                                           [gameData save];
                                                                           menuIce.visible = NO;
                                                                           [weapon2 setNormalImage:[CCSprite spriteWithSpriteFrameName:@"icon_light_01.png"]];
                                                                       }
                                                                       
                                                                   }];
        CCMenuItemImage *light2 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:light2_frameName]
                                                          selectedSprite:nil
                                                                   block:^(id sender) {
                                                                       if (gameData.lightSkillTwo_lvl > 0) {
                                                                           gameData.thirdSkillType = 2;
                                                                           [gameData save];
                                                                           menuIce.visible = NO;
                                                                           [weapon2 setNormalImage:[CCSprite spriteWithSpriteFrameName:@"icon_light_02.png"]];
                                                                       }
                                                                       
                                                                   }];
        CCMenuItemImage *light3 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:light3_frameName]
                                                          selectedSprite:nil
                                                                   block:^(id sender) {
                                                                       if (gameData.lightSkillThree_lvl > 0) {
                                                                           gameData.thirdSkillType = 3;
                                                                           [gameData save];
                                                                           menuIce.visible = NO;
                                                                           [weapon2 setNormalImage:[CCSprite spriteWithSpriteFrameName:@"icon_light_03.png"]];
                                                                       }
                                                                   }];
        menuLight = [CCMenu menuWithItems:light1, light2, light3, nil];
        [menuLight alignItemsVerticallyWithPadding:2.0f];
        [self addChild:menuLight z:100];
        menuLight.position = ccp(122, 140);
        menuLight.visible = NO;
        
        CCMenuItemSprite *defenderSV_item = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"research_button_defender_up.png"]
                                                                  selectedSprite:nil
                                                                           block:^(id sender) {
                                                                               [self showLayer:1];
                                                                               
                                                                           }];
        CCMenuItemSprite *magicSV_item = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"research_button_magic_up.png"]
                                                                 selectedSprite:nil
                                                                           block:^(id sender) {
                                                                               [self showLayer:2];
                                                                           }];
        CCMenuItemSprite *wallSV_item = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"research_button_wall_up.png"]
                                                                  selectedSprite:nil
                                                                           block:^(id sender) {
                                                                               [self showLayer:3];
                                                                           }];
        CCMenuItemSprite *bowSV_item = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"research_button_bow_up.png"]
                                                                  selectedSprite:nil
                                                                           block:^(id sender) {
                                                                               [self showLayer:4];
                                                                           }];
        CCMenu *SV_menu = [CCMenu menuWithItems:defenderSV_item, magicSV_item, wallSV_item, bowSV_item, nil];
        [self addChild:SV_menu];
        SV_menu.position = ccp(41, 150);
        [SV_menu alignItemsVerticallyWithPadding:-10.f];
        
        defender_down = [CCSprite spriteWithFile:@"research_button_defender_down.png"];
        [defenderSV_item addChild:defender_down];
        defender_down.position = ccp(defenderSV_item.contentSize.width/2, defenderSV_item.contentSize.height/2);
        defender_down.visible = YES;
        
        magic_down = [CCSprite spriteWithFile:@"research_button_magic_down.png"];
        [magicSV_item addChild:magic_down];
        magic_down.position = ccp(magicSV_item.contentSize.width/2, magicSV_item.contentSize.height/2);
        magic_down.visible = NO;
        
        wall_down = [CCSprite spriteWithFile:@"research_button_wall_down.png"];
        [wallSV_item addChild:wall_down];
        wall_down.position = ccp(wallSV_item.contentSize.width/2, wallSV_item.contentSize.height/2);
        wall_down.visible = NO;
        
        bow_down = [CCSprite spriteWithFile:@"research_button_bow_down.png"];
        [bowSV_item addChild:bow_down];
        bow_down.position = ccp(bowSV_item.contentSize.width/2, bowSV_item.contentSize.height/2);
        bow_down.visible = NO;

        CCMenuItemSprite *continue_headItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"research_button_continue_up.png"]
                                                                     selectedSprite:[CCSprite spriteWithFile:@"research_button_continue_down.png"]
                                                                              block:^(id sender) {
                                                                                  [[SimpleAudioEngine sharedEngine] playEffect:@"01_button.mp3"];
                                                                                  CCScene *scene = [LoadingScene sceneWithTargetScene:[GameScene scene]];
                                                                                  [[CCDirector sharedDirector] replaceScene:scene];
                                                                              }];
        
        continue_headItem.position = ccp(size.width - 30, size.height - continue_headItem.contentSize.height/2 - 10);
        CCMenu *headMenu = [CCMenu menuWithItems:continue_headItem, nil];
        [self addChild:headMenu];
        headMenu.position = CGPointZero;
        coinLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%i", gameData.coin]
                                        charMapFile:@"z_number3.png"
                                          itemWidth:11
                                         itemHeight:14
                                       startCharMap:'0'];
        coinLabel.position = ccp(275, 303);
        coinLabel.scaleX = 0.8;
        coinLabel.anchorPoint = ccp(0, 0.5);
        
        magicStroneLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%i", gameData.magicStone]
                                      charMapFile:@"z_number3.png"
                                        itemWidth:11
                                       itemHeight:14
                                     startCharMap:'0'];
        magicStroneLabel.position = ccp(275, 285);
        magicStroneLabel.scaleX = 0.8;
        magicStroneLabel.anchorPoint = ccp(0, 0.5);
        
        [self addChild:coinLabel];
        [self addChild:magicStroneLabel];
        
        info_name = [CCLabelTTF labelWithString:@"力量"  fontName:@"AppleGothic"  fontSize:15];
        [self addChild:info_name];
        info_name.position = ccp(75,53);
        info_name.color= ccc3(253, 6, 29);
        info_name.anchorPoint = CGPointMake(0, 0.5f);//align left

        
        info_describe = [CCLabelTTF labelWithString:@"增加您箭的基础伤害" fontName:@"AppleGothic" fontSize:10];
        [self addChild:info_describe];
        info_describe.position = ccp(info_name.position.x,info_name.position.y - 14);
        info_describe.color =ccc3(230, 229, 229);
        info_describe.anchorPoint = CGPointMake(0, 0.5f);
        
        info_grade = [CCLabelTTF labelWithString:@"当前:             下级:" fontName:@"AppleGothic" fontSize:9];
        [self addChild:info_grade];
        info_grade.position = ccp(info_name.position.x,info_name.position.y - 29);
        info_grade.color =ccc3(218, 209, 68);
        info_grade.anchorPoint = CGPointMake(0, 0.5f);
        
        current = [CCLabelAtlas labelWithString:@""
                                     charMapFile:@"z_number3.png"
                                       itemWidth:11
                                      itemHeight:14
                                    startCharMap:'0'];
        current.position = ccp(info_name.position.x+28, info_name.position.y - 28);
        current.scaleX = 0.8;
        current.anchorPoint = ccp(0, 0.5);
        
        next = [CCLabelAtlas labelWithString:@""
                                             charMapFile:@"z_number3.png"
                                               itemWidth:11
                                              itemHeight:14
                                            startCharMap:'0'];
        next.position = ccp(info_name.position.x+95, info_name.position.y - 28);
        next.scaleX = 0.8;
        next.anchorPoint = ccp(0, 0.5);
        
        [self addChild:current];
        [self addChild:next];

        buy = [CCMenuItemImage itemWithNormalImage:@"research_button_buy_up.png"
                                     selectedImage:@"research_button_buy_down.png"
                                             target:self selector:@selector(buy)];
        zhuangbei = [CCMenuItemImage itemWithNormalImage:@"research_button_equip_up.png"
                                     selectedImage:@"research_button_equip_down.png"
                                            target:self selector:@selector(equip)];
        zhuangbei.visible = NO;
        CCMenu *menu_buy = [CCMenu menuWithItems:buy, zhuangbei, nil];
        [self addChild:menu_buy];
        menu_buy.position =ccp(416, 25);
        
        [[CCTextureCache sharedTextureCache] addImage:@"mana_stone.png"];
        [[CCTextureCache sharedTextureCache] addImage:@"coin.png"];
        
        coin = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"coin.png"]];
        [self addChild:coin];
        coin.position = ccp(menu_buy.position.x - 25, menu_buy.position.y+22);
 
        price = [CCLabelAtlas labelWithString:@""
                                  charMapFile:@"z_number3.png"
                                    itemWidth:11
                                   itemHeight:14
                                 startCharMap:'0'];
        price.position = ccp(info_name.position.x+95, info_name.position.y - 25);
        price.scaleX = 0.8;
        [self addChild:price];
        price.position = ccp(coin.position.x + 10, coin.position.y-6);
        
        priceInfo = [CCLabelTTF labelWithString:@"123" fontName:@"AppleGothic" fontSize:10];
        [self addChild:priceInfo];
        priceInfo.position = ccp(416, 35);
        priceInfo.color= ccc3(253, 6, 29);
        
        [self initPropertySV];
        chooseBowType = gameData.currentBowType;
        chooseBowLvl = gameData.currentBowLvl;
        [self equip];
        
        CCMenuItemImage *home_item = [CCMenuItemImage itemWithNormalImage:@"button_battle_home.png"
                                                            selectedImage:nil
                                                                    block:^(id sender) {
                                                                        [[CCDirector sharedDirector] replaceScene:[MenuLayer scene]];
                                                                    }];
        CCMenu *home_menu = [CCMenu menuWithItems:home_item, nil];
        [self addChild:home_menu];
        home_menu.position = ccp(30, 295);
        
        GADBannerView *v = (GADBannerView *)[[[CCDirector sharedDirector] view] viewWithTag:1];
        if (v == nil && ! gameData.hadClickedAd) {
            CGRect frame = [[[CCDirector sharedDirector] view] frame];
            v = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
            v.adUnitID = MY_BANNER_UNIT_ID;
            v.rootViewController = [CCDirector sharedDirector];
            v.center = CGPointMake(frame.size.width/2, frame.size.height-50);
            GADRequest *request = [GADRequest request];
            [v loadRequest:request];
            v.tag = 1;
            [[[CCDirector sharedDirector] view] addSubview:v];
            
        } else if (v != nil && gameData.hadClickedAd) {
            [v removeFromSuperview];
            v.delegate = nil;
        }
        v.delegate = self;
    }
    
    return self;
}

- (BOOL)buy
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"button_upgrade.caf"];
    GameData *gameData = [GameData shareGameDataInstance];
    int cost = [price.string intValue];
    
    if (chooseType == kItemTypeNone) {
        switch (chooseBowType) {
            case kBowTypeAgi:
                if (gameData.coin < cost) {
                    return NO;
                }
                gameData.strength++;
                gameData.coin -= cost;
                break;
            case kBowTypeMul:
                if (gameData.magicStone < cost) {
                    return NO;
                }
                gameData.magicStone -= cost;
                gameData.manaSkill_lvl++;
                break;
            case kBowTypeFinal:
                if (gameData.magicStone < cost) {
                    return NO;
                }
                gameData.magicStone -= cost;
                gameData.manaSkill_lvl++;
                break;
            default:
                break;
        }
        [magicStroneLabel setString:[NSString stringWithFormat:@"%i", gameData.magicStone]];
        [coinLabel setString:[NSString stringWithFormat:@"%i", gameData.coin]];
        [self showInfoWithType:chooseType];
        [gameData save];
        return YES;
    }
    
    switch (chooseType) {
        case kItemTypeStrength:
            if (gameData.coin < cost) {
                return NO;
            }
            gameData.strength++;
            gameData.coin -= cost;
            break;
        case kItemTypeAgility:
            if (gameData.coin < cost) {
                return NO;
            }
            gameData.agility++;
            gameData.coin -= cost;
            break;
        case kItemTypePower:
            if (gameData.coin < cost) {
                return NO;
            }
            gameData.powerAtk++;
            gameData.coin -= cost;
            break;
        case kItemTypePoison:
            if (gameData.coin < cost) {
                return NO;
            }
            gameData.poisonArrow++;
            gameData.coin -= cost;
            break;
        case kItemTypeBlow:
            if (gameData.coin < cost) {
                return NO;
            }
            gameData.deadlyAtk++;
            gameData.coin -= cost;
            break;
        case kItemTypeMultiple:
            if (gameData.coin < cost) {
                return NO;
            }
            gameData.multipleArrow++;
            gameData.coin -= cost;
            break;
        case kItemTypeDefender:
            if (gameData.coin < cost) {
                return NO;
            }
            gameData.defender++;
            gameData.coin -= cost;
            break;
            //魔法
        case kItemTypeManaResearch:
            if (gameData.magicStone < cost) {
                return NO;
            }
            gameData.magicStone -= cost;
            gameData.manaSkill_lvl++;
            break;
        case kItemTypeLightOne:
            if (gameData.magicStone < cost) {
                return NO;
            }
            gameData.magicStone -= cost;
            gameData.lightSkillOne_lvl++;
            break;
        case kItemTypeLightTow:
            if (gameData.magicStone < cost) {
                return NO;
            }
            gameData.magicStone -= cost;
            gameData.lightSkillTwo_lvl++;
            break;
        case kItemTypeLightThree:
            if (gameData.magicStone < cost) {
                return NO;
            }
            gameData.magicStone -= cost;
            gameData.lightSkillThree_lvl++;
            break;
        case kItemTypeFireOne:
            if (gameData.magicStone < cost) {
                return NO;
            }
            gameData.magicStone -= cost;
            gameData.fireSkillOne_lvl++;
            break;
        case kItemTypeFireTow:
            if (gameData.magicStone < cost) {
                return NO;
            }
            gameData.magicStone -= cost;
            gameData.fireSkillTwo_lvl++;
            break;
        case kItemTypeFireThree:
            if (gameData.magicStone < cost) {
                return NO;
            }
            gameData.magicStone -= cost;
            gameData.fireSkillThree_lvl++;
            break;
        case kItemTypeIceOne:
            if (gameData.magicStone < cost) {
                return NO;
            }
            gameData.magicStone -= cost;
            gameData.iceSkillOne_lvl++;
            break;
        case kItemTypeIceTow:
            if (gameData.magicStone < cost) {
                return NO;
            }
            gameData.magicStone -= cost;
            gameData.iceSkillTwo_lvl++;
            break;
        case kItemTypeIceThree:
            if (gameData.magicStone < cost) {
                return NO;
            }
            gameData.magicStone -= cost;
            gameData.iceSkillThree_lvl++;
            break;
        case kItemTypeWall:
            if (gameData.coin < cost) {
                return NO;
            }
            gameData.coin -= cost;
            gameData.wall++;
            break;
        case kItemTypeToewr:
            if (gameData.magicStone < cost) {
                return NO;
            }
            gameData.magicStone -= cost;
            gameData.toewr++;
            break;
        case kItemTypeMoat:
            if (gameData.magicStone < cost) {
                return NO;
            }
            gameData.magicStone -= cost;
            gameData.moat++;
            break;
        case kItemTypeMagicPower:
            if (gameData.coin < cost) {
                return NO;
            }
            gameData.coin -= cost;
            gameData.magicPower++;
            break;
        case kItemTypeSpurting:
            if (gameData.magicStone < cost) {
                return NO;
            }
            gameData.magicStone -= cost;
            gameData.spurting++;
            break;
        case kItemTypeBurn:
            if (gameData.coin < cost) {
                return NO;
            }
            gameData.coin -= cost;
            gameData.burn++;
            break;
        case kItemTypeEatangling:
            if (gameData.magicStone < cost) {
                return NO;
            }
            gameData.magicStone -= cost;
            gameData.eatangling++;
            break;
        default:
            break;
    }
    [magicStroneLabel setString:[NSString stringWithFormat:@"%i", gameData.magicStone]];
    [coinLabel setString:[NSString stringWithFormat:@"%i", gameData.coin]];
    [self showInfoWithType:chooseType];
    [gameData save];
    return YES;
}

- (void)hideSkillMenu
{
    menuFire.visible = NO;
    menuIce.visible = NO;
    menuLight.visible = NO;
}

-(void)weapon:(int)magicMeun
{
    [self hideSkillMenu];
    switch (magicMeun) {
        case 0:
            [self showLayer:4];
            break;
        case 1:
            menuFire.visible = YES;
            break;
        case 2:
            menuIce.visible = YES;
            break;
        case 3:
            menuLight.visible = YES;
            break;
        default:
            break;
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    menuFire.visible = NO;
    menuIce.visible = NO;
    menuLight.visible = NO;
}

- (void)initPropertySV
{
    defenderSV = [SWScrollView viewWithViewSize:CGSizeMake(412, 200)];
    defenderSV.contentSize = CGSizeMake(600, 150);
    defenderSV.direction = SWScrollViewDirectionBoth;
    defenderSV.contentOffset = ccp(0, 50);
    defenderSV.position = ccp(size.width/2-135, size.height/2-90);
    defenderSV.bounces = NO;
    [self addChild:defenderSV z:1];
   // defenderSV.anchorPoint = ccp(0.5, 0.8);
    
    CCSprite *select = [CCSprite spriteWithFile:@"logo_select.png"];
    CCSprite *line = [CCSprite spriteWithFile:@"research_defender_line.png"];
    [defenderSV addChild:line z:1];
    line.position = ccp(65, 0);
    
    //力量 速度 强力击 毒箭 致命一击 多重箭 守卫者
    CCSprite *strength = [CCSprite spriteWithFile:@"logo_strength.png"];
    CCSprite *agility = [CCSprite spriteWithFile:@"logo_agility.png"];
    CCSprite *power = [CCSprite spriteWithFile:@"logo_power_shot.png"];
    CCSprite *poison = [CCSprite spriteWithFile:@"logo_poisoned_arrow.png"];
    CCSprite *defender = [CCSprite spriteWithFile:@"logo_defender.png"];
    CCSprite *multiple = [CCSprite spriteWithFile:@"logo_multiple_arrows.png"];
    CCSprite *blow = [CCSprite spriteWithFile:@"logo_fatal_blow.png"];
    
    ResearchItem *strength_item = [ResearchItem itemWithType:kItemTypeStrength
                                                normalSprite:strength
                                                    selectedSprite:nil
                                                            block:^(id sender) {
                                                                CCNode *node = (CCNode *)sender;
                                                                select.position = ccp(node.position.x+defenderSV.position.x+node.contentSize.width/2+30, node.position.y-defenderSV.position.y-defenderSV.contentOffset.y/2);
                                                                [self showInfoWithType:kItemTypeStrength];
                                                            }];
    strength_item.isLocked = NO;
    //
    ResearchItem *agility_item = [ResearchItem itemWithType:kItemTypeAgility
                                               normalSprite:agility
                                             selectedSprite:nil
                                                      block:^(id sender) {
                                                          CCNode *node = (CCNode *)sender;
                                                          select.position = ccp(node.position.x+defenderSV.position.x+node.contentSize.width/2+30, node.position.y-defenderSV.position.y-defenderSV.contentOffset.y/2);
                                                              [self showInfoWithType:kItemTypeAgility];
                                                      }];
    agility_item.isLocked = NO;
    ResearchItem *power_item = [ResearchItem itemWithType:kItemTypePower
                                             normalSprite:power
                                           selectedSprite:nil
                                                    block:^(id sender) {
                                                        CCNode *node = (CCNode *)sender;
                                                        select.position = ccp(node.position.x+defenderSV.position.x+node.contentSize.width/2+30, node.position.y-defenderSV.position.y-defenderSV.contentOffset.y/2);
                                                        [self showInfoWithType:kItemTypePower];
                                                        NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                        ResearchItem *research = (ResearchItem *)node;
                                                        if (research.isLocked) {
                                                            [self showLockedItem:kItemTypePower];
                                                        }
                                                    }];
    ResearchItem *poison_item = [ResearchItem itemWithType:kItemTypePoison
                                              normalSprite:poison
                                            selectedSprite:nil
                                                     block:^(id sender) {
                                                         CCNode *node = (CCNode *)sender;
                                                         select.position = ccp(node.position.x+defenderSV.position.x+node.contentSize.width/2+30, node.position.y-defenderSV.position.y-defenderSV.contentOffset.y/2);
                                                        [self showInfoWithType:kItemTypePoison];
                                                         NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                         ResearchItem *research = (ResearchItem *)node;
                                                         if (research.isLocked) {
                                                             [self showLockedItem:kItemTypePoison];
                                                         }
                                                     }];
    ResearchItem *blow_item = [ResearchItem itemWithType:kItemTypeBlow
                                              normalSprite:blow
                                            selectedSprite:nil
                                                     block:^(id sender) {
                                                         CCNode *node = (CCNode *)sender;
                                                         select.position = ccp(node.position.x+defenderSV.position.x+node.contentSize.width/2+30, node.position.y-defenderSV.position.y-defenderSV.contentOffset.y/2);
                                                         
                                                        [self showInfoWithType:kItemTypeBlow];
                                                         NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                         ResearchItem *research = (ResearchItem *)node;
                                                         if (research.isLocked) {
                                                             [self showLockedItem:kItemTypeBlow];
                                                         }
                                                     }];
    ResearchItem *multiple_item = [ResearchItem itemWithType:kItemTypeMultiple
                                                normalSprite:multiple
                                              selectedSprite:nil
                                                       block:^(id sender) {
                                                           CCNode *node = (CCNode *)sender;
                                                           select.position = ccp(node.position.x+defenderSV.position.x+node.contentSize.width/2+30, node.position.y-defenderSV.position.y-defenderSV.contentOffset.y/2);

                                                        [self showInfoWithType:kItemTypeMultiple];
                                                        NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                        ResearchItem *research = (ResearchItem *)node;
                                                        if (research.isLocked) {
                                                            [self showLockedItem:kItemTypeMultiple];
                                                        }
                                                    }];
    ResearchItem *defender_item = [ResearchItem itemWithType:kItemTypeDefender
                                                normalSprite:defender
                                              selectedSprite:nil
                                                       block:^(id sender) {
                                                           CCNode *node = (CCNode *)sender;
                                                           select.position = ccp(node.position.x+defenderSV.position.x+node.contentSize.width/2+30, node.position.y-defenderSV.position.y-defenderSV.contentOffset.y/2);
                                                           [self showInfoWithType:kItemTypeDefender];
                                                           NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                           ResearchItem *research = (ResearchItem *)node;
                                                           if (research.isLocked) {
                                                               [self showLockedItem:kItemTypeDefender];
                                                           }
                                                           
                                                       }];
    CCMenu *menu = [CCMenu menuWithItems:strength_item, agility_item, power_item, poison_item, blow_item, multiple_item, defender_item, nil];
    [defenderSV addChild:menu z:2];
    
    menu.position = ccp(240,-79);
    
    strength_item.position = ccp(-230, 155);
    agility_item.position = ccp(strength_item.position.x, strength_item.position.y - 55);
    
    power_item.position = ccp(strength_item.position.x + strength_item.contentSize.width + 32, strength_item.position.y + 20);
    poison_item.position = ccp(power_item.position.x, power_item.position.y - 45);
    blow_item.position = ccp(poison_item.position.x, poison_item.position.y - 45);
    
    multiple_item.position = ccp(poison_item.position.x + poison_item.contentSize.width + 32, poison_item.position.y);
    
    defender_item.position = ccp(multiple_item.position.x + multiple_item.contentSize.width + 32, multiple_item.position.y);
    
    [defenderSV addChild:select z:5];
    select.visible = YES;
    select.position = ccp(strength_item.position.x+defenderSV.position.x+strength_item.contentSize.width/2+30, strength_item.position.y-defenderSV.position.y-defenderSV.contentOffset.y/2);
  
    chooseType = kItemTypeStrength;
    [self showInfoWithType:chooseType];
    
    defenderSV.visible = YES;
}
- (void)initmagicSV
{
    magicSV = [SWScrollView viewWithViewSize:CGSizeMake(412, 200)];
    magicSV.contentSize = CGSizeMake(600, 150);
    magicSV.direction = SWScrollViewDirectionBoth;
    magicSV.contentOffset = ccp(0, 50);
    magicSV.position = ccp(size.width/2-135, size.height/2-90);
    magicSV.bounces = NO;
    [self addChild:magicSV z:1];
    // defenderSV.anchorPoint = ccp(0.5, 0.8);
    
    CCSprite *select = [CCSprite spriteWithFile:@"logo_select.png"];
    CCSprite *line = [CCSprite spriteWithFile:@"research_magic_line.png"];
    [magicSV addChild:line z:1];
    line.position = ccp(66, -26);
    
    //魔法研究  雷霆  冰川   流星  闪电风暴  霜之新星  流星2  诸神黄昏  冰河时代 末日审判
    CCSprite *research = [CCSprite spriteWithFile:@"logo_mana_research.png"];
    CCSprite *light_1 = [CCSprite spriteWithFile:@"logo_light_1.png"];
    CCSprite *ice_1 = [CCSprite spriteWithFile:@"logo_ice_1.png"];
    CCSprite *fire_1 = [CCSprite spriteWithFile:@"logo_fire_1.png"];
    CCSprite *light_2 = [CCSprite spriteWithFile:@"logo_light_2.png"];
    CCSprite *ice_2 = [CCSprite spriteWithFile:@"logo_ice_2.png"];
    CCSprite *fire_2 = [CCSprite spriteWithFile:@"logo_fire_2.png"];
    CCSprite *light_3 = [CCSprite spriteWithFile:@"logo_light_3.png"];
    CCSprite *ice_3 = [CCSprite spriteWithFile:@"logo_ice_3.png"];
    CCSprite *fire_3 = [CCSprite spriteWithFile:@"logo_fire_3.png"];
    ResearchItem *research_item = [ResearchItem itemWithType:kItemTypeManaResearch
                                                normalSprite:research
                                              selectedSprite:nil
                                                       block:^(id sender) {
                                                           CCNode *node = (CCNode *)sender;
                                                           select.position = ccp(node.position.x+magicSV.position.x+node.contentSize.width/2+30, node.position.y-magicSV.position.y-magicSV.contentOffset.y/2);
                                                           [self showInfoWithType:kItemTypeManaResearch];
 
                                                       }];
    
    ResearchItem *light_1_item = [ResearchItem itemWithType:kItemTypeLightOne
                                               normalSprite:light_1
                                             selectedSprite:nil
                                                      block:^(id sender) {
                                                          CCNode *node = (CCNode *)sender;
                                                          select.position = ccp(node.position.x+magicSV.position.x+node.contentSize.width/2+30, node.position.y-magicSV.position.y-magicSV.contentOffset.y/2);
                                                          [self showInfoWithType:kItemTypeLightOne];
                                                          NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                          ResearchItem *research = (ResearchItem *)node;
                                                          if (research.isLocked) {
                                                              [self showLockedItem:kItemTypeLightOne];
                                                          }
                                                          
                                                      }];
    ResearchItem *ice_1_item = [ResearchItem itemWithType:kItemTypeIceOne
                                             normalSprite:ice_1
                                           selectedSprite:nil
                                                    block:^(id sender) {
                                                        CCNode *node = (CCNode *)sender;
                                                        select.position = ccp(node.position.x+magicSV.position.x+node.contentSize.width/2+30, node.position.y-magicSV.position.y-magicSV.contentOffset.y/2);
                                                        [self showInfoWithType:kItemTypeIceOne];
                                                        NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                        ResearchItem *research = (ResearchItem *)node;
                                                        if (research.isLocked) {
                                                            [self showLockedItem:kItemTypeIceOne];
                                                        }
                                                    }];
    ResearchItem *fire_1_item = [ResearchItem itemWithType:kItemTypeFireOne
                                              normalSprite:fire_1
                                            selectedSprite:nil
                                                     block:^(id sender) {
                                                         CCNode *node = (CCNode *)sender;
                                                         select.position = ccp(node.position.x+magicSV.position.x+node.contentSize.width/2+30, node.position.y-magicSV.position.y-magicSV.contentOffset.y/2);
                                                         [self showInfoWithType:kItemTypeFireOne];
                                                         NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                         ResearchItem *research = (ResearchItem *)node;
                                                         if (research.isLocked) {
                                                             [self showLockedItem:kItemTypeFireOne];
                                                         }
                                                     }];
    ResearchItem *light_2_item = [ResearchItem itemWithType:kItemTypeLightTow
                                            normalSprite:light_2
                                          selectedSprite:nil
                                                   block:^(id sender) {
                                                       CCNode *node = (CCNode *)sender;
                                                       select.position = ccp(node.position.x+magicSV.position.x+node.contentSize.width/2+30, node.position.y-magicSV.position.y-magicSV.contentOffset.y/2);
                                                       [self showInfoWithType:kItemTypeLightTow];
                                                       NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                       ResearchItem *research = (ResearchItem *)node;
                                                       if (research.isLocked) {
                                                           [self showLockedItem:kItemTypeLightTow];
                                                       }
                                                   }];
    ResearchItem *ice_2_item = [ResearchItem itemWithType:kItemTypeIceTow
                                                normalSprite:ice_2
                                              selectedSprite:nil
                                                       block:^(id sender) {
                                                           CCNode *node = (CCNode *)sender;
                                                           select.position = ccp(node.position.x+magicSV.position.x+node.contentSize.width/2+30, node.position.y-magicSV.position.y-magicSV.contentOffset.y/2);
                                                           [self showInfoWithType:kItemTypeIceTow];
                                                           NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                           ResearchItem *research = (ResearchItem *)node;
                                                           if (research.isLocked) {
                                                               [self showLockedItem:kItemTypeIceTow];
                                                           }
                                                       }];
    ResearchItem *fire_2_item = [ResearchItem itemWithType:kItemTypeFireTow
                                                normalSprite:fire_2
                                              selectedSprite:nil
                                                       block:^(id sender) {
                                                           CCNode *node = (CCNode *)sender;
                                                           select.position = ccp(node.position.x+magicSV.position.x+node.contentSize.width/2+30, node.position.y-magicSV.position.y-magicSV.contentOffset.y/2);
                                                           [self showInfoWithType:kItemTypeFireTow];
                                                           NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                           ResearchItem *research = (ResearchItem *)node;
                                                           if (research.isLocked) {
                                                               [self showLockedItem:kItemTypeFireTow];
                                                           }
                                                       }];
    ResearchItem *light_3_item = [ResearchItem itemWithType:kItemTypeLightThree
                                               normalSprite:light_3
                                             selectedSprite:nil
                                                      block:^(id sender) {
                                                          CCNode *node = (CCNode *)sender;
                                                          select.position = ccp(node.position.x+magicSV.position.x+node.contentSize.width/2+30, node.position.y-magicSV.position.y-magicSV.contentOffset.y/2);
                                                          [self showInfoWithType:kItemTypeLightThree];
                                                          NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                          ResearchItem *research = (ResearchItem *)node;
                                                          if (research.isLocked) {
                                                              [self showLockedItem:kItemTypeLightThree];
                                                          }
                                                      }];
    ResearchItem *ice_3_item = [ResearchItem itemWithType:kItemTypeFireThree
                                             normalSprite:ice_3
                                           selectedSprite:nil
                                                    block:^(id sender) {
                                                        CCNode *node = (CCNode *)sender;
                                                        select.position = ccp(node.position.x+magicSV.position.x+node.contentSize.width/2+30, node.position.y-magicSV.position.y-magicSV.contentOffset.y/2);
                                                        [self showInfoWithType:kItemTypeIceThree];
                                                        NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                        ResearchItem *research = (ResearchItem *)node;
                                                        if (research.isLocked) {
                                                            [self showLockedItem:kItemTypeIceThree];
                                                        }
                                                    }];
    ResearchItem *fire_3_item = [ResearchItem itemWithType:kItemTypeFireThree
                                              normalSprite:fire_3
                                            selectedSprite:nil
                                                     block:^(id sender) {
                                                         CCNode *node = (CCNode *)sender;
                                                         select.position = ccp(node.position.x+magicSV.position.x+node.contentSize.width/2+30, node.position.y-magicSV.position.y-magicSV.contentOffset.y/2);
                                                         [self showInfoWithType:kItemTypeFireThree];
                                                         NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                         ResearchItem *research = (ResearchItem *)node;
                                                         if (research.isLocked) {
                                                             [self showLockedItem:kItemTypeFireThree];
                                                         }
                                                     }];

    
    CCMenu *menu = [CCMenu menuWithItems:research_item, light_1_item, ice_1_item, fire_1_item, light_2_item, ice_2_item, fire_2_item, light_3_item, ice_3_item, fire_3_item,nil];
    [magicSV addChild:menu z:2];
    
    menu.position = ccp(240,-79);
    
    research_item.position = ccp(-230, 130);
    light_1_item.position = ccp(research_item.position.x+140, research_item.position.y + 45);
    
    ice_1_item.position = ccp(research_item.position.x + 140, research_item.position.y );
    fire_1_item.position = ccp(research_item.position.x+ 140, research_item.position.y - 45);
    light_2_item.position = ccp(research_item.position.x+275, research_item.position.y + 45);
    
    ice_2_item.position = ccp(research_item.position.x + 275, research_item.position.y);
    
    fire_2_item.position = ccp(research_item.position.x + 275, research_item.position.y-45);
    
    light_3_item.position = ccp(research_item.position.x+410, research_item.position.y + 45);
    
    ice_3_item.position = ccp(research_item.position.x + 410, research_item.position.y);
    
    fire_3_item.position = ccp(research_item.position.x + 410, research_item.position.y-45);
    
    [magicSV addChild:select z:5];
    select.visible = YES;
    select.position = ccp(research_item.position.x+magicSV.position.x+research_item.contentSize.width/2+30, research_item.position.y-magicSV.position.y-magicSV.contentOffset.y/2);

    chooseType = kItemTypeManaResearch;
    [self showInfoWithType:chooseType];
    magicSV.visible = YES;
}
- (void)initwallcSV
{
    wallSV = [SWScrollView viewWithViewSize:CGSizeMake(412, 200)];
    wallSV.contentSize = CGSizeMake(600, 150);
    wallSV.direction = SWScrollViewDirectionBoth;
    wallSV.contentOffset = ccp(0, 50);
    wallSV.position = ccp(size.width/2-135, size.height/2-90);
    wallSV.bounces = NO;
    [self addChild:wallSV z:1];
    // defenderSV.anchorPoint = ccp(0.5, 0.8);
    
    CCSprite *select = [CCSprite spriteWithFile:@"logo_select.png"];
    CCSprite *line = [CCSprite spriteWithFile:@"research_wall_line.png"];
    [wallSV addChild:line z:1];
    line.position = ccp(65, -25);
    
    //城墙  魔法塔  融岩护城   魔法能量  溅射伤害  岩浆灼烧  扰乱岩流
    CCSprite *research21_03 = [CCSprite spriteWithFile:@"research21_03.png"];
    CCSprite *tower = [CCSprite spriteWithFile:@"logo_magic_tower.png"];
    CCSprite *moat = [CCSprite spriteWithFile:@"logo_lava_moat.png"];
    CCSprite *power = [CCSprite spriteWithFile:@"logo_magic_power.png"];
    CCSprite *research2_13 = [CCSprite spriteWithFile:@"research2_13.png"];
    
    CCSprite *burn = [CCSprite spriteWithFile:@"logo_burn.png"];
    CCSprite *lava = [CCSprite spriteWithFile:@"logo_entangling_lava.png"];

    ResearchItem *research21_03_item = [ResearchItem itemWithType:kItemTypeWall
                                                normalSprite:research21_03
                                              selectedSprite:nil
                                                       block:^(id sender) {
                                                           CCNode *node = (CCNode *)sender;
                                                           select.position = ccp(node.position.x+wallSV.position.x+node.contentSize.width/2+30, node.position.y-wallSV.position.y-wallSV.contentOffset.y/2);
                                                           [self showInfoWithType:kItemTypeWall];
                                                           NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                           ResearchItem *research = (ResearchItem *)node;
                                                           if (research.isLocked) {
                                                               [self showLockedItem:kItemTypeWall];
                                                           }
                                                       }];
    
    ResearchItem *tower_item = [ResearchItem itemWithType:kItemTypeToewr
                                               normalSprite:tower
                                             selectedSprite:nil
                                                      block:^(id sender) {
                                                          CCNode *node = (CCNode *)sender;
                                                          select.position = ccp(node.position.x+wallSV.position.x+node.contentSize.width/2+30, node.position.y-wallSV.position.y-wallSV.contentOffset.y/2);
                                                          [self showInfoWithType:kItemTypeToewr];
                                                          NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                          ResearchItem *research = (ResearchItem *)node;
                                                          if (research.isLocked) {
                                                              [self showLockedItem:kItemTypeToewr];
                                                          }
                                                      }];
    ResearchItem *moat_item = [ResearchItem itemWithType:kItemTypeMoat
                                             normalSprite:moat
                                           selectedSprite:nil
                                                    block:^(id sender) {
                                                        CCNode *node = (CCNode *)sender;
                                                        select.position = ccp(node.position.x+wallSV.position.x+node.contentSize.width/2+30, node.position.y-wallSV.position.y-wallSV.contentOffset.y/2);
                                                        [self showInfoWithType:kItemTypeMoat];
                                                        NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                        ResearchItem *research = (ResearchItem *)node;
                                                        if (research.isLocked) {
                                                            [self showLockedItem:kItemTypeMoat];
                                                        }
                                                    }];
    ResearchItem *power_item = [ResearchItem itemWithType:kItemTypeMagicPower
                                              normalSprite:power
                                            selectedSprite:nil
                                                     block:^(id sender) {
                                                         CCNode *node = (CCNode *)sender;
                                                         select.position = ccp(node.position.x+wallSV.position.x+node.contentSize.width/2+30, node.position.y-wallSV.position.y-wallSV.contentOffset.y/2);
                                                        [self showInfoWithType:kItemTypeMagicPower];
                                                         NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                         ResearchItem *research = (ResearchItem *)node;
                                                         if (research.isLocked) {
                                                             [self showLockedItem:kItemTypeMagicPower];
                                                         }
                                                     }];
    ResearchItem *research2_13_item = [ResearchItem itemWithType:kItemTypeSpurting
                                               normalSprite:research2_13
                                             selectedSprite:nil
                                                      block:^(id sender) {
                                                          CCNode *node = (CCNode *)sender;
                                                          select.position = ccp(node.position.x+wallSV.position.x+node.contentSize.width/2+30, node.position.y-wallSV.position.y-wallSV.contentOffset.y/2);
                                                         [self showInfoWithType:kItemTypeSpurting];
                                                          NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                          ResearchItem *research = (ResearchItem *)node;
                                                          if (research.isLocked) {
                                                              [self showLockedItem:kItemTypeSpurting];
                                                          }
                                                      }];
    ResearchItem *burn_item = [ResearchItem itemWithType:kItemTypeBurn
                                             normalSprite:burn
                                           selectedSprite:nil
                                                    block:^(id sender) {
                                                        CCNode *node = (CCNode *)sender;
                                                        select.position = ccp(node.position.x+wallSV.position.x+node.contentSize.width/2+30, node.position.y-wallSV.position.y-wallSV.contentOffset.y/2);
                                                        [self showInfoWithType:kItemTypeBurn];
                                                        NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                        ResearchItem *research = (ResearchItem *)node;
                                                        if (research.isLocked) {
                                                            [self showLockedItem:kItemTypeBurn];
                                                        }
                                                    }];
    ResearchItem *lava_item = [ResearchItem itemWithType:kItemTypeEatangling
                                              normalSprite:lava
                                            selectedSprite:nil
                                                     block:^(id sender) {
                                                         CCNode *node = (CCNode *)sender;
                                                         select.position = ccp(node.position.x+wallSV.position.x+node.contentSize.width/2+30, node.position.y-wallSV.position.y-wallSV.contentOffset.y/2);
                                                        [self showInfoWithType:kItemTypeEatangling];
                                                         NSAssert([node isKindOfClass:[ResearchItem class]], @"node is not kind of ResearchItem");
                                                         ResearchItem *research = (ResearchItem *)node;
                                                         if (research.isLocked) {
                                                             [self showLockedItem:kItemTypeEatangling];
                                                         }
                                                     }];
      
    CCMenu *menu = [CCMenu menuWithItems:research21_03_item, tower_item, moat_item, power_item, research2_13_item, burn_item, lava_item,nil];
    [wallSV addChild:menu z:2];
    
    menu.position = ccp(240,-79);
    
    research21_03_item.position = ccp(-230, 125);
    tower_item.position = ccp(research21_03_item.position.x+137, research21_03_item.position.y + 35);
    
    moat_item.position = ccp(research21_03_item.position.x + 137, research21_03_item.position.y-35 );
    power_item.position = ccp(research21_03_item.position.x+ 275, research21_03_item.position.y +55);
    research2_13_item.position = ccp(research21_03_item.position.x+275, research21_03_item.position.y + 18);
    
    burn_item.position = ccp(research21_03_item.position.x + 275, research21_03_item.position.y-18);
    
    lava_item.position = ccp(research21_03_item.position.x + 275, research21_03_item.position.y-55);
    
    [wallSV addChild:select z:5];
    select.visible = YES;
    select.position = ccp(research21_03_item.position.x+wallSV.position.x+research21_03_item.contentSize.width/2+30, research21_03_item.position.y-wallSV.position.y-wallSV.contentOffset.y/2);
    
    wallSV.visible = YES;
    
    chooseType = kItemTypeWall;
    [self showInfoWithType:chooseType];
}
- (void)initBowSV
{
    [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"coin.png"]];
    bowSV = [SWScrollView viewWithViewSize:CGSizeMake(412, 200)];
    bowSV.contentSize = CGSizeMake(600, 150);
    bowSV.direction = SWScrollViewDirectionBoth;
    bowSV.contentOffset = ccp(0, 50);
    bowSV.position = ccp(size.width/2-135, size.height/2-90);
    bowSV.bounces = NO;
    [self addChild:bowSV z:1];
    
    CCSprite *select = [CCSprite spriteWithFile:@"icon_select.png"];
    [bowSV addChild:select z:3];
    select.visible = NO;
    
    GameData *gameData = [GameData shareGameDataInstance];
    NSAssert(gameData != nil, @"game data is not init");
    
    NSString *bowName;
    NSMutableArray *menuArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        for (int j = 1; j <= 9; j++) {
            CCSprite *bow;
            BowType currentType;
            NSString *priStr = @"";
            switch (i) {
                case 0:
                    bowName = [NSString stringWithFormat:@"icon_pow_0%d.png", j];
                    bow = [CCSprite spriteWithSpriteFrameName:bowName];
                    currentType = kBowTypePow;
                    break;
                case 1:
                    bowName = [NSString stringWithFormat:@"icon_agi_0%d.png", j];
                    bow = [CCSprite spriteWithSpriteFrameName:bowName];
                    currentType = kBowTypeAgi;
                    priStr = [NSString stringWithFormat:@"%d", 500 + (j-1) * 2000];
                    break;
                case 2:
                    bowName = [NSString stringWithFormat:@"icon_multi_0%d.png", j];
                    bow = [CCSprite spriteWithSpriteFrameName:bowName];
                    currentType = kBowTypeMul;
                    [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
                    priStr = [NSString stringWithFormat:@"%d", 2 + (j-1) * 8];
                    break;
                default:
                    break;
            }
            BOOL isLocked = YES;
            BOOL isMine = 0;
            isMine = [[gameData.bowsArray objectAtIndex:j + i * 9] boolValue];
            
            if (gameData.level >= (j - 1) * 5) {
                isLocked = NO;
            }
            CCMenuItemSprite *itemSprite = [CCMenuItemSprite itemWithNormalSprite:bow selectedSprite:nil block:^(id sender) {
                CCNode *node = (CCNode *)sender;
                select.visible = YES;
                select.position = ccp(node.position.x+bowSV.position.x+node.contentSize.width + 75, node.position.y+node.contentSize.height - 10);
                [self showBowInfo:currentType lvl:j];
                NSLog(@"%i", isMine);
                zhuangbei.visible = NO;
                chooseBowType = currentType;
                chooseBowLvl = j;
                if (isLocked) {
                    price.visible = NO;
                    buy.visible = NO;
                    coin.visible = NO;
                    priceInfo.visible = YES;
                    [priceInfo setString:[NSString stringWithFormat:@"需求\n等级%d\n以解锁", (j-1)*5]];
                } else if (isMine) {
                    zhuangbei.visible = YES;
                    buy.visible = NO;
                    coin.visible = NO;
                    [priceInfo setString:@""];
                    [price setString:@""];
                } else {
                    price.visible = YES;
                    [price setString:priStr];
                    coin.visible = YES;
                    buy.visible = YES;
                    zhuangbei.visible = NO;
                    [priceInfo setString:@""];
                }
            }];
            
            itemSprite.tag = currentType;
            
            if (isLocked) {
                CCSprite *bowLock = [CCSprite spriteWithFile:@"locking.png"];
                [itemSprite setNormalImage:bowLock];
            }//word_add.png
            [menuArray addObject:itemSprite];
        }
    }
    CCMenu *menu = [CCMenu menuWithArray:menuArray];
    [menu alignItemsInColumns:[NSNumber numberWithInt:9], [NSNumber numberWithInt:9], [NSNumber numberWithInt:9], nil];

    menu.position = ccp(240, bowSV.viewSize.height/2 - bowSV.contentOffset.y);
    [bowSV addChild:menu z:1 tag:1];
    
    CCMenuItemSprite *normalBow = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"icon_normal.png"]
                                                          selectedSprite:nil
                                                                   block:^(id sender) {
        CCNode *node = (CCNode *)sender;
        select.visible = YES;
        select.position = ccp(node.position.x+bowSV.position.x+node.contentSize.width + 75, node.position.y+node.contentSize.height - 10);
        [self showBowInfo:kBowTypeNormal lvl:1];
        
        chooseBowType = kBowTypeNormal;
        chooseBowLvl = 1;
        zhuangbei.visible = YES;
        buy.visible = NO;
        [priceInfo setString:@""];
        [price setString:@""];
    }];
    CCMenuItemSprite *finalBow = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"icon_super.png"]
                                                         selectedSprite:nil
                                                                  block:^(id sender) {
        CCNode *node = (CCNode *)sender;
        select.visible = YES;
        select.position = ccp(node.position.x+bowSV.position.x+node.contentSize.width + 75, node.position.y+node.contentSize.height - 10);
        [self showBowInfo:kBowTypeFinal lvl:1];

        chooseBowType = kBowTypeFinal;
        chooseBowLvl = 1;
        BOOL isMine = 0;
        isMine = [[gameData.bowsArray objectAtIndex:29] boolValue];
          
        if (isMine) {
            zhuangbei.visible = YES;
            buy.visible = NO;
            coin.visible = NO;
            [priceInfo setString:@""];
            [price setString:@""];
        } else {
             price.visible = YES;
            [price setString:@"250"];
            coin.visible = YES;
            buy.visible = YES;
            zhuangbei.visible = NO;
            [priceInfo setString:@""];
        }
    }];

    
    CCMenu *menu2 = [CCMenu menuWithItems:normalBow, finalBow, nil];
    [menu2 alignItemsHorizontallyWithPadding:bowSV.contentSize.width - 140];
    menu2.position = ccp(240, bowSV.viewSize.height/2 - bowSV.contentOffset.y);
    [bowSV addChild:menu2 z:1 tag:1];
    
    chooseBowType = gameData.currentBowType;
    chooseBowLvl = gameData.currentBowLvl;
    zhuangbei.visible = YES;
    buy.visible = NO;
    [priceInfo setString:@""];
    [price setString:@""];
    coin.visible = NO;
    [self showBowInfo:chooseBowType lvl:chooseBowLvl];

}
- (void)equip
{
    GameData *gameData = [GameData shareGameDataInstance];
    [gameData setCurrentBowType:chooseBowType];
    [gameData setCurrentBowLvl:chooseBowLvl];
    NSString *name;
    switch (chooseBowType) {
        case kBowTypeNormal:
            name = @"icon_normal.png";
            break;
        case kBowTypePow:
            name = [NSString stringWithFormat:@"icon_pow_0%d.png", chooseBowLvl];
            break;
        case kBowTypeAgi:
            name = [NSString stringWithFormat:@"icon_agi_0%d.png", chooseBowLvl];
            break;
        case kBowTypeMul:
            name = [NSString stringWithFormat:@"icon_multi_0%d.png", chooseBowLvl];
            break;
        case kBowTypeFinal:
            name = @"icon_super.png";
            break;
        default:
            break;
    }
    [[SimpleAudioEngine sharedEngine] playEffect:@"button_upgrade.caf"];
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:name];
    [weapon setNormalImage:sprite];
    [gameData save];
}

- (void)showBowInfo:(BowType)bowType lvl:(int)bowLvl
{
    current.string = @"";
    next.string = @"";
    [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"coin.png"]];
    int strength = 0, agility = 0, power = 0, deadly = 0, mutable = 0;
    switch (bowType) {
        case kBowTypeNormal:
            [info_name setString:@"轻弩"];
            [info_describe setString:@"新手弓."];
            break;
        case kBowTypePow:
            [info_name setString:[NSString stringWithFormat:@"火山之弓 等级.%d", bowLvl]];
            [info_describe setString:@"拥有强力火力的弓"];
            if ( bowLvl >= 3 && bowLvl <= 5) {
                power = 1;
            } else if ( bowLvl >= 6 && bowLvl <= 8 ) {
                power = 2;
            } else if (bowLvl == 9) {
                power = 3;
            } else {
                power = 0;
            }
            strength = bowLvl;
            break;
        case kBowTypeAgi:
            [info_name setString:[NSString stringWithFormat:@"飓风之弓 等级.%d", bowLvl]];
            [info_describe setString:@"攻击速度非常高的弓"];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"coin.png"]];
            switch (bowLvl) {
                case 1:
                    strength = 1;
                    agility = 1;
                    power = 0;
                    deadly = 0;
                    mutable = 0;
                    break;
                case 2:
                    strength = 2;
                    agility = 2;
                    power = 0;
                    deadly = 0;
                    mutable = 0;
                    break;
                case 3:
                    strength = 3;
                    agility = 2;
                    power = 0;
                    deadly = 1;
                    mutable = 0;
                    break;
                case 4:
                    strength = 4;
                    agility = 3;
                    power = 0;
                    deadly = 1;
                    mutable = 0;
                    break;
                case 5:
                    strength = 4;
                    agility = 4;
                    power = 0;
                    deadly = 2;
                    mutable = 0;
                    break;
                case 6:
                    strength = 5;
                    agility = 5;
                    power = 0;
                    deadly = 2;
                    mutable = 0;
                    break;
                case 7:
                    strength = 6;
                    agility = 5;
                    power = 0;
                    deadly = 3;
                    mutable = 0;
                    break;
                case 8:
                    strength = 7;
                    agility = 6;
                    power = 0;
                    deadly = 3;
                    mutable = 0;
                    break;
                case 9:
                    strength = 8;
                    agility = 6;
                    power = 0;
                    deadly = 4;
                    mutable = 0;
                    break;
                default:
                    NSLog(@"level shoul between 1-9");
                    break;
            }
            break;
        case kBowTypeMul:
            [info_name setString:[NSString stringWithFormat:@"幽灵之弓 等级.%d", bowLvl]];
            [info_describe setString:@"附带魔法力量的弓"];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
            switch (bowLvl) {
                case 1:
                    strength = 2;
                    agility = 1;
                    power = 0;
                    deadly = 0;
                    mutable = 0;
                    break;
                case 2:
                    strength = 3;
                    agility = 2;
                    power = 0;
                    deadly = 1;
                    mutable = 0;
                    break;
                case 3:
                    strength = 4;
                    agility = 3;
                    power = 1;
                    deadly = 1;
                    mutable = 0;
                    break;
                case 4:
                    strength = 5;
                    agility = 4;
                    power = 1;
                    deadly = 2;
                    mutable = 0;
                    break;
                case 5:
                    strength = 6;
                    agility = 5;
                    power = 1;
                    deadly = 2;
                    mutable = 1;
                    break;
                case 6:
                    strength = 7;
                    agility = 6;
                    power = 2;
                    deadly = 2;
                    mutable = 1;
                    break;
                case 7:
                    strength = 8;
                    agility = 6;
                    power = 2;
                    deadly = 3;
                    mutable = 2;
                    break;
                case 8:
                    strength = 9;
                    agility = 7;
                    power = 3;
                    deadly = 3;
                    mutable = 2;
                    break;
                case 9:
                    strength = 9;
                    agility = 8;
                    power = 3;
                    deadly = 4;
                    mutable = 3;
                    break;
                default:
                    NSLog(@"level shoul between 1-9");
                    break;
            }
            break;
        case kBowTypeFinal:
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
            [info_name setString:@"最终幻想"];
            [info_describe setString:@"拥有神秘之力"];
            break;
        default:
            break;
    }
    NSString *strength_str, *agility_str, *power_str, *deadly_str, *mutable_str;
    if (strength <= 0) {
        strength_str = @"";
    } else {
        strength_str = [NSString stringWithFormat:@"力量%i", strength];
    }
    if (agility <= 0) {
        agility_str = @"";
    } else {
        agility_str = [NSString stringWithFormat:@",敏捷%i", agility];
    }
    if (power <= 0) {
        power_str = @"";
    } else {
        power_str = [NSString stringWithFormat:@",强力击%i", power];
    }
    if (deadly <= 0) {
        deadly_str = @"";
    } else {
        deadly_str = [NSString stringWithFormat:@"致命一击%i", deadly];
    }
    if (mutable <= 0) {
        mutable_str = @"";
    } else {
        mutable_str = [NSString stringWithFormat:@",多重箭%i", mutable];
    }
    [info_grade setString:[NSString stringWithFormat:@"%@%@%@\n%@%@", strength_str, agility_str, power_str, deadly_str, mutable_str]];
}

- (void)showLockedItem:(ItemType)itemType
{
    chooseType = itemType;
    GameData *game_data = [GameData shareGameDataInstance];
    NSAssert(game_data != nil, @"game data is nil:showInfoWithType");

    price.visible = NO;
    buy.visible = NO;
    coin.visible = NO;
    priceInfo.visible = YES;
    
    switch (itemType) {
        case kItemTypeBlow:
            [priceInfo setString:@"  需要\n力量 等级.5"];
            break;
        case kItemTypePoison:
            [priceInfo setString:@"  需要\n力量 等级.10\n速度 等级.10"];
            break;
        case kItemTypePower:
            [priceInfo setString:@"  需要\n速度 等级 5"];
            break;
        case kItemTypeMultiple:
            [priceInfo setString:@"  需要\n强力击 等级.10\n致命一击 等级.10"];
            break;
        case kItemTypeDefender:
            [priceInfo setString:@"  需要\n多重箭 等级.2"];
            break;
        case kItemTypeIceOne:
            [priceInfo setString:@"  需要\n魔力研究 等级.2"];
            break;
        case kItemTypeIceTow:
            [priceInfo setString:@"  需要\n魔力研究 等级.4\n冰锥 等级.3"];
            break;
        case kItemTypeIceThree:
            [priceInfo setString:@"  需要\n魔力研究 等级.6\n冰霜新星 等级.3"];
            break;
        case kItemTypeFireOne:
            [priceInfo setString:@"  需要\n魔力研究 等级.2"];
            break;
        case kItemTypeFireTow:
            [priceInfo setString:@"  需要\n魔力研究 等级.4\n火球 等级.3"];
            break;
        case kItemTypeFireThree:
            [priceInfo setString:@"  需要\n魔力研究 等级.6\n流星 等级.3"];
            break;
        case kItemTypeLightOne:
            [priceInfo setString:@"  需要\n魔力研究 等级.2"];
            break;
        case kItemTypeLightTow:
            [priceInfo setString:@"  需要\n魔力研究 等级.4\n闪电 等级.3"];
            break;
        case kItemTypeLightThree:
            [priceInfo setString:@"  需要\n魔力研究 等级.6\n闪电风暴 等级.3"];
            break;
        case kItemTypeToewr:
            [priceInfo setString:@"  需要\n城墙 等级.3"];
            break;
        case kItemTypeMoat:
            [priceInfo setString:@"  需要\n城墙 等级.3"];
            break;
        case kItemTypeMagicPower:
            [priceInfo setString:@"  需要\n魔法塔 等级.1"];
            break;
        case kItemTypeSpurting:
            [priceInfo setString:@"  需要\n魔法塔 等级.1"];
            break;
        case kItemTypeBurn:
            [priceInfo setString:@"  需要\n岩浆防御 等级.1"];
            break;
        case kItemTypeEatangling:
            [priceInfo setString:@"  需要\n岩浆防御 等级.1"];
            break;
        default:
            break;
    }
}

- (void)showInfoWithType:(ItemType)itemType
{
    buy.visible = YES;
    zhuangbei.visible = NO;
    chooseType = itemType;
    GameData *gameData = [GameData shareGameDataInstance];
    NSAssert(gameData != nil, @"game data is nil:showInfoWithType");
    [info_grade setString:@"当前:             下级:"];
    [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"coin.png"]];
   
    price.visible = YES;
    buy.visible = YES;
    coin.visible = YES;
    priceInfo.string = @"";
   
    switch (itemType) {
        case kItemTypeStrength:
        {
            int strength = gameData.strength;
            if (strength >= 300) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"力量"];
            [info_describe setString:@"增加您箭的基础伤害"];
            [current setString:[NSString stringWithFormat:@"%i", strength*4 + 20]];
            [next setString:[NSString stringWithFormat:@"%i", (strength + 1)*4 + 20]];
            [price setString:[NSString stringWithFormat:@"%i", strength * 200 + 300]];
        }
            break;
        case kItemTypeAgility:
        {
            int agility = gameData.agility;
            if (agility >= 30) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"速度"];
            [info_describe setString:@"增加您弓的射击速度"];
            [current setString:[NSString stringWithFormat:@"%i", gameData.agility * 2 + 15]];
            [next setString:[NSString stringWithFormat:@"%i", (gameData.agility+1)*2 + 15]];
            [price setString:[NSString stringWithFormat:@"%i", gameData.agility * 200 + 300]];
        }
            break;
        case kItemTypePower:
        {
            int powerAtk = gameData.powerAtk;
            if (powerAtk >= 9) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"强力击"];
            [info_describe setString:@"您的箭可以将怪物击退一段距离"];
            [info_grade setString:@"升级增加击退距离"];
            [current setString:@""];
            [next setString:@""];
            int p = gameData.powerAtk >= 6 ? 3000 : 8800;
            [price setString:[NSString stringWithFormat:@"%i", p + 2000]];
        }
            break;
        case kItemTypePoison:
        {
            int poison = gameData.poisonArrow;
            if (poison >= 9) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"毒箭"];
            [info_describe setString:@"射击毒箭来减慢怪物的速度"];
            [current setString:[NSString stringWithFormat:@"%i", gameData.poisonArrow * 5]];
            [next setString:[NSString stringWithFormat:@"%i", (gameData.poisonArrow + 1) * 5]];
            [price setString:[NSString stringWithFormat:@"%i", gameData.poisonArrow * 4000 + 3000]];
        }
            break;
        case kItemTypeBlow:
        {
            int deadlyAtk = gameData.deadlyAtk;
            if (deadlyAtk >= 15) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"致命一击"];
            [info_describe setString:@"您的弓可以造成双倍伤害"];
            [current setString:[NSString stringWithFormat:@"%i", gameData.deadlyAtk * 3 / 2 + 50]];
            [next setString:[NSString stringWithFormat:@"%i", (gameData.deadlyAtk + 1) * 3 / 2 + 50]];
            [price setString:[NSString stringWithFormat:@"%i", gameData.deadlyAtk * 4000 + 1000]];
        }
            break;
        case kItemTypeMultiple:
        {
            int multipleArrow = gameData.multipleArrow;
            if (multipleArrow >= 30) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"多重箭"];
            [info_describe setString:@"您的弓可以一次射出多支箭"];
            float xishu;
            int _multipleArrow;
            int multipleArrowLvl = gameData.multipleArrow;
            if (multipleArrowLvl <= 0) {
                _multipleArrow = 1;
                xishu = 1;
            } else if (multipleArrowLvl >= 1 && multipleArrowLvl < 4) {
                _multipleArrow = 2;
                xishu = 0.05 * (multipleArrowLvl-1) + 0.5;
            } else if (multipleArrowLvl >= 4 && multipleArrowLvl < 8) {
                _multipleArrow = 3;
                xishu = 0.05 * (multipleArrowLvl-4) + 0.5;
            } else if (multipleArrowLvl >= 8 && multipleArrowLvl <= 12) {
                _multipleArrow = 4;
                xishu = 0.05 * (multipleArrowLvl-8) + 0.5;
            } else {
                _multipleArrow = 5;
                xishu = 0.02 * (multipleArrowLvl - 5) + 0.5;
            }
            [info_grade setString:[NSString stringWithFormat:@"\n当前: %i  支箭     %i%c伤害", _multipleArrow, (int)xishu * 100, '%']];
            [current setString:@""];
            [next setString:@""];
            [price setString:[NSString stringWithFormat:@"%i", gameData.multipleArrow * 16000 + 11500]];
        }
            break;
        case kItemTypeDefender:
        {
            if (gameData.defender >= 9) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
                return;
            }
            [info_name setString:@"高级猎手"];
            [info_describe setString:@"可以获得额外的XP"];
            [current setString:[NSString stringWithFormat:@"%i%c", gameData.defender * 5, '%']];
            [next setString:[NSString stringWithFormat:@"%i%c", (gameData.defender + 1) * 5, '%']];
            [price setString:[NSString stringWithFormat:@"%i", gameData.deadlyAtk * 2000 + 2000]];
        }
            break;
         //魔法
        case kItemTypeManaResearch:
        {
            if (gameData.manaSkill_lvl >= 9) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"魔法研究"];
            [info_describe setString:@"增加您的魔法值"];
            [info_grade setString:@"当前:             下级:"];
            [current setString:[NSString stringWithFormat:@"%i", gameData.manaSkill_lvl * 20 + 80]];
            [next setString:[NSString stringWithFormat:@"%i", (gameData.manaSkill_lvl + 1) * 20 + 80]];
            [price setString:[NSString stringWithFormat:@"%i", gameData.manaSkill_lvl * 5 + 5]];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
        }
            break;
        case kItemTypeLightOne:
        {
            if (gameData.lightSkillOne_lvl >= 9) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"闪电"];
            [info_describe setString:@"初级电系魔法，可以麻痹怪物"];
            [info_grade setString:@"升级:增加伤害和麻痹时间"];
            [current setString:@""];
            [next setString:@""];
            [price setString:[NSString stringWithFormat:@"%i", gameData.lightSkillOne_lvl * 2 + 5]];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
        }
            break;
        case kItemTypeLightTow:
        {
            if (gameData.lightSkillTwo_lvl >= 9) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"闪电风暴"];
            [info_describe setString:@"中级级电系魔法，可以麻痹怪物"];
            [info_grade setString:@"升级:增加伤害和麻痹时间"];
            [current setString:@""];
            [next setString:@""];
            [price setString:[NSString stringWithFormat:@"%i", gameData.lightSkillTwo_lvl * 3 + 9]];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
        }
             break;
        case kItemTypeLightThree:
        {
            if (gameData.lightSkillThree_lvl >= 9) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"诸神黄昏"];
            [info_describe setString:@"高级级电系魔法，可以麻痹怪物"];
            [info_grade setString:@"升级:增加伤害和麻痹时间"];
            [current setString:@""];
            [next setString:@""];
            [price setString:[NSString stringWithFormat:@"%i", gameData.lightSkillThree_lvl * 4 + 13]];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
        }
            break;
        case kItemTypeFireOne:
        {
            if (gameData.fireSkillOne_lvl >= 9) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"冰川"];
            [info_describe setString:@"初级级冰系魔法，可以冰洁怪物"];
            [info_grade setString:@"升级:增加伤害和冰洁时间"];
            [current setString:@""];
            [next setString:@""];
            [price setString:[NSString stringWithFormat:@"%i", gameData.fireSkillOne_lvl * 2 + 5]];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
        }
            break;
        case kItemTypeFireTow:
        {
            if (gameData.fireSkillTwo_lvl >= 9) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"霜之新星"];
            [info_describe setString:@"中级级冰系魔法，可以冰洁怪物"];
            [info_grade setString:@"升级:增加伤害和冰洁时间"];
            [current setString:@""];
            [next setString:@""];
            [price setString:[NSString stringWithFormat:@"%i", gameData.fireSkillTwo_lvl * 3 + 9]];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
        }
            break;
        case kItemTypeFireThree:
        {
            if (gameData.fireSkillThree_lvl >= 9) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"冰河时代"];
            [info_describe setString:@"高级级冰系魔法，可以冰洁怪物"];
            [info_grade setString:@"升级:增加伤害和冰洁时间"];
            [current setString:@""];
            [next setString:@""];
            [price setString:[NSString stringWithFormat:@"%i", gameData.fireSkillThree_lvl * 4 + 13]];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
        }
            break;
        case kItemTypeIceOne:
        {
            if (gameData.iceSkillOne_lvl >= 9) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"烈火球"];
            [info_describe setString:@"初级火系魔法，可以烧伤怪物"];
            [info_grade setString:@"升级:增加伤害和烧伤时间"];
            [current setString:@""];
            [next setString:@""];
            [price setString:[NSString stringWithFormat:@"%i", gameData.iceSkillOne_lvl * 2 + 5]];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
        }
            break;
        case kItemTypeIceTow:
        {
            if (gameData.iceSkillTwo_lvl >= 9) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"流星之椎"];
            [info_describe setString:@"中级火系魔法，可以烧伤怪物"];
            [info_grade setString:@"升级:增加伤害和烧伤时间"];
            [current setString:@""];
            [next setString:@""];
            [price setString:[NSString stringWithFormat:@"%i", gameData.iceSkillTwo_lvl * 3 + 9]];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
        }
            break;
        case kItemTypeIceThree:
        {
            if (gameData.iceSkillThree_lvl >= 9) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"末日审判"];
            [info_describe setString:@"高级火系魔法，可以烧伤怪物"];
            [info_grade setString:@"升级:增加伤害和烧伤时间"];
            [current setString:@""];
            [next setString:@""];
            [price setString:[NSString stringWithFormat:@"%i", gameData.iceSkillThree_lvl * 4 + 13]];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
        }
            break;
        case kItemTypeWall:
        {
            if (gameData.wall >= 21) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"城墙"];
            [info_describe setString:@"增加您的生命值"];
            [info_grade setString:@"当前:             下级:"];
            [current setString:[NSString stringWithFormat:@"%i", gameData.wall * 10 + 80]];
            [next setString:[NSString stringWithFormat:@"%i", (gameData.wall + 1) * 10 + 80]];
            [price setString:[NSString stringWithFormat:@"%i", gameData.wall * 800 + 700]];
        }
            break;
        case kItemTypeToewr:
        {
            if (gameData.toewr >= 2) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"魔法塔"];
            [info_describe setString:@"自动攻击怪物"];
            [info_grade setString:@"升级:增加塔的数量"];
            [current setString:@""];
            [next setString:@""];
            [price setString:[NSString stringWithFormat:@"%i", gameData.toewr * 150 + 8]];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
        }
            break;
        case kItemTypeMoat:
        {
            if (gameData.moat >= 3) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"熔岩护城"];
            [info_describe setString:@"城墙前方的熔岩"];
            [info_grade setString:@"升级:增加熔岩护城的宽度"];
            [current setString:@""];
            [next setString:@""];
            [price setString:[NSString stringWithFormat:@"%i", gameData.moat * 150 + 8]];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
        }
            break;
        case kItemTypeMagicPower:
        {
            if (gameData.magicPower >= 99) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"魔法能量"];
            [info_describe setString:@"增加塔的伤害"];
            [info_grade setString:@"当前:             下级:"];
            [current setString:[NSString stringWithFormat:@"%i", gameData.magicPower * 5 + 40]];
            [next setString:[NSString stringWithFormat:@"%i", (gameData.magicPower + 1) * 5 + 40]];
            [price setString:[NSString stringWithFormat:@"%i", gameData.magicPower * 500 + 1000]];
        }
            break;
        case kItemTypeSpurting:
        {
            if (gameData.spurting >= 20) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"溅射伤害"];
            [info_describe setString:@"塔的攻击会造成溅射伤害"];
            [info_grade setString:@"当前:             下级:"];
            [current setString:[NSString stringWithFormat:@"%i%c", gameData.spurting * 5 + 5, '%']];
            [next setString:[NSString stringWithFormat:@"%i%c", (gameData.spurting + 1) * 5 + 5, '%']];
            [price setString:[NSString stringWithFormat:@"%i", gameData.spurting * 7 + 8]];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
        }
            break;
        case kItemTypeBurn:
        {
            if (gameData.burn >= 99) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"岩浆灼烧"];
            [info_describe setString:@"增加熔岩的伤害"];
            [info_grade setString:@"当前:             下级:"];
            [current setString:[NSString stringWithFormat:@"%i", gameData.burn * 5 + 20]];
            [next setString:[NSString stringWithFormat:@"%i", (gameData.spurting + 1) * 5 + 20]];
            [price setString:[NSString stringWithFormat:@"%i", gameData.spurting * 500 + 1000]];
        }
            break;
        case kItemTypeEatangling:
        {
            if (gameData.eatangling >= 20) {
                price.visible = NO;
                buy.visible = NO;
                coin.visible = NO;
                [priceInfo setString:@"最高级"];
            }
            [info_name setString:@"扰乱岩流"];
            [info_describe setString:@"熔岩护城可以减慢怪物的速度"];
            [info_grade setString:@"当前:             下级:"];
            [current setString:[NSString stringWithFormat:@"%i%c", gameData.eatangling * 2 + 12, '%']];
            [next setString:[NSString stringWithFormat:@"%i%c", (gameData.eatangling + 1) * 2 + 12, '%']];
            [price setString:[NSString stringWithFormat:@"%i", gameData.eatangling * 7 + 8]];
            [coin setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"mana_stone.png"]];
        }
            break;
        default:
            break;
    }
}
- (void)showLayer:(int)flag
{
    [self hideSkillMenu];
    
    bowSV.visible = NO;
    bow_down.visible = NO;
    
    magicSV.visible = NO;
    magic_down.visible = NO;
    
    wallSV.visible = NO;
    wall_down.visible = NO;
    
    defenderSV.visible = NO;
    defender_down.visible = NO;
    switch (flag) {
        case 1:
            
            [self initPropertySV];
            
            defenderSV.visible = YES;
            defender_down.visible = YES;
            
            break;
        case 2:
            [self initmagicSV];
            
            magicSV.visible = YES;
            magic_down.visible = YES;
            break;
        case 3:
            
            [self initwallcSV];
            
            wallSV.visible = YES;
            wall_down.visible = YES;
            break;
        case 4:
            chooseType = kItemTypeNone;
            [self initBowSV];
            
            bowSV.visible = YES;
            bow_down.visible = YES;
            break;
            
        default:
            break;
    }
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
    GADBannerView *v = (GADBannerView *)[[[CCDirector sharedDirector] view] viewWithTag:1];
    [v removeFromSuperview];
    v.delegate = nil;
    [GameData shareGameDataInstance].hadClickedAd = YES;
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
    GADBannerView *v = (GADBannerView *)[[[CCDirector sharedDirector] view] viewWithTag:1];
    [v removeFromSuperview];
    v.delegate = nil;
    [GameData shareGameDataInstance].hadClickedAd = YES;
}

- (void)dealloc
{
    CCLOG(@"%@ : %@", NSStringFromSelector(_cmd), self);
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    GADBannerView *v = (GADBannerView *)[[[CCDirector sharedDirector] view] viewWithTag:1];
    v.delegate = nil;
    [super dealloc];
}

@end
