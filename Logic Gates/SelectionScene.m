//
//  SelectionScene.m
//  Logic Gates
//
//  Created by edguo on 2/28/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "SelectionScene.h"

@implementation SelectionScene
-(id)initWithSize:(CGSize)size andScene:(SKScene *)scene{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1];
    }
    return self;
}

@end
