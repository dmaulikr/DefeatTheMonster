//
//  HealthBarComponent.m
//  DefeatTheMonster
//
//  Created by aatc on 10/11/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import "HealthBarComponent.h"
#import "EnemyBase.h"

@implementation HealthBarComponent

-(void) onEnter
{
	[super onEnter];
	
	[self scheduleUpdate];
}

- (id)init
{
    if ( self = [super init] ) {

        
        
    }
    
    return self;
}

-(void) update:(ccTime)delta
{
	if (self.parent.visible)
	{
		NSAssert([self.parent isKindOfClass:[EnemyBase class]], @"parent not an Enemy");
		EnemyBase* enemy = (EnemyBase *)self.parent;
		self.percentage = enemy.currentBlood / (float)enemy.blood;
	}
}

@end
