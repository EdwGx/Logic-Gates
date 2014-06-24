//
//  StandardGate.m
//  Logic Gates
//
//  Created by Edward Guo on 2014-06-24.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "StandardGate.h"

@implementation StandardGate
-(NSString*)gateNameInBooleanFormula{
    return @"?";
}
-(NSString*)booleanFormula{
    if (self.inPort.count >= 2) {
        Port*inP1 = self.inPort[0];
        Port*inP2 = self.inPort[1];
        if (inP1.inWire && inP2.inWire) {
            if (inP1.inWire.startGate && inP1.inWire.startGate) {
                return [NSString stringWithFormat:@"(%@ %@ %@)",
                        [inP1.inWire.startGate booleanFormula],
                        [self gateNameInBooleanFormula],
                        [inP2.inWire.startGate booleanFormula]];
            }
        }
    }
    return @"Error";
}
@end
