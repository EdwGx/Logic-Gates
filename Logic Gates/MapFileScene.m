//
//  MapFileScene.m
//  Logic Gates
//
//  Created by edguo on 2014-03-21.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "MapFileScene.h"

@implementation MapFileScene{
    SKScene *mScene;
}
-(id)initWithSize:(CGSize)size MainScene:(SKScene*)mainScene{
    if (self = [super initWithSize:size]) {
        mScene = mainScene;
    }
    return self;
}
@end
