//
//  EmenyCache.h
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright 2013 nchu. All rights reserved.
//

/*
    怪物制造策略：
 
 
 */

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EnemyCache : CCNode
{
    NSMutableArray *_enemys;//场上怪物数
    
    int _currentWave;       //当前怪物是第几波
    
    int _grade;             //当前关卡
    int maxEnemysNum;        //最大怪物数
    
    int duyanguai_count;    //独眼怪个数
    int manzutu_count;      //
    int quanjiniao_count;   //
    int xiaoemo_count;      //
    int toushiche_count;    //
    
    int _wave;
    
    ccTime waveInterval;    //每波怪物刷新间隔时间
    ccTime totalTime;       //总时间
	ccTime nextWaveTime;    //下一波怪物出现时间 = 总时间 + 每波怪物刷新间隔时间
}

@property (nonatomic, retain) NSMutableArray *enemys;
@property (nonatomic, assign) int wave;
@property (nonatomic, assign) int maxEnemysNum;

+ (id)enemyWithMaxEnemys:(int)num grade:(int)grade;
- (id)initWithMaxEnemys:(int)num grade:(int)grade;

- (void)createEnemyWithGrade:(int)grade;


@end
