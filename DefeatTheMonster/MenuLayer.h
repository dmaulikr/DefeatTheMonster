//
//  MenuLayer.h
//  DefeatTheMonster
//
//  Created by aatc on 10/9/13.
//  Copyright 2013 nchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GADBannerView.h"
@interface MenuLayer : CCLayer<GADBannerViewDelegate>
{
    GADBannerView *bannerView_;
}

+ (id)scene;

@end
