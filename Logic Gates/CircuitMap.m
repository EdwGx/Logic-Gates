//
//  CircuitMap.m
//  Logic Gates
//
//  Created by edguo on 3/5/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "CircuitMap.h"

@implementation CircuitMap
-(id)initMapWithScene:(SKScene*)sscene{
    if (self = [super init]) {
        self.mainScene = sscene;
        self.position = CGPointMake(self.scene.size.width/2, self.scene.size.height/2);
    }
    return self;
}
@end
