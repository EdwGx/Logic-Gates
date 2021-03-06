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
    Port *outP1 = [[Port alloc]initWithPosition:CGPointMake(12, 0) andPortType:OutputPortType andOwner:self];
    outP1.boolStatus = NO;
    outputState = outP1.boolStatus;
    self.outPort = [NSArray arrayWithObject:outP1];
    self.userInteractionEnabled = YES;
    self.userData = [NSMutableDictionary dictionary];
    [self.userData setValue:@"undefine" forKey:@"InputName"];
}

-(NSString*)imageName{
    if (outputState) {
        return @"switch_on";
    } else {
        return @"switch_off";
    }
}

-(GateType)getDefultGateType{
    return GateTypeSwitch;
}

-(BOOL)isRealInputSource{
    return YES;
}

-(Port*)portCloseToPointInScene:(CGPoint)point Range:(float)range{
    if (range<=0.6) {
        return [super portCloseToPointInScene:point Range:0.1];
    }else{
        return [super portCloseToPointInScene:point Range:range];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    for (UITouch* touch in touches) {
        CGPoint point = [touch locationInNode:self];
        if ((point.x>-5 && point.x<3) && (point.y>-10 && point.y<10)){
            Port *outP1 = [self.outPort objectAtIndex:0];
            outputState = !outputState;
            outP1.boolStatus = outputState;
            [self initImage];
            return;
        }
    }
}

-(NSString*)booleanFormula{
    return [self.userData objectForKey:@"InputName"];
}

-(NSString*)gateName{
    return [NSString stringWithFormat:@"Switch (%@)",[self booleanFormula]];
}
@end
