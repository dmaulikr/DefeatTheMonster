//
//  GameLayer.h
//  DefeatTheMonster
//
//  Created by aatc on 10/9/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
	GameSceneNodeTagBow = 1,
	GameSceneNodeTagArrowSpriteBatch,
	GameSceneNodeTagPlayer,
	GameSceneNodeTagArrowCache,
    GameSceneNodeTagEnemyCache,
    GameSceneNodeTagMonster,
    GameSceneNodeTagRiver,
    GameSceneNodeTagWallBroken1,
    GameSceneNodeTagWallBroken2,
    GameSceneNodeTagWallMagicTowerB,//下塔
    GameSceneNodeTagWallMagicTowerT//上塔
} GameSceneNodeTags;

@class ArrowCache;
@class EnemyCache;
@class Player;
@class Bow;
@interface GameLayer : CCLayer
{
    Bow *_bow;
    Player *player;
    
    CCLabelAtlas *coin_label;
    CCLabelAtlas *magicStone_label;
    CCLabelAtlas *grade_label;
    CCLabelAtlas *hp_label;
    CCLabelAtlas *mp_label;
    
    CCProgressTimer *hp_progressTimer;
    CCProgressTimer *mp_progressTimer;
    
    int _grade;
    
    BOOL boosAppear;
    
    ccTime nextAddMpTime;
}

@property (nonatomic, retain) Bow *bow;
@property (nonatomic, assign)  int grade;
@property (readonly) ArrowCache *arrowCache;
@property (readonly) EnemyCache *enemyCache;

@property (readonly) Player *player;

+ (GameLayer *)shareGameLayer;

@end
