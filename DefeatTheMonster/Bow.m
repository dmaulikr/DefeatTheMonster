//
//  Bow.m
//  DefeatTheMonster
//
//  Created by aatc on 10/9/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "Bow.h"


@implementation Bow

@synthesize level = _level;
@synthesize agility = _agility, strength = _strength;
@synthesize deadlyAtk = _deadlyAtk, multipleArrow = _multipleArrow, powerAtk = _powerAtk;
@synthesize bowName = _bowName, bowSprite = _bowSprite;

+ (id)bowWithType:(BowType)type bowLvl:(int)level
{
    return [[[self alloc] initWithType:type bowLvl:level] autorelease];
}

- (id)initWithType:(BowType)type bowLvl:(int)level
{
    if ( self = [super init] ) {
        
        switch (type) {
            case kBowTypeNormal:
                _bowName = @"normal";
                _level = 1;
                _bowSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"bow_%@.png", _bowName]];
                _strength = 0;
                _agility = 0;
                _powerAtk = 0;
                _deadlyAtk = 0;
                _multipleArrow = 0;
                break;
            case kBowTypePow://火山
                _bowName = @"pow";
                _level = level;
                _bowSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"bow_%@_0%d.png", _bowName, level]];
                _strength = level;
                _agility = 0;
                if ( level >= 3 && level <= 5) {
                    _powerAtk = 1;
                } else if ( level >= 6 && level <= 8 ) {
                    _powerAtk = 2;
                } else if (level == 9) {
                    _powerAtk = 3;
                } else {
                    _powerAtk = 0;
                }
                _deadlyAtk = 0;
                _multipleArrow = 0;
                break;
            case kBowTypeAgi://幽灵
                _bowName = @"agi";
                _level = level;
                _bowSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"bow_%@_0%d.png", _bowName, level]];
                switch (level) {
                    case 1:
                        _strength = 2;
                        _agility = 1;
                        _powerAtk = 0;
                        _deadlyAtk = 0;
                        _multipleArrow = 0;
                        break;
                    case 2:
                        _strength = 3;
                        _agility = 2;
                        _powerAtk = 0;
                        _deadlyAtk = 1;
                        _multipleArrow = 0;
                        break;
                    case 3:
                        _strength = 4;
                        _agility = 3;
                        _powerAtk = 1;
                        _deadlyAtk = 1;
                        _multipleArrow = 0;
                        break;
                    case 4:
                        _strength = 5;
                        _agility = 4;
                        _powerAtk = 1;
                        _deadlyAtk = 2;
                        _multipleArrow = 0;
                        break;
                    case 5:
                        _strength = 6;
                        _agility = 5;
                        _powerAtk = 1;
                        _deadlyAtk = 2;
                        _multipleArrow = 1;
                        break;
                    case 6:
                        _strength = 7;
                        _agility = 6;
                        _powerAtk = 2;
                        _deadlyAtk = 2;
                        _multipleArrow = 1;
                        break;
                    case 7:
                        _strength = 8;
                        _agility = 6;
                        _powerAtk = 2;
                        _deadlyAtk = 3;
                        _multipleArrow = 2;
                        break;
                    case 8:
                        _strength = 9;
                        _agility = 7;
                        _powerAtk = 3;
                        _deadlyAtk = 3;
                        _multipleArrow = 2;
                        break;
                    case 9:
                        _strength = 9;
                        _agility = 8;
                        _powerAtk = 3;
                        _deadlyAtk = 4;
                        _multipleArrow = 3;
                        break;
                    default:
                        NSLog(@"level shoul between 1-9");
                        break;
                }
                break;
            case kBowTypeMul://飓风
                _bowName = @"mul";
                _level = level;
                _bowSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"bow_%@_0%d.png", _bowName, level]];
                switch (level) {
                    case 1:
                        _strength = 1;
                        _agility = 1;
                        _powerAtk = 0;
                        _deadlyAtk = 0;
                        _multipleArrow = 0;
                        break;
                    case 2:
                        _strength = 2;
                        _agility = 2;
                        _powerAtk = 0;
                        _deadlyAtk = 0;
                        _multipleArrow = 0;
                        break;
                    case 3:
                        _strength = 3;
                        _agility = 2;
                        _powerAtk = 0;
                        _deadlyAtk = 1;
                        _multipleArrow = 0;
                        break;
                    case 4:
                        _strength = 4;
                        _agility = 3;
                        _powerAtk = 0;
                        _deadlyAtk = 1;
                        _multipleArrow = 0;
                        break;
                    case 5:
                        _strength = 4;
                        _agility = 4;
                        _powerAtk = 0;
                        _deadlyAtk = 2;
                        _multipleArrow = 0;
                        break;
                    case 6:
                        _strength = 5;
                        _agility = 5;
                        _powerAtk = 0;
                        _deadlyAtk = 2;
                        _multipleArrow = 0;
                        break;
                    case 7:
                        _strength = 6;
                        _agility = 5;
                        _powerAtk = 0;
                        _deadlyAtk = 3;
                        _multipleArrow = 0;
                        break;
                    case 8:
                        _strength = 7;
                        _agility = 6;
                        _powerAtk = 0;
                        _deadlyAtk = 3;
                        _multipleArrow = 0;
                        break;
                    case 9:
                        _strength = 8;
                        _agility = 6;
                        _powerAtk = 0;
                        _deadlyAtk = 4;
                        _multipleArrow = 0;
                        break;
                    default:
                        NSLog(@"level shoul between 1-9");
                        break;
                }
                break;
            case kBowTypeFinal:
                _bowName = @"final";
                _bowSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"bow_%@.png", _bowName]];
                _level = level;
                _strength = 14;
                _agility = 14;
                _powerAtk = 5;
                _deadlyAtk = 5;
                _multipleArrow = 5;
                break;
            default:
                break;
        }

        [self addChild:_bowSprite];
    }
    
    return self;
}

- (void)dealloc
{
    [_bowName release];
    _bowName = nil;
    
    [super dealloc];
}


@end
