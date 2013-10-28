//
//  StatsLayer.h
//  DefeatTheMonster
//
//  Created by 彭生辉 on 13-10-15.
//  Copyright 2013年 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface StatsLayer : CCLayer
{
    int _warType;//战斗类型0.代表本地；1.代表对战
    int _isWin;//是否胜利；0代表胜利，2代表失败
    int _maxEXP;//当前等级经验
    int _getEXP;//本关获得经验
    int _upEXP;//升下级所需经验
    int _upNextEXP;//升下下级所需的经验
    int _currentEXP;//变化的经验值
    
    CCLabelTTF *_exLabel;//经验值
}

+ (id)sceneWithFlag:(BOOL)isWin;

@end
