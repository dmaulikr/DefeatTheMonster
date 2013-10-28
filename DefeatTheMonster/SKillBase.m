//
//  SKillBase.m
//  DefeatTheMonster
//
//  Created by aatc on 10/14/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "SKillBase.h"
#import "GameLayer.h"
#import "Player.h"

@implementation SKillBase

@synthesize isEnabled = _isEnabled;
@synthesize isManaEnough = _isManaEnough;
@synthesize costMp = _costMp;

+ (id)skillWithType:(SkillType)skillType
              level:(int)level
           fileName:(NSString *)fileName
{
    return [[[self alloc] initWithType:skillType
                                level:level
                             fileName:fileName] autorelease];
}

- (id)initWithType:(SkillType)skillType
             level:(int)level
          fileName:(NSString *)fileName
{
    if ( self = [super initWithFile:fileName]) {
        
        switch (skillType) {
            case kSkillTypeLocked:
                _costMp = 0;
                break;
            case kSkillTypeFire_One:
            case kSkillTypeIce_One:
            case kSkillTypeLight_One:
                _costMp = 35;
                break;
            case kSkillTypeFire_Two:
            case kSkillTypeIce_Two:
            case kSkillTypeLight_Two:
                _costMp = 65;
                break;
            case kSkillTypeFire_Three:
            case kSkillTypeIce_Three:
            case kSkillTypeLight_Three:
                _costMp = 125;
                break;
            default:
                break;
        }
        _lvl = level;
        
        _totalTime = 10;
        _coolDownInterval = 8;
        _nextTime = _totalTime + _coolDownInterval;
        
        _isEnabled = NO;
        _isManaEnough = YES;
        
        if (skillType == kSkillTypeLocked) {
            return self;
        }
        
        progressTimer = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"magic_cd.png"]];
        progressTimer.percentage = 0;
        progressTimer.type = kCCProgressTimerTypeRadial;
        progressTimer.barChangeRate = ccp(0, 1);
        progressTimer.midpoint = ccp(0.5, 0.5);
        [self addChild:progressTimer z:3];
        
        progressTimer.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        
        manabg = [CCSprite spriteWithFile:@"magic_button_lowmana_bg.png"];//法力不足提示半透明
        manabg.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:manabg z:2];
        manabg.visible = NO;
        
        manaFlash = [CCSprite spriteWithFile:@"magic_button_flash.png"];//
        manaFlash.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        manaFlash.visible = NO;
        [self addChild:manaFlash z:1];
        
        lackManaInfo = [CCSprite spriteWithFile:@"magic_button_lowmana_word.png"];
        [self addChild:lackManaInfo z:4];
        lackManaInfo.visible = NO;
        lackManaInfo.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        CCTintTo *tintTo = [CCTintTo actionWithDuration:0.8 red:158 green:11 blue:15];
        CCReverseTime *reTint = [CCReverseTime actionWithAction:tintTo];
        [lackManaInfo runAction:[CCRepeatForever actionWithAction:reTint]];
        
        CCFadeTo *a = [CCFadeTo actionWithDuration:1 opacity:255/2];
        CCFadeTo *re = [CCFadeTo actionWithDuration:0.5 opacity:255];
        CCSequence *seq = [CCSequence actions:a, re, nil];
        [manaFlash runAction:[CCRepeatForever actionWithAction:seq]];
        [self scheduleUpdate];
    }
    
    return self;
}

- (SkillType)type
{
    return _type;
}

- (void)showProgressTimer
{
    
    progressTimer.visible = YES;
}

- (void)update:(ccTime)delta
{
    Player *player = [GameLayer shareGameLayer].player;
    
    if (player.MP < _costMp) {
        _isManaEnough = NO;
    } else {
        _isManaEnough = YES;
    }
    
    if ( ! _isManaEnough ) {
        manabg.visible = YES;
        lackManaInfo.visible = YES;
    } else {
        manabg.visible = NO;
        lackManaInfo.visible = NO;
    }
    
    if ( ! _isEnabled ) {
        manaFlash.visible = NO;
        _totalTime += delta;
        progressTimer.percentage += 100 / _nextTime * delta;
        if ( _totalTime > _nextTime) {
            progressTimer.percentage = 0;
            _isEnabled = YES;
            _nextTime = _totalTime + _coolDownInterval;
        }
    } else {
        manaFlash.visible = YES;
        _totalTime = 0;
        _nextTime = _totalTime + _coolDownInterval;
    }
}

@end
