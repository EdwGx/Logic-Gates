//
//  LightBulb.m
//  Logic Gates
//
//  Created by edguo on 2/28/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LightBulb.h"

@implementation LightBulb
-(void)initPort{
    Port *inP1 = [[Port alloc]initWithPosition:CGPointMake(0, -28) andPortType:InputPortType andOwner:self];
    self.inPort = [NSArray arrayWithObject:inP1];
}

-(NSString*)imageName{
    Port *inP1 = [self.inPort objectAtIndex:0];
    if (inP1.boolStatus && inP1.realInput) {
        return @"bulb_on";
    }else{
        return @"bulb_off";
    }
    
}

-(void)updateRealIntput{
    [super updateRealIntput];
    [self initImage];
}
-(void)updateOutput{
    [self initImage];
}

-(GateType)getDefultGateType{
    return GateTypeLightBulb;
}

-(NSString*)booleanFormula{
    if (self.realInput) {
        Port* inP1 = self.inPort[0];
        if (inP1.inWire) {
            if (inP1.inWire.startGate) {
                return [inP1.inWire.startGate booleanFormula];
            }
        }
    }
    return @"ERROR";
}

-(NSString*)gateName{
    return @"Light Bulb";
}
@end
