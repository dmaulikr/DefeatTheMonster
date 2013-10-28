//
//  MoveComponent.m
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "MoveComponent.h"


@implementation MoveComponent

+ (id)moveComponentWithVelocity:(CGPoint)velocity
{
    return [[[self alloc] initWithVelocity:velocity] autorelease];
}

- (id)initWithVelocity:(CGPoint)velocity
{
    if ((self = [super init]))
	{
		_velocity = velocity;
		[self scheduleUpdate];
	}
    
    return self;
}

-(void) update:(ccTime)delta
{
    self.parent.visible = YES;
    // update position of the bullet
    // multiply the velocity by the time since the last update was called
    // this ensures same bullet velocity even if frame rate drops
	self.parent.position = ccpAdd(self.parent.position, _velocity);
	// When the bullet leaves the screen, make it invisible
}

@end
