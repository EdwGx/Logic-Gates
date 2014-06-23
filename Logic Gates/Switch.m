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
    [self.userData setObject:@"" forKey:@"InputName"];
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
    return YES;
}

-(Port*)portCloseToPointInScene:(CGPoint)point Range:(float)range{
    if (range<=0.6) {
        return [super portCloseToPointInScene:point Range:0.1];
    }else{
        return [super portCloseToPointInScene:point Range:range];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
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

/*
-(void)touchEndedInGate:(CGPoint)point{
    if ((point.x>-5 && point.x<3) && (point.y>-10 && point.y<10)){
        Port *outP1 = [self.outPort objectAtIndex:0];
        outputState = !outputState;
        outP1.boolStatus = outputState;
        [self initImage];
    }
}
*/
@end
