//
//  ControlLayer.m
//  DefeatTheMonster
//
//  Created by aatc on 10/9/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "ControlLayer.h"
#import "GameLayer.h"

#import "Bow.h"
#import "Player.h"
#import "EnemyBase.h"
#import "SKillBase.h"
#import "GameData.h"

#import "PauseLayer.h"

#import "ArrowCache.h"
#import "EnemyCache.h"

#import "AnimationMaker.h"
#import "SimpleAudioEngine.h"

#define WINDOWHEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation ControlLayer

- (id)init
{
    if (self = [super init]) {
        isTouching = NO;
        self.touchEnabled = YES;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        GameData *gameData = [GameData shareGameDataInstance];
        Player *player = [GameLayer shareGameLayer].player;
        SkillType first, second, third;
        int firstLvl, secondLvl, thirdLvl;
        NSString *first_name, *second_name, *third_name;
        third_name = [NSString stringWithFormat:@"magic_button_elect%d.png", player.firstSkillType];
        second_name = [NSString stringWithFormat:@"magic_button_ice%d.png", player.firstSkillType];
        first_name = [NSString stringWithFormat:@"magic_button_fire%d.png", player.firstSkillType];
        switch (player.firstSkillType) {
            case 0:
                first = kSkillTypeLocked;
                firstLvl = gameData.fireSkillOne_lvl;
                first_name = @"magic_button_lock.png";
                break;
            case 1:
                first = kSkillTypeFire_One;
                firstLvl = gameData.fireSkillOne_lvl;
                break;
            case 2:
                first = kSkillTypeFire_Two;
                firstLvl = gameData.fireSkillOne_lvl;
                break;
            case 3:
                first = kSkillTypeFire_Three;
                firstLvl = gameData.fireSkillOne_lvl;
                break;
            default:
                first = kSkillTypeFire_One;
                firstLvl = 1;
                first_name = @"magic_button_lock.png";
                break;
        }
        
        switch (player.secondSkillType) {
            case 0:
                second = kSkillTypeLocked;
                secondLvl = gameData.iceSkillOne_lvl;
                second_name = @"magic_button_lock.png";
                break;
            case 1:
                second = kSkillTypeIce_One;
                secondLvl = gameData.iceSkillOne_lvl;
                break;
            case 2:
                second = kSkillTypeIce_Two;
                secondLvl = gameData.iceSkillTwo_lvl;
                break;
            case 3:
                second = kSkillTypeIce_Three;
                secondLvl = gameData.iceSkillThree_lvl;
                break;
            default:
                second = kSkillTypeLocked;
                secondLvl = 0;
                second_name = @"magic_button_lock.png";
                break;
        }
        
        switch (player.thirdSkillType) {
            case 0:
                third = kSkillTypeLocked;
                thirdLvl = gameData.lightSkillOne_lvl;
                third_name = @"magic_button_lock.png";
                break;
            case 1:
                third = kSkillTypeLight_One;
                thirdLvl = gameData.lightSkillOne_lvl;
                break;
            case 2:
                third = kSkillTypeLight_Two;
                thirdLvl = gameData.lightSkillTwo_lvl;
                break;
            case 3:
                third = kSkillTypeLight_Three;
                thirdLvl = gameData.lightSkillThree_lvl;
                break;
            default:
                third = kSkillTypeLocked;
                thirdLvl = 0;
                third_name = @"magic_button_lock.png";
                break;
        }
        
        SKillBase *light_skill = [SKillBase skillWithType:third
                                                    level:thirdLvl
                                                 fileName:third_name];
        [self addChild:light_skill z:5 tag:kContorlLayerNodeTagLightSkill];
        light_skill.position = ccp(size.width - light_skill.contentSize.width/2 - 10, light_skill.contentSize.height/2);
        
        SKillBase *ice_skill = [SKillBase skillWithType:second
                                                  level:secondLvl
                                               fileName:second_name];
        [self addChild:ice_skill z:5 tag:kContorlLayerNodeTagIceSkill];
        ice_skill.position = ccp(light_skill.position.x - light_skill.contentSize.width - 10, light_skill.contentSize.height/2);
        
        SKillBase *fire_skill = [SKillBase skillWithType:first
                                                   level:firstLvl
                                                fileName:first_name];
        [self addChild:fire_skill z:5 tag:kContorlLayerNodeTagFireSkill];
        fire_skill.position = ccp(ice_skill.position.x - ice_skill.contentSize.width - 10, light_skill.contentSize.height/2);
        
        flag = 0;
        
        CCMenuItemImage *stop_item = [CCMenuItemImage itemWithNormalImage:@"pause_button.png"
                                                            selectedImage:nil
                                                                    block:^(id sender) {
                                                                        [[CCDirector sharedDirector] pause];
                                                                        PauseLayer *pause = [PauseLayer node];
                                                                        [self addChild:pause];
                                                                        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
                                                                    }];
        CCMenu *stop_menu = [CCMenu menuWithItems:stop_item, nil];
        [self addChild:stop_menu];
        stop_menu.position = ccp(30, 300);
        
        CCMenuItemImage *add_item = [CCMenuItemImage itemWithNormalImage:@"button_addmana.png"
                                                            selectedImage:nil
                                                                    block:^(id sender) {
                                                                        if (gameData.magicStone >= 1) {
                                                                            gameData.magicStone--;
                                                                            player.MP += 60;
                                                                            [gameData save];
                                                                            CCSprite *s = [CCSprite spriteWithFile:@"zz_mana_1.png"];
                                                                            CCMoveBy *by = [CCMoveBy actionWithDuration:0.3 position:ccp(s.position.x, 10)];
                                                                            CCCallBlock *miss = [CCCallBlock actionWithBlock:^{
                                                                                [s removeFromParentAndCleanup:YES];
                                                                            }];
                                                                            CCSequence *seq = [CCSequence actions:[CCFadeIn actionWithDuration:0.2], by, [CCFadeOut actionWithDuration:0.3], miss, nil];
                                                                            [s runAction:seq];
                                                                            [self addChild:s];
                                                                            s.position = ccp(size.width/2 - 80, size.height/2 + 145);
                                                                        }
                                                                    }];
        CCMenu *add_menu = [CCMenu menuWithItems:add_item, nil];
        [self addChild:add_menu z:30 tag:kContorlLayerNodeTagAddMana];
        add_menu.visible = NO;
        add_menu.position = ccp(22, 22);
        
        CCTintTo *tintTo = [CCTintTo actionWithDuration:0.8 red:158 green:11 blue:15];
        CCReverseTime *reTint = [CCReverseTime actionWithAction:tintTo];
        [add_menu runAction:[CCRepeatForever actionWithAction:reTint]];
        
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)onHonor
{
    NSLog(@"touch");
}

#pragma mark - touchDispatcher
- (void)registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:NO];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    SKillBase *fire_skill = (SKillBase *)[self getChildByTag:kContorlLayerNodeTagFireSkill];
    if (fire_skill.isEnabled && fire_skill.isManaEnough) {
        if ( CGRectContainsPoint(fire_skill.boundingBox, touchLocation) ) {
            isUsingSkill = YES;
            flag = 2;
            CCSprite *magicRing = [CCSprite spriteWithSpriteFrameName:@"magic_ring.png"];
            [self addChild:magicRing z:4 tag:kContorlLayerNodeTagMagicRing];
            magicRing.position = fire_skill.position;
            flag = 1;
            return YES;
        }
    }
    
    SKillBase *ice_skill = (SKillBase *)[self getChildByTag:kContorlLayerNodeTagIceSkill];
    if (ice_skill.isEnabled && ice_skill.isManaEnough) {
        if ( CGRectContainsPoint(ice_skill.boundingBox, touchLocation) ) {
            isUsingSkill = YES;
            flag = 2;
            CCSprite *magicRing = [CCSprite spriteWithSpriteFrameName:@"magic_ring.png"];
            [self addChild:magicRing z:4 tag:kContorlLayerNodeTagMagicRing];
            magicRing.position = ice_skill.position;
            flag = 2;
            return YES;
        }
    }
    
    SKillBase *light_skill = (SKillBase *)[self getChildByTag:kContorlLayerNodeTagLightSkill];
    if (light_skill.isEnabled && light_skill.isManaEnough) {
        if ( CGRectContainsPoint(light_skill.boundingBox, touchLocation) ) {
            isUsingSkill = YES;
            flag = 2;
            CCSprite *magicRing = [CCSprite spriteWithSpriteFrameName:@"magic_ring.png"];
            [self addChild:magicRing z:4 tag:kContorlLayerNodeTagMagicRing];
            magicRing.position = light_skill.position;
            flag = 3;
            return YES;
        }
    }
    
    GameLayer *gameLayer = [GameLayer shareGameLayer];
    CGFloat angle = [self setBowDirByTouch:touchLocation];
    gameLayer.bow.rotation = angle;
    
    //[self attackWithAngle:angle];
    isTouching = YES;
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];

    if (isUsingSkill) {
        CCSprite *magicRing = (CCSprite *)[self getChildByTag:kContorlLayerNodeTagMagicRing];
        magicRing.position = touchLocation;
        return;
    }
    GameLayer *gameLayer = [GameLayer shareGameLayer];
    CGFloat angle = [self setBowDirByTouch:touchLocation];
    gameLayer.bow.rotation = angle;
    
    isTouching = YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    Player *player = [GameLayer shareGameLayer].player;
    NSLog(@"%i", 1<<1);
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    isTouching = NO;
    if (isUsingSkill) {
        isUsingSkill = NO;
        CCSprite *magicRing = (CCSprite *)[self getChildByTag:kContorlLayerNodeTagMagicRing];
        //离开时落点处于技能图表点就取消施放魔法35 65 125
        if (flag == 1) {
            SKillBase *fire_skill = (SKillBase *)[self getChildByTag:kContorlLayerNodeTagFireSkill];
            if ( CGRectContainsPoint(fire_skill.boundingBox, touchLocation) ) {
                [magicRing removeFromParentAndCleanup:YES];
                flag = 0;
                return;
            } else {
                flag = 0;
                CGPoint ringPos = magicRing.position;
                [magicRing removeFromParentAndCleanup:YES];
                fire_skill.isEnabled = NO;
                [self useSkill:ringPos flag:1 skillTypeFlag:player.firstSkillType];
                player.MP -= fire_skill.costMp;
            }
        }
        if (flag == 2) {
            SKillBase *ice_skill = (SKillBase *)[self getChildByTag:kContorlLayerNodeTagIceSkill];
            if ( CGRectContainsPoint(ice_skill.boundingBox, touchLocation) ) {
                [magicRing removeFromParentAndCleanup:YES];
                flag = 0;
                return;
            } else {
                flag = 0;
                CGPoint ringPos = magicRing.position;
                [magicRing removeFromParentAndCleanup:YES];
                ice_skill.isEnabled = NO;
                [self useSkill:ringPos flag:2 skillTypeFlag:player.secondSkillType];
                player.MP -= ice_skill.costMp;
            }
        }
        if (flag == 3) {
            SKillBase *light_skill = (SKillBase *)[self getChildByTag:kContorlLayerNodeTagLightSkill];
            if ( CGRectContainsPoint(light_skill.boundingBox, touchLocation) ) {
                [magicRing removeFromParentAndCleanup:YES];
                flag = 0;
                return;
            } else {
                flag = 0;
                CGPoint ringPos = magicRing.position;
                [magicRing removeFromParentAndCleanup:YES];
                light_skill.isEnabled = NO;
                [self useSkill:ringPos flag:3 skillTypeFlag:player.thirdSkillType];
                player.MP -= light_skill.costMp;
            }
        }
    }
    
}

- (void)useSkill:(CGPoint)atPos flag:(int)flag_ skillTypeFlag:(int)skillTypeFlag
{
    switch (flag_) {
        case 1:
        {
            switch (skillTypeFlag) {
                case 1:
                {
                    [self useSkill:atPos finalPos:atPos flag:flag_ count:0];
                }
                    break;
                case 2:
                {
                    [self useSkill:atPos finalPos:atPos flag:flag_ count:4];
                }
                    break;
                case 3:
                {
                    for (int i = 0; i < 5; i++) {
                        for (int j = 0; j < 5; j++) {//173 181
                            CGPoint point = ccp(100 + i * 80, 32 + j * 64);
                            [self useSkill:point finalPos:point flag:flag_ count:0];
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (skillTypeFlag) {
                case 1:
                {
                    [self useSkill:atPos finalPos:atPos flag:flag_ count:0];
                }
                    break;
                case 2:
                {
                    [self useSkill:atPos finalPos:atPos flag:flag_ count:4];
                }
                    break;
                case 3:
                {
                    for (int i = 0; i < 5; i++) {
                        for (int j = 0; j < 5; j++) {//173 181
                            CGPoint point = ccp(100 + i * 80, 32 + j * 64);
                            [self useSkill:point finalPos:point flag:flag_ count:0];
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            switch (skillTypeFlag) {
                case 1:
                {
                    [self useSkill:atPos finalPos:atPos flag:flag_ count:0];
                }
                    break;
                case 2:
                {
                    [self useSkill:atPos finalPos:atPos flag:flag_ count:2];
                }
                    break;
                case 3:
                {
                    for (int i = 0; i < 5; i++) {
                        for (int j = 0; j < 5; j++) {//173 181
                            CGPoint point = ccp(100 + i * 80, 32 + j * 64);
                            [self useSkill:point finalPos:point flag:flag_ count:0];
                        }
                    }
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)useSkill:(CGPoint)atPos finalPos:(CGPoint)finalPos flag:(int)flag_ count:(int)count
{
    if (count < 0) {
        return;
    }
    NSLog(@"%i", count);
    switch (flag_) {
        case 1:
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"fire_1.caf"];
            CCSprite *s = [CCSprite spriteWithSpriteFrameName:@"fire_blast_03.png"];
            [self addChild:s z:4];
            s.position = ccp(finalPos.x - 100, finalPos.y + 150);
            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.3 position:finalPos];
            
            NSMutableArray *frames = [NSMutableArray arrayWithCapacity:10];
            for (int i = 1; i <= 10; i++) {
                NSString *file;
                if (i < 10) {
                    file = [NSString stringWithFormat:@"fire_blast_0%i.png", i];
                } else {
                    file = [NSString stringWithFormat:@"fire_blast_%i.png", i];
                }
                CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
                [frames addObject:frame];
            }
            CCCallBlock *block1 = [CCCallBlock actionWithBlock:^{
                int i = 4 - count;
                int n = i % 3;
                int offsetX = (i % 2) * pow(-1, n);
                int offsetY = 0;
                NSLog(@"%i, %i", offsetX, offsetY);
                if (i == 2) {
                    offsetY = 1;
                } else if (i == 4) {
                    offsetY = -1;
                }
                int x = atPos.x + offsetX * 173.0 / 6.0;
                int y = atPos.y + offsetY * 181.0 / 6.0;
                [self useSkill:atPos finalPos:ccp(x, y) flag:flag_ count:count-1];
                [self checkMagicHitEnemy:finalPos skillType:kSkillTypeFire_One];
            }];
            CCAnimation *animation = [CCAnimation animationWithSpriteFrames:frames delay:0.1];
            CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
            CCCallBlock *block2 = [CCCallBlock actionWithBlock:^{
                [s removeFromParentAndCleanup:YES];
            }];
            CCSequence *seq = [CCSequence actions:moveTo, block1, animate, block2, nil];
           [s runAction:seq];
           
            GameLayer *gameLayer = [GameLayer shareGameLayer];
            CCMoveBy *m1 = [CCMoveBy actionWithDuration:0.1 position:ccp(1, 1)];
            CCMoveBy *m2 = [CCMoveBy actionWithDuration:0.1 position:ccp(-1, -1)];
            CCSequence *seqGameLayer = [CCSequence actions:m1, m2, nil];
            CCRepeat *rep = [CCRepeat actionWithAction:seqGameLayer times:4];
            [gameLayer runAction:rep];
            
        }
            break;
        case 2:
        {
            CCSprite *s = [CCSprite spriteWithSpriteFrameName:@"ice_piton_001.png"];
            [self addChild:s z:4];
            s.position = finalPos;
            [self checkMagicHitEnemy:finalPos skillType:kSkillTypeIce_One];
            [[SimpleAudioEngine sharedEngine] playEffect:@"ice_1.caf"];
            CCAnimation *animation = [AnimationMaker animationWithFrame:@"ice_piton_00" frameCount:8 delay:0.1];
            CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
           
            CCCallBlock *bl = [CCCallBlock actionWithBlock:^{
                //x 0 -1 0 1 0
                //y 0 0 1 0 -1
                int i = 5 - count;
                int n = i % 3;
                int offsetX = (i % 2) * pow(-1, n);
                int offsetY = 0;
                
                if (i == 2) {
                    offsetY = 1;
                } else if (i == 4) {
                    offsetY = -1;
                }
                int x = atPos.x + offsetX * 173.0 / 4.0;
                int y = atPos.y + offsetY * 181.0 / 4.0;
                [self useSkill:atPos finalPos:ccp(x, y) flag:flag_ count:count-1];
            }];
             CCSequence *seq1 = [CCSequence actions:[CCDelayTime actionWithDuration:0.15], bl, nil];
            CCSpawn *sp = [CCSpawn actions:animate, seq1, nil];
            CCCallBlock *block = [CCCallBlock actionWithBlock:^{
                [[SimpleAudioEngine sharedEngine] playEffect:@"ice_2.caf"];
                [s removeFromParentAndCleanup:YES];
            }];
            CCSequence *seq = [CCSequence actions:sp, block, nil];
            [s runAction:seq];
        }
            break;
        case 3:
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"lightning_1.caf"];
            CCSprite *s = [CCSprite spriteWithSpriteFrameName:@"light_strike_1.png"];
            [self addChild:s z:4];
            //y 1 0 －1 count ＝ 2 count ＝ 0
            int offsetY = count - 3;
            int x = atPos.x;
            int y = atPos.y + offsetY * 181.0 / 8.0;
            s.position = ccp(x, y);
            CCAnimation *animation = [AnimationMaker animationWithFrame:@"light_strike_" frameCount:6 delay:0.1];
            CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
            
            CCCallBlock *bl = [CCCallBlock actionWithBlock:^{
                [self useSkill:ccp(x, y) finalPos:ccp(x, y) flag:flag_ count:count-1];
            }];
            CCSequence *seq1 = [CCSequence actions:[CCDelayTime actionWithDuration:0.2], bl, nil];
            CCSpawn *sp = [CCSpawn actions:animate, seq1, nil];
            
            CCCallBlock *block = [CCCallBlock actionWithBlock:^{
                [self checkMagicHitEnemy:finalPos skillType:kSkillTypeLight_One];
                [s removeFromParentAndCleanup:YES];
            }];
            CCSequence *seq = [CCSequence actions:sp, block, nil];
            [s runAction:seq];
        }
            break;
            
        default:
            break;
    }
}

- (CGPoint)boundLayerPos:(CGPoint)newPos
{
    CGPoint retval = newPos;
    retval.x = _skill.position.x+newPos.x;
    retval.y = _skill.position.y+newPos.y;
    
    if (retval.x>=470) {
        retval.x = 470;
    }else if (retval.x<=100) {
        retval.x = 100;
    }
    
    if (retval.y >=WINDOWHEIGHT-50) {
        retval.y = WINDOWHEIGHT-50;
    }else if (retval.y <= 43) {
        retval.y = 43;
    }
    
    return retval;
}


- (CGFloat)setBowDirByTouch:(CGPoint)touchLocation
{
    GameLayer *gameLayer = [GameLayer shareGameLayer];
    CGPoint bowPos = gameLayer.bow.position;
    if (touchLocation.x < bowPos.x) {
        return gameLayer.bow.rotation;
    }
    
    CGPoint pointVector = ccpSub(touchLocation, bowPos);
	CGFloat pointRadians = ccpToAngle(pointVector);
	CGFloat cocosDegrees = CC_RADIANS_TO_DEGREES(pointRadians);
    CGFloat cocosAngle = -1 * cocosDegrees;

    return cocosAngle;
}

- (void)attackWithAngle
{
    if ( ! isTouching || isUsingSkill) {
        return;
    }
    GameLayer *gameLayer = [GameLayer shareGameLayer];
    if (totalTime > nextShotTime)
	{
        [[SimpleAudioEngine sharedEngine] playEffect:@"arrow_shot.wav"];
        ArrowCache *arrowCache = (ArrowCache *)[gameLayer arrowCache];
        Player *player = (Player *)[gameLayer player];
        NSAssert(player != nil, @"player must not be nil");
		nextShotTime = totalTime + player.atkInterval;
		// Set the position, velocity and spriteframe before shooting
        CGFloat angle = gameLayer.bow.rotation;
		CGPoint shotPos = gameLayer.bow.position;
        int count = player.multipleArrow;
        for (int i = 0; i < count; i++) {
            CGFloat newAngle = angle - (i - count / 2)*2;
            CGFloat cocosHudu = CC_DEGREES_TO_RADIANS(-newAngle);
            CGPoint velocity = ccpMult(ccpForAngle(cocosHudu), player.atkSpeed);
            [arrowCache shootArrowFrom:shotPos velocity:velocity rotation:newAngle];
        }
	}
}

- (void)checkMagicHitEnemy:(CGPoint)endPos skillType:(SkillType)skillType
{
    GameLayer *gameLayer = [GameLayer shareGameLayer];
    Player *player = gameLayer.player;
    NSLog(@"%f,%f", endPos.x, endPos.y);
    CGRect rect = CGRectMake(endPos.x - 80, endPos.y - 80, 160, 160);
    for (EnemyBase *enemy in gameLayer.enemyCache.enemys) {
        CGRect bbox;
        if (enemy.type == EnemyTypeBoos) {
            bbox = enemy.boundingBox;
        } else {
            bbox = enemy.getRect;
        }
        if (CGRectIntersectsRect(rect, bbox)) {
            switch (skillType) {
                case kSkillTypeFire_One:
                    if ( ! enemy.isBurning ) {
                        enemy.isBurning = YES;
                        [enemy burn:(float)player.curBurn * 0.2];
                        enemy.currentBlood -= player.curBurn;
                    }
                    break;
                case kSkillTypeIce_One:
                    if ( ! enemy.isFreezed ) {
                        enemy.currentBlood -= player.curIce;
                        enemy.isFreezed = YES;
                        
                    } else {
                        enemy.blood -= player.curIce;
                        if (enemy.blood <= 0) {
                            [enemy die];
                            return;
                        }
                    }
                    break;
                case kSkillTypeLight_One:
                    enemy.currentBlood -= player.curLight;
                    break;
                default:
                    break;
            }
            if (enemy.currentBlood <= 0) {
                [enemy die];
            }
        }
    }
}

-(void) update:(ccTime)delta
{
	totalTime += delta;
    [self attackWithAngle];
    
    GameData *gameData = [GameData shareGameDataInstance];
    Player *player = [GameLayer shareGameLayer].player;
    CCNode *node = [self getChildByTag:kContorlLayerNodeTagAddMana];
    if (player.MP < gameData.maxMP) {
        node.visible = YES;
    } else {
        node.visible = NO;
    }
}

- (void)dealloc
{
    CCLOG(@"%@ : %@", NSStringFromSelector(_cmd), self);
    [super dealloc];
}

@end
