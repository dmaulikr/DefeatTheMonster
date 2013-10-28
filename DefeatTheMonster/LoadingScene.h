//
//  LoadingScene.h
//  3213
//
//  Created by aatc on 9/4/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LoadingScene : CCLayer
{
    BOOL _finishedSigle;
}

@property (nonatomic, retain) CCScene *targetScene;

+(CCScene *) sceneWithTargetScene:(CCScene *)targetScene;
-(id) initWithTargetScene:(CCScene *)targetScene;

@end
