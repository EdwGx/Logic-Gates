//
//  Wire.m
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "Wire.h"

@implementation Wire

-(id)initWithAnyPort:(Port*)sPort {
    if (self = [super init]) {
        //Initialization
        if (sPort) {
            [self connectNewPort:sPort];
            [self updateColor];
            [self drawLine];
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
            [self.startPort addObserver:self forKeyPath:@"boolStatus" options:0 context:nil];
            [self.startPort addObserver:self forKeyPath:@"realInput" options:0 context:nil];
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
        [self performSelectorInBackground:@selector(drawLine) withObject:nil];
    }
}

-(void)updateColor{
    if (!self.realInput) {
        self.strokeColor = [SKColor redColor];
    } else if (self.boolStatus) {
        self.strokeColor = [SKColor greenColor];
    } else {
        self.strokeColor = [SKColor blackColor];
    }
}

-(void)drawLine{
    CGPoint startPos;
    CGPoint endPos;
    if (self.startPort) {
        startPos = [self.startPort mapPosition];
        endPos = [self.delegate getDragingPosition];
    } else if (self.endPort) {
        endPos = [self.endPort mapPosition];
        startPos = [self.delegate getDragingPosition];
    } else {
        //Wire should have one or more port
        return;
    }
    
    CGMutablePathRef drawPath = CGPathCreateMutable();
    CGPathMoveToPoint(drawPath, NULL, startPos.x, startPos.y);
    CGPathAddLineToPoint(drawPath, NULL, endPos.x, endPos.y);
    self.path = drawPath;
    CGPathRelease(drawPath);
}


-(void)dealloc{
    [self.startGate removeObserver:self forKeyPath:@"position"];
    [self.endGate removeObserver:self forKeyPath:@"position"];
    
    [self.startPort removeObserver:self forKeyPath:@"boolStatus"];
    [self.startPort removeObserver:self forKeyPath:@"realInput"];
}
@end
