//
//  Gates.m
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "Gates.h"

@implementation Gates

-(id)initWithGateType:(int8_t)newGateType{
    if (self = [super init]) {
        [self initImage];
        [self initPort];
    }
    return self;
}

-(void)initPort{
    /* Initialization of Ports*/
}

-(void)initImage{
    /* Initialization of Image*/
}
@end
