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
        [self addObserserToInPort];
    }
    return self;
}

-(void)initPort{
    /* Initialization of Ports*/
}

-(void)initImage{
    /* Initialization of Image*/
}

-(void)updateOutput{
    /*Get the ouput boolean*/
}

-(void)updateRealIntput{
    /*Get the real input boolean
    BOOL real = true;
    for (int i = 0; i < [self.inPort count]; i++) {

    }*/
}

-(BOOL)isRealInputSource{
    return false;
}

-(void)addObserserToInPort{
    for (NSInteger i = 0; i<[self.inPort count]; i++) {
        if ([self.inPort objectAtIndex:i]) {
            [[self.inPort objectAtIndex:i] addObserver:self forKeyPath:@"boolStatus" options:0 context:nil];
            [[self.inPort objectAtIndex:i] addObserver:self forKeyPath:@"realInput" options:0 context:nil];
        }
    }
}

-(void)dealloc{
    for (NSInteger i = 0; i<[self.inPort count]; i++) {
            [[self.inPort objectAtIndex:i] removeObserver:self forKeyPath:@"boolStatus"];
            [[self.inPort objectAtIndex:i] removeObserver:self forKeyPath:@"realInput"];
    }
}


@end
