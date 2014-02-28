//
//  Switch.m
//  Logic Gates
//
//  Created by edguo on 2/27/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "Switch.h"

@implementation Switch{
    BOOL outputState;
}

-(void)initPort{
    Port *outP1 = [[Port alloc]initWithPosition:CGPointMake(6, 0) andStatusOfMultiConnection:true andOwner:self];
    outP1.boolStatus = false;
    outputState = outP1.boolStatus;
    self.outPort = [NSArray arrayWithObject:outP1];
}

-(NSString*)imageName{
    if (outputState) {
        return @"switch_on";
    } else {
        return @"switch_off";
    }
}

-(int8_t)getDefultGateTypeValue{
    return 8;
}

-(BOOL)isRealInputSource{
    return true;
}

-(BOOL)touchDownWithPointInNode:(CGPoint)point{
    if ((point.x>-5 && point.x<3) && (point.y>-10 && point.y<10)){
        Port *outP1 = [self.outPort objectAtIndex:0];
        outputState = !outputState;
        outP1.boolStatus = outputState;
        [self initImage];
    }
    return false;
}
@end
