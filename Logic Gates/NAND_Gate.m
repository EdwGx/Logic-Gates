//
//  NAND_Gate.m
//  Logic Gates
//
//  Created by edguo on 3/1/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "NAND_Gate.h"

@implementation NAND_Gate
-(void)initPort{
    Port *inP1 = [[Port alloc]initWithPosition:CGPointMake(-25, -6) andPortType:InputPortType andOwner:self];
    Port *inP2 = [[Port alloc]initWithPosition:CGPointMake(-25, 6) andPortType:InputPortType andOwner:self];
    self.inPort = [NSArray arrayWithObjects:inP1,inP2, nil];
    
    Port *outP1 = [[Port alloc]initWithPosition:CGPointMake(25, 0) andPortType:OutputPortType andOwner:self];
    self.outPort = [NSArray arrayWithObject:outP1];
    
}

-(NSString*)imageName{
    return @"nand_gate";
}

-(void)updateOutput{
    if (self.realInput) {
        Port *outP1 = [self.outPort objectAtIndex:0];
        Port *inP1 = [self.inPort objectAtIndex:0];
        Port *inP2 = [self.inPort objectAtIndex:1];
        outP1.boolStatus = !(inP1.boolStatus && inP2.boolStatus);
    }
}

-(NSUInteger)getDefultGateTypeValue{
    return 4;
}

-(NSString*)gateNameInBooleanFormula{
    return @"NAND";
}

-(NSString*)gateName{
    return @"NAND Gate";
}
@end
