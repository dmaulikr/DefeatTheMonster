//
//  AnimationMaker.h
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright (c) 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AnimationMaker : NSObject
//duyanguai_run_huang_0001.png 1-7
//行走动画
+ (CCAnimation *)moveAnimationWithName:(NSString *)name
                            frameCount:(int)frameCount
                                 delay:(float)delay;
//攻击动画
+ (CCAnimation *)attackAnimation:(NSString *)name
                      frameCount:(int)frameCount
                           delay:(float)delay;
//死亡动画
+ (CCAnimation *)deadAnimation:(NSString *)name
                    frameCount:(int)frameCount
                         delay:(float)delay;
//
+ (CCAnimation *)animationWithFile:(NSString *)name
                        frameCount:(int)frameCount
                             delay:(float)delay;
+ (CCAnimation *)animationWithFrame:(NSString *)frame
                         frameCount:(int)frameCount
                              delay:(float)delay;


@end
