//
//  Wire.m
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "Wire.h"

@implementation Wire
@synthesize delegate;

-(id)initWithStartPort:(Port*)sPort andEndPort:(Port*)ePort{
    if (self = [super init]) {
        //Initialization
        if (sPort || ePort) {
            self.startPort = sPort;
            self.endPort = ePort;
        } else{
            return nil;
        }
    }
    return self;
}

-(void)connectNewPort:(Port*)newPort{
    if (newPort) {
        

    }
}

-(void)updateColor{
    if (!realInput) {
        self.fillColor = [SKColor redColor];
    } else if (boolStatus) {
        self.fillColor = [SKColor greenColor];
    } else {
        self.fillColor = [SKColor blackColor];
    }
}

-(void)drawLine{
    CGPoint startPos;
    CGPoint endPos;
    if (self.startPort) {
        startPos = self.startPort.position;
        endPos = [delegate getDragingPosition];
    } else if (self.endPort) {
        endPos = self.endPort.position;
        startPos = [delegate getDragingPosition];
    } else {
        //Wire should have one or more port
        [self kill];
    }
    
    CGMutablePathRef drawPath = CGPathCreateMutable();
    CGPathMoveToPoint(drawPath, NULL, startPos.x, startPos.y);
    CGPathAddLineToPoint(drawPath, NULL, endPos.x, endPos.x);
    self.path = drawPath;
}

-(void)kill{
    //kill it self
}
@end
