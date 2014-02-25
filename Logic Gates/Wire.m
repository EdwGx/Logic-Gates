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

        if (newPort.multiConnect) {
            self.startPort = newPort;
            self.startGate = newPort.ownerGate;
            [self.startPort addObserver:self forKeyPath:@"boolStatus" options:NSKeyValueObservingOptionNew context:nil];
            [self.startPort addObserver:self forKeyPath:@"realInput" options:NSKeyValueObservingOptionNew context:nil];
        } else {
            self.endPort = newPort;
            self.endGate = newPort.ownerGate;
        }
        if (newPort.ownerGate) {
            [newPort.ownerGate addObserver:self forKeyPath:@"position" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([@"position" isEqualToString:keyPath]) {
        [self drawLine];
    }
}

-(void)updateColor{
    if (!self.realInput) {
        self.fillColor = [SKColor redColor];
    } else if (self.boolStatus) {
        self.fillColor = [SKColor greenColor];
    } else {
        self.fillColor = [SKColor blackColor];
    }
}

-(void)drawLine{
    CGPoint startPos;
    CGPoint endPos;
    if (self.startPort) {
        startPos = [self.startPort mapPosition];
        endPos = [delegate getDragingPosition];
    } else if (self.endPort) {
        endPos = [self.endPort mapPosition];
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
    [self removeFromParent];
}
-(void)dealloc{
    [self.startGate removeObserver:self forKeyPath:@"position"];
    [self.endGate removeObserver:self forKeyPath:@"position"];
    
    [self.startPort removeObserver:self forKeyPath:@"boolStatus"];
    [self.startPort removeObserver:self forKeyPath:@"realInput"];
}
@end
