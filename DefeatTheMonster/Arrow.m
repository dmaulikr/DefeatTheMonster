//
//  Arrow.m
//  DefeatTheMonster
//
//  Created by aatc on 10/10/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "Arrow.h"

@implementation Arrow

@synthesize velocity;

+ (id)arrowWithSpriteFrame:(CCSpriteFrame *)frame
{
    return [[[self alloc] initWithSpriteFrame:frame] autorelease];
}

- (void)shootArrowFrom:(CGPoint)startPosition
			   velocity:(CGPoint)vel
			   rotation:(float)angle
{
    self.velocity = vel;
    self.position = startPosition;
    self.visible = YES;
    self.rotation = angle;
    
    [self unscheduleUpdate];
    [self scheduleUpdate];
}

-(void) update:(ccTime)delta
{
    // update position of the bullet
    // multiply the velocity by the time since the last update was called
    // this ensures same bullet velocity even if frame rate drops
	self.position = ccpAdd(self.position, velocity);
	// When the bullet leaves the screen, make it invisible
    CGSize size = [[CCDirector sharedDirector] winSize];
    CGRect screenRect = CGRectMake(0, 0, size.width, size.height);

	if (CGRectIntersectsRect(self.boundingBox, screenRect) == NO)
	{
		self.visible = NO;
		[self unscheduleUpdate];
	}
}

@end
