//
//  ResearchItem.m
//  DefeatTheMonster
//
//  Created by wujiajing on 13-10-17.
//  Copyright 2013年 nchu. All rights reserved.
//

#import "ResearchItem.h"

#import "GameData.h"
#import "Bow.h"

@implementation ResearchItem

@synthesize isLocked = _isLocked;

+ (id)itemWithType:(ItemType)itemtype normalSprite:(CCNode<CCRGBAProtocol> *)normalSprite selectedSprite:(CCNode<CCRGBAProtocol> *)selectedSprite block:(void (^)(id))block
{
    return [[[self alloc] initWithType:itemtype normalSprite:normalSprite selectedSprite:selectedSprite block:block] autorelease];
}

- (id)initWithType:(ItemType)itemtype normalSprite:(CCNode<CCRGBAProtocol> *)normalSprite selectedSprite:(CCNode<CCRGBAProtocol> *)selectedSprite block:(void (^)(id))block
{
    int topNum;
    int bottomNum;
    
    topNum = [self getTopByType:itemtype];
    bottomNum = [self getBottomByType:itemtype];
    
    if (self = [super initWithNormalSprite:normalSprite selectedSprite:selectedSprite disabledSprite:nil block:block]) {
        
        type = itemtype;
        NSString *topStr;
        NSString *bottomStr;
        if (topNum == 0) {
            topStr = @"";
        } else {
            topStr = [NSString stringWithFormat:@"%i", topNum];
        }
        if (bottomNum == 0) {
            bottomStr = @"";
        } else {
            bottomStr = [NSString stringWithFormat:@"%i", bottomNum];
        }
        topLabel = [CCLabelAtlas labelWithString:topStr
                                     charMapFile:@"z_number5.png"
                                       itemWidth:7
                                      itemHeight:10
                                    startCharMap:'+'];
        
        topLabel.anchorPoint = ccp(1, 0.5);
        topLabel.position = ccp(30, self.contentSize.height-topLabel.contentSize.height/2 - 2);
        
        bottomLabel = [CCLabelAtlas labelWithString:bottomStr
                                        charMapFile:@"z_number4.png"
                                          itemWidth:7
                                         itemHeight:9
                                       startCharMap:'0'];
        
        bottomLabel.anchorPoint = ccp(1, 0.5);
        bottomLabel.position = ccp(30, bottomLabel.contentSize.height/2 + 2);
        
        lockSprite = [CCSprite spriteWithFile:@"logo_locked.png"];
        lockSprite.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:lockSprite];
        if (itemtype == kItemTypeStrength || itemtype == kItemTypeAgility) {
            _isLocked = NO;
            lockSprite.visible = NO;
        } else {
            _isLocked = YES;
        }
        [self addChild:topLabel];
        [self addChild:bottomLabel];
        [self scheduleUpdate];

    }
    
    return self;
}
//word_lv.png
- (int)getBottomByType:(ItemType)itemType
{
    int bottomNum;
    
    GameData *game_data = [GameData shareGameDataInstance];
    NSAssert(game_data != nil, @"ResearchItem.m: game data didnt init!!");
    switch (itemType) {
        case kItemTypeStrength:
            bottomNum = game_data.strength;
            break;
        case kItemTypeAgility:
            bottomNum = game_data.agility;
            break;
        case kItemTypeBlow:
            if (game_data.strength >= 5) {
                _isLocked = NO;
            }
            bottomNum = game_data.deadlyAtk;
            break;
        case kItemTypePoison:
            if (game_data.strength >= 10 && game_data.agility >= 10) {
                _isLocked = NO;
            }
            bottomNum = game_data.poisonArrow;
            break;
        case kItemTypePower:
            if (game_data.agility >= 5) {
                _isLocked = NO;
            }
            bottomNum = game_data.powerAtk;
            break;
        case kItemTypeMultiple:
            if (game_data.powerAtk >= 3 && game_data.deadlyAtk >= 3) {
                _isLocked = NO;
            }
            bottomNum = game_data.multipleArrow;
            break;
        case kItemTypeDefender:
            if (game_data.multipleArrow >= 2) {
                _isLocked = NO;
            }
            bottomNum = game_data.defender;
            break;
        case kItemTypeManaResearch:
            _isLocked = NO;
            bottomNum = game_data.manaSkill_lvl;
            break;
        case kItemTypeIceOne:
            if (game_data.manaSkill_lvl >= 2) {
                _isLocked = NO;
            }
            bottomNum = game_data.iceSkillOne_lvl;
            break;
        case kItemTypeIceTow:
            if (game_data.manaSkill_lvl >= 4 && game_data.iceSkillOne_lvl >= 3) {
                _isLocked = NO;
            }
            bottomNum = game_data.iceSkillTwo_lvl;
            break;
        case kItemTypeIceThree:
            if (game_data.manaSkill_lvl >= 6 && game_data.iceSkillTwo_lvl >= 3) {
                _isLocked = NO;
            }
            bottomNum = game_data.iceSkillThree_lvl;
            break;
        case kItemTypeFireOne:
            _isLocked = NO;
            bottomNum = game_data.fireSkillOne_lvl;
            break;
        case kItemTypeFireTow:
            if (game_data.manaSkill_lvl >= 4 && game_data.fireSkillOne_lvl >= 3) {
                _isLocked = NO;
            }
            bottomNum = game_data.fireSkillTwo_lvl;
            break;
        case kItemTypeFireThree:
            if (game_data.manaSkill_lvl >= 6 && game_data.fireSkillTwo_lvl >= 3) {
                _isLocked = NO;
            }
            bottomNum = game_data.fireSkillThree_lvl;
            break;
        case kItemTypeLightOne:
            if (game_data.manaSkill_lvl >= 2) {
                _isLocked = NO;
            }
            bottomNum = game_data.lightSkillOne_lvl;
            break;
        case kItemTypeLightTow:
            if (game_data.manaSkill_lvl >= 4 && game_data.lightSkillOne_lvl >= 3) {
                _isLocked = NO;
            }
            bottomNum = game_data.lightSkillTwo_lvl;
            break;
        case kItemTypeLightThree:
            if (game_data.manaSkill_lvl >= 6 && game_data.lightSkillTwo_lvl >= 3) {
                _isLocked = NO;
            }
            bottomNum = game_data.lightSkillThree_lvl;
            break;
        case kItemTypeWall:
            _isLocked = NO;
            bottomNum = game_data.wall;
            break;
        case kItemTypeToewr:
            if (game_data.wall >= 3) {
                _isLocked = NO;
            }
            bottomNum = game_data.toewr;
            break;
        case kItemTypeMoat:
            if (game_data.wall >= 3) {
                _isLocked = NO;
            }
            bottomNum = game_data.moat;
            break;
        case kItemTypeMagicPower:
            if (game_data.toewr >= 1) {
                _isLocked = NO;
            }
            bottomNum = game_data.magicPower;
            break;
        case kItemTypeSpurting:
            if (game_data.toewr >= 1) {
                _isLocked = NO;
            }
            bottomNum = game_data.spurting;
            break;
        case kItemTypeBurn:
            if (game_data.moat >= 1) {
                _isLocked = NO;
            }
            bottomNum = game_data.burn;
            break;
        case kItemTypeEatangling:
            if (game_data.moat >= 1) {
                _isLocked = NO;
            }
            bottomNum = game_data.eatangling;
            break;
        default:
            break;
    }
    return bottomNum;
}
- (int)getTopByType:(ItemType)itemType
{
    int topNum;
    GameData *game_data = [GameData shareGameDataInstance];
    NSAssert(game_data != nil, @"ResearchItem.m: game data didnt init!!");
    Bow *bow = [Bow bowWithType:game_data.currentBowType bowLvl:game_data.currentBowLvl];
    
    switch (itemType) {
        case kItemTypeStrength:
            topNum = bow.strength;
            break;
        case kItemTypeAgility:
            topNum = bow.agility;
            break;
        case kItemTypeBlow:
            topNum = bow.deadlyAtk;
            break;
        case kItemTypePower:
            topNum = bow.powerAtk;
            break;
        case kItemTypeMultiple:
            topNum = bow.multipleArrow;
            break;
        default:
            topNum = 0;
            break;
    }
    
    return topNum;

}
- (void)update:(ccTime)delta
{
    int topNum = 0;
    int bottomNum = 0;
    
    bottomNum = [self getBottomByType:type];
    
    if (_isLocked) {
        lockSprite.visible = YES;
        return;
    } else {
        lockSprite.visible = NO;
    }
    topNum = [self getTopByType:type];
    
    NSString *topStr, *bottomStr;
    if (topNum == 0) {
        topStr = @"";
    } else {
        topStr = [NSString stringWithFormat:@"%i", topNum];
    }
    if (bottomNum == 0) {
        bottomStr = @"";
    } else {
        bottomStr = [NSString stringWithFormat:@"%i", bottomNum];
    }
    [topLabel setString:topStr];
    [bottomLabel setString:bottomStr];
}

@end
