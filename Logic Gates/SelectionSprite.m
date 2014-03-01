//
//  SelectionSprite.m
//  Logic Gates
//
//  Created by edguo on 3/1/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "SelectionSprite.h"

@implementation SelectionSprite
-(id)initWithScene:(SKScene *)scene{
    //NSArray* imageArray = [[NSArray alloc]initWithObjects:@"and_gate",@"or_gate",@"not_gate",@"switch",@"light_bulb",nil];
    if (self = [super initWithColor:[SKColor blueColor] size:CGSizeMake(10, 10)]) {
        
    }
    return self;
}

@end
