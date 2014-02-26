//
//  Gates.m
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "Gates.h"

@implementation Gates

-(id)initGate{
    if (self = [super init]) {
        self.gateType = [self getDefultGateTypeValue];
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

-(int8_t)getDefultGateTypeValue{
    return 0;
}

-(void)updateRealIntput{
    /*Get the real input boolean*/
    BOOL real = true;
    
    //Check do all ports have real input
    for (int i = 0; i < [self.inPort count]; i++) {
        Port* portObject = [self.inPort objectAtIndex:i];
        if (!portObject.realInput) {
            real = false;
            break;
        }
    }
    
    real = real || [self isRealInputSource] ;
        
    for (int i = 0; i < [self.inPort count]; i++) {
        Port* portObject = [self.inPort objectAtIndex:i];
        portObject.boolStatus = real;
    }
    
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
