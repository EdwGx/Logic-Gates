//
//  OR_Gate.m
//  Logic Gates
//
//  Created by edguo on 2/27/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "OR_Gate.h"

@implementation OR_Gate
-(void)initPort{
    Port *inP1 = [[Port alloc]initWithPosition:CGPointMake(-25, -6) andStatusOfMultiConnection:NO andOwner:self];
    Port *inP2 = [[Port alloc]initWithPosition:CGPointMake(-25, 6) andStatusOfMultiConnection:NO andOwner:self];
    self.inPort = [NSArray arrayWithObjects:inP1,inP2, nil];
    
    Port *outP1 = [[Port alloc]initWithPosition:CGPointMake(25, 0) andStatusOfMultiConnection:YES andOwner:self];
    self.outPort = [NSArray arrayWithObject:outP1];
    
}

-(NSString*)imageName{
    return @"or_gate";
}

-(void)updateOutput{
    if (self.realInput) {
        Port *outP1 = [self.outPort objectAtIndex:0];
        Port *inP1 = [self.inPort objectAtIndex:0];
        Port *inP2 = [self.inPort objectAtIndex:1];
        outP1.boolStatus = inP1.boolStatus || inP2.boolStatus;
    }
}

-(int8_t)getDefultGateTypeValue{
    return 2;
}

@end
