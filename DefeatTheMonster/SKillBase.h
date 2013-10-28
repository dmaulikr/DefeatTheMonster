//
//  SKillBase.h
//  DefeatTheMonster
//
//  Created by aatc on 10/14/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
/*
 基础技能：魔力研究 冰霜魔法1阶，火球魔法1阶，闪电魔法1阶
                 冰霜魔法2阶，火球魔法2阶，闪电魔法2阶
                 冰霜魔法3阶，火球魔法3阶，闪电魔法3阶
 kSkillTypeIce_One,      //冰霜魔法1阶
 kSkillTypeIce_Two,      //冰霜魔法2阶
 kSkillTypeIce_Three,      //冰霜魔法3阶
 kSkillTypeFire_One,     //火球魔法1阶
 kSkillTypeFire_Two,     //火球魔法2阶
 kSkillTypeFire_Three,     //火球魔法3阶
 kSkillTypeLight_One,    //闪电魔法1阶
 kSkillTypeLight_Two,     //闪电魔法2阶
 kSkillTypeLight_Three,     //闪电魔法3阶
 
 */
typedef enum{
    kSkillTypeLocked = 0, //锁定
    kSkillTypeIce_One,      //冰霜魔法1阶
    kSkillTypeIce_Two,      //冰霜魔法2阶
    kSkillTypeIce_Three,      //冰霜魔法3阶
    kSkillTypeFire_One,     //火球魔法1阶
    kSkillTypeFire_Two,     //火球魔法2阶
    kSkillTypeFire_Three,     //火球魔法3阶
    kSkillTypeLight_One,    //闪电魔法1阶
    kSkillTypeLight_Two,     //闪电魔法2阶
    kSkillTypeLight_Three,     //闪电魔法3阶
}SkillType;

@interface SKillBase : CCSprite
{
    CCProgressTimer *progressTimer;//进度条
    CCSprite *manabg;//法力不足提示半透明
    CCSprite *lackManaInfo;//法力不足提示
    CCSprite *manaFlash;//技能刷新
    
    int _costMp;//消耗蓝量
    int _lvl;//技能等级
    BOOL _isManaEnough;
    BOOL _isEnabled;
    ccTime _coolDownInterval;//技能cd
    ccTime _nextTime;
    ccTime _totalTime;
    
    SkillType _type;
}

@property (nonatomic, readonly) SkillType type;
@property (nonatomic, assign) BOOL isManaEnough;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) int costMp;

+ (id)skillWithType:(SkillType)skillType
              level:(int)level
           fileName:(NSString *)fileName;

- (id)initWithType:(SkillType)skillType
             level:(int)level
          fileName:(NSString *)fileName;

@end
