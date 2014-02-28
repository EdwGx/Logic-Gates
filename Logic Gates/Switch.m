//
//  Switch.m
//  Logic Gates
//
//  Created by edguo on 2/27/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "Switch.h"

@implementation Switch
-(void)initPort{
    Port *outP1 = [[Port alloc]initWithPosition:CGPointMake(6, 0) andStatusOfMultiConnection:true andOwner:self];
    outP1.boolStatus = true;
    self.outPort = [NSArray arrayWithObject:outP1];
}

-(NSString*)imageName{
    return @"switch_off";
}

-(int8_t)getDefultGateTypeValue{
    return 8;
}

-(BOOL)isRealInputSource{
    return true;
}
@end
