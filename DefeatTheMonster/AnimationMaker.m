//
//  AnimationMaker.m
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright (c) 2013 nchu. All rights reserved.
//

#import "AnimationMaker.h"

@implementation AnimationMaker
//duyanguai_run_huang_0001.png
+ (CCAnimation *)moveAnimationWithName:(NSString *)name
                            frameCount:(int)frameCount
                                 delay:(float)delay
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:frameCount];
    for (int i = 1; i <= frameCount; i++) {
        NSString *fileName;
        if (i < 10) {
            fileName = [NSString stringWithFormat:@"%@_000%i.png", name, i];
        } else {
            fileName = [NSString stringWithFormat:@"%@_00%i.png", name, i];
        }
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileName];
        [frames addObject:frame];
    }
    
    return [CCAnimation animationWithSpriteFrames:frames delay:delay];
}

+ (CCAnimation *)attackAnimation:(NSString *)name
                      frameCount:(int)frameCount
                           delay:(float)delay
{
    return nil;
    
}

+ (CCAnimation *)deadAnimation:(NSString *)name
                    frameCount:(int)frameCount
                         delay:(float)delay
{
    return nil;
}

+ (CCAnimation *)animationWithFile:(NSString *)name frameCount:(int)frameCount delay:(float)delay
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:frameCount];
    for (int i = 0; i < frameCount; i++) {
        NSString *file = [NSString stringWithFormat:@"%@%i.png", name, i];
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:file];
        CGSize texSize = texture.contentSize;
        CGRect texRect = CGRectMake(0, 0, texSize.width, texSize.height);
        
        CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rect:texRect];
        [frames addObject:frame];
    }
    
    return [CCAnimation animationWithSpriteFrames:frames delay:delay];
}

+ (CCAnimation *)animationWithFrame:(NSString *)frame frameCount:(int)frameCount delay:(float)delay
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:frameCount];
    for (int i = 1; i <= frameCount; i++) {
        NSString *file = [NSString stringWithFormat:@"%@%i.png", frame, i];
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
        [frames addObject:frame];
    }
    
    return [CCAnimation animationWithSpriteFrames:frames delay:delay];
}

@end
