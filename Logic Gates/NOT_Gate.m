//
//  NOT_Gate.m
//  Logic Gates
//
//  Created by edguo on 2/28/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "NOT_Gate.h"

@implementation NOT_Gate
-(void)initPort{
    Port *inP1 = [[Port alloc]initWithPosition:CGPointMake(-25, 0) andPortType:InputPortType andOwner:self];
    self.inPort = [NSArray arrayWithObject:inP1];
    
    Port *outP1 = [[Port alloc]initWithPosition:CGPointMake(25, 0) andPortType:OutputPortType andOwner:self];
    self.outPort = [NSArray arrayWithObject:outP1];
    
}

-(NSString*)imageName{
    return @"not_gate";
}

-(void)updateOutput{
    if (self.realInput) {
        Port *outP1 = [self.outPort objectAtIndex:0];
        Port *inP1 = [self.inPort objectAtIndex:0];
        outP1.boolStatus = !inP1.boolStatus;
    }
}

-(int8_t)getDefultGateTypeValue{
    return 7;
}
@end
