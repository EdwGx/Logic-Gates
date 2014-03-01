//
//  XOR Gate.m
//  Logic Gates
//
//  Created by edguo on 3/1/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "XOR Gate.h"

@implementation XOR_Gate
-(void)initPort{
    Port *inP1 = [[Port alloc]initWithPosition:CGPointMake(-17, -4) andStatusOfMultiConnection:false andOwner:self];
    Port *inP2 = [[Port alloc]initWithPosition:CGPointMake(-17, 4) andStatusOfMultiConnection:false andOwner:self];
    self.inPort = [NSArray arrayWithObjects:inP1,inP2, nil];
    
    Port *outP1 = [[Port alloc]initWithPosition:CGPointMake(17, 0) andStatusOfMultiConnection:true andOwner:self];
    self.outPort = [NSArray arrayWithObject:outP1];
    
}

-(NSString*)imageName{
    return @"xor_gate";
}

-(void)updateOutput{
    if (self.realInput) {
        Port *outP1 = [self.outPort objectAtIndex:0];
        Port *inP1 = [self.inPort objectAtIndex:0];
        Port *inP2 = [self.inPort objectAtIndex:1];
        outP1.boolStatus = inP1.boolStatus ^ inP2.boolStatus;
    }
}

-(int8_t)getDefultGateTypeValue{
    return 3;
}
@end
