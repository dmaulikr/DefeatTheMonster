//
//  Boos.h
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright (c) 2013 nchu. All rights reserved.
//

#import "EnemyBase.h"

@interface Boos : EnemyBase
{
    BOOL isBeHurt;
    ccTime userSkillInterval;
    ccTime nextSkill;
    BOOL isUsingSkill;
}

+ (id)boosWithSpriteFrameName:(NSString *)spriteFrameName;

@end
