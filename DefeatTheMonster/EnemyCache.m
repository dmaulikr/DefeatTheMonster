//
//  EmenyCache.m
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "EnemyCache.h"
#import "EnemyBase.h"

#import "GameLayer.h"
#import "Player.h"
#import "ArrowCache.h"
#import "Boos.h"

@implementation EnemyCache

@synthesize enemys = _enemys, wave = _wave, maxEnemysNum;

+ (id)enemyWithMaxEnemys:(int)num grade:(int)grade
{
    return [[[self alloc] initWithMaxEnemys:num grade:grade] autorelease];
}

- (id)initWithMaxEnemys:(int)num grade:(int)grade
{
    if ( self = [super init] ) {
        
        _currentWave = 1;
        waveInterval = 10.0f;
        _enemys = [[NSMutableArray alloc] init];
        _wave = 1;
        _grade = grade;
        maxEnemysNum = 25 + grade;
        
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)addEnemysByGrade:(int)grade
{
    if (_wave > 10) {
        return;
    }
    int row = 0;
    int num = 0;
    int column = 0;
    switch (_wave) {
        case 1:
            num = maxEnemysNum / 20;
            row = (grade / 30) + 1;
            [self createEnemyWithGrade:grade];
            _wave++;
            return;
            break;
        case 2:
        case 3:
            num = maxEnemysNum / 20;
            row = (grade / 30) + 1;
            break;
        case 4:
        case 5:
            num = maxEnemysNum / 15;
            row = (grade / 30) + 1 + arc4random() % 2;
            break;
        case 6:
        case 7:
        case 8:
            num = maxEnemysNum / 15;
            row = (grade / 30) + 1 + arc4random() % 3;
            break;
        case 9:
            num = maxEnemysNum / 15;
            row = (grade / 30) + 1 + arc4random() % 3;
            break;
        case 10:
            num = maxEnemysNum / 10;
            row = (grade / 30) + 2 + arc4random() % 3;
            if (grade % 10 == 0) {
                if (grade <= 40) {
                    Boos *boos = [Boos boosWithSpriteFrameName:@"emolingzhu_run_0001.png"];
                    [_enemys addObject:boos];
                    [self addChild:boos];
                    
                    float x = 480 + arc4random() % 240 + boos.contentSize.width / 2 + 480;
                    float y = 35 * (arc4random() % 7 + 1);
                    boos.position = ccp(x, y);
        
                    [boos run];
                } else if (grade <= 100) {
                    for (int i = 0; i < 2; i++) {
                        Boos *boos = [Boos boosWithSpriteFrameName:@"emolingzhu_run_0001.png"];
                        [_enemys addObject:boos];
                        [self addChild:boos];
                        
                        float x = 480 + arc4random() % 240 + boos.contentSize.width / 2 + 480;
                        float y = 35 * (arc4random() % 7 + 1);
                        boos.position = ccp(x, y);
                        
                        [boos run];
                    }
                } else {
                    for (int i = 0; i < 3; i++) {
                        Boos *boos = [Boos boosWithSpriteFrameName:@"emolingzhu_run_0001.png"];
                        [_enemys addObject:boos];
                        [self addChild:boos];
                        
                        float x = 480 + arc4random() % 240 + boos.contentSize.width / 2 + 480;
                        float y = 35 * (arc4random() % 7 + 1);
                        boos.position = ccp(x, y);
                        [boos run];
                    }
                }
            }
            break;
        default:
            num = 0;
            row = 0;
            break;
    }
    EnemyType type;
    int rand = arc4random() % 100;
    if (grade <= 10) {
        if (rand <= 60) {
            type = EnemyTypeQuanjiniao;
        } else {
            type = EnemyTypeManzutu;
        }
    } else if (grade > 10 && grade <= 20){
        if (rand <= 40) {
            type = EnemyTypeQuanjiniao;
        } else if (40 < rand && rand <= 70) {
            type = EnemyTypeDuyanguai;
        } else {
            type = EnemyTypeManzutu;
        }
    } else if (grade > 20){
        if (rand <= 15) {
            type = EnemyTypeQuanjiniao;
        } else if (15 < rand && rand <= 40) {
            type = EnemyTypeXiaoemo;
        } else if (40 < rand && rand <= 70) {
            type = EnemyTypeDuyanguai;
        } else {
            type = EnemyTypeManzutu;
        }
    }
    int rand1 = arc4random() % 10;
    if (rand1 >= 4) {
        [self createEnemyRowJX:row nums:num enemyType:type];
    } else {
        if (row == 0) {
            row = 1;
        }
        column = num / row;
        if (column == 0) {
            column = 1;
        }
        if (grade >= 80) {
            [self createEnemyWithGrade:grade];
        }
        [self createEnemyColumnLX:column row:row enemyType:type];
    }
    //大于50关之后，5到10波都有几率在最后出投石车
    _wave++;
    
    if (grade <= 50) {
        return;
    }
    int numOfToushiche = 1;//每100关＋1
    BOOL isCreatTSC = NO;
    int rTSC = arc4random() % 100;
    if (rTSC <= (50 + grade / 10 + _wave * 2)) {
        isCreatTSC = YES;
    }
    if (isCreatTSC) {
        if (_wave == 6) {
            numOfToushiche = numOfToushiche + arc4random() % (grade / 100 + 1);
        } else if (_wave == 8) {
            numOfToushiche = numOfToushiche + arc4random() % (grade / 100 + 1);
        } else if (_wave == 9) {
            numOfToushiche = numOfToushiche + arc4random() % (grade / 100 + 1) + 1;
        } else {
            numOfToushiche = numOfToushiche + arc4random() % (grade / 100 + 1) + 1;
        }
        for (int i = 0; i < numOfToushiche; i++) {
            //320 / 9
            EnemyBase *toushiche = [EnemyBase enemyWithType:EnemyTypeToushiche];
            
            int x = 480 + toushiche.getRect.size.width * column;
            int y = 180 - 35 * (i - numOfToushiche / 2) - toushiche.getRect.size.height / 2;
            
            toushiche.position = ccp(x, y);
            [_enemys addObject:toushiche];
            [self addChild:toushiche];
        }
    }
}

//随即出怪
- (void)createEnemyWithGrade:(int)grade
{
    int nums = 1 + (arc4random() % 3) + grade / 10;
    int rand = 0;
    EnemyBase *enemy;
    EnemyType type;
    rand = arc4random() % 5;
    switch (rand) {
        case 0:
            type = EnemyTypeQuanjiniao;
            break;
        case 1:
            if (grade >= 10) {
                type = EnemyTypeDuyanguai;
            } else {
                type = EnemyTypeQuanjiniao;
            }
            break;
        case 2:
            type = EnemyTypeManzutu;
            break;
        case 3:
            if (grade >= 20) {
                type = EnemyTypeXiaoemo;
            } else {
                type = EnemyTypeManzutu;
            }
            break;
        case 4:
            if (grade >= 50) {
                int r = arc4random() % 2;
                if (r==1) {
                    type = EnemyTypeToushiche;
                } else {
                    type = EnemyTypeDuyanguai;
                }
            } else {
                type = EnemyTypeQuanjiniao;
            }
            break;
        default:
            type = EnemyTypeManzutu;
            break;
    }
    if ((arc4random() % 4) == 1) {
        [self createEnemyRowJX:nums nums:nums enemyType:type];
    } else if (arc4random() % 4 == 2) {
        [self createEnemyRowJX:1 nums:nums enemyType:type];
    } else {
        for (int i = 0; i < nums; i++) {
            rand = arc4random() % 5;
            switch (rand) {
                case 0:
                    type = EnemyTypeQuanjiniao;
                    break;
                case 1:
                    if (grade >= 10) {
                        type = EnemyTypeDuyanguai;
                    } else {
                        type = EnemyTypeQuanjiniao;
                    }
                    break;
                case 2:
                    type = EnemyTypeManzutu;
                    break;
                case 3:
                    if (grade >= 20) {
                        type = EnemyTypeXiaoemo;
                    } else {
                        type = EnemyTypeManzutu;
                    }
                    break;
                case 4:
                    if (grade >= 50) {
                        int r = arc4random() % 2;
                        if (r==1) {
                            type = EnemyTypeToushiche;
                        } else {
                            type = EnemyTypeDuyanguai;
                        }
                    } else {
                        type = EnemyTypeQuanjiniao;
                    }
                    break;
                default:
                    type = EnemyTypeManzutu;
                    break;
            }
            enemy = [EnemyBase enemyWithType:type];
            float x = 480 + arc4random() % 240 + enemy.contentSize.width / 2;
            float y = 35 * (arc4random() % 7 + 1);
            enemy.position = ccp(x, y);
            [_enemys addObject:enemy];
            [self addChild:enemy];
        }

    }
}
//矩形阵型
- (void)createEnemyRowJX:(int)row nums:(int)num enemyType:(EnemyType)enemyType
{
    EnemyBase *enemy;
    int column = (int)ceilf(num / (float)row);
    int firstNum = row * (column - 1);
    int lastNum = num - (row * (column - 1));
    for (int i = 0; i < firstNum; i++) {
        //320 / 9
        enemy = [EnemyBase enemyWithType:enemyType];

        int x = 480 + enemy.getRect.size.width * (i / row);
        int y = 180 - 35 * (i - row / 2) - enemy.getRect.size.height / 2;
        
        enemy.position = ccp(x, y);
        [_enemys addObject:enemy];
        [self addChild:enemy];
    }
    
    for (int i = 0; i < lastNum; i++) {
        //320 / 9
        enemy = [EnemyBase enemyWithType:enemyType];
        
        int x = 480 + enemy.getRect.size.width * (column - 1);
        int y = 180 - 35 * (i - lastNum / 2) - enemy.getRect.size.height / 2;
        
        enemy.position = ccp(x, y);
        [_enemys addObject:enemy];
        [self addChild:enemy];
    }
    
}
//菱形阵型
- (void)createEnemyColumnLX:(int)column row:(int)row enemyType:(EnemyType)enemyType
{
    EnemyBase *enemy;

    for (int i = 0; i < column; i++) {
        for (int j = 0; j < row; j++) {
            enemy = [EnemyBase enemyWithType:enemyType];
            
            float x = 480 + enemy.getRect.size.width * i + abs(j - row / 2) * 20;

            float y = 180 - 35 * (j - row / 2) - enemy.getRect.size.height / 2;

            enemy.position = ccp(x, y);
            [_enemys addObject:enemy];
            [self addChild:enemy];
        }
    }
}

- (void)update:(ccTime)delta
{
    totalTime += delta;
    if (totalTime > nextWaveTime) {//到达刷新怪物时间
        totalTime = 0;
        nextWaveTime = totalTime + waveInterval;
        [self addEnemysByGrade:_grade];
    }
    
    [self checkForArrowCollisions];
}

-(void) checkForArrowCollisions
{
    for (EnemyBase *enemy in _enemys)
    {
        if (enemy.isLive)
        {
            ArrowCache *arrowCache = [GameLayer shareGameLayer].arrowCache;
            CGRect bbox = enemy.getRect;
                
            if ([arrowCache isArrowsCollidingWithRect:bbox])
            {
                // This enemy got hit ...
                [enemy gotHit];
            }
        }
    }
}

- (void)dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [_enemys release];
    _enemys = nil;
    [super dealloc];
}

@end
