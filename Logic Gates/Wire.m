//
//  Wire.m
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "Wire.h"

@implementation Wire

-(id)initWithAnyPort:(Port*)sPort andStartPosition:(CGPoint)sPos {
    if (self = [super init]) {
        //Initialization
        if (sPort) {
            self.startPort = nil;
            self.endPort = nil;
            
            self.startGate = nil;
            self.endGate = nil;
            
            self.realInput = YES;
            
            didRegisterStartPort = NO;
            didRegisterEndPort = NO;
            
            [self connectNewPort:sPort withPosition:sPos];
            if (self.startPort) {
                self.boolStatus = self.startPort.boolStatus;
            }
            [self updateColor];
        } else{
            return nil;
        }
    }
    return self;
}
-(BOOL)wantConnectThisPort:(Port *)port{
    if (self.startPort && port.multiConnect) {
        return NO;
    }
    if (self.endPort && !port.multiConnect) {
        return NO;
    }
    if (self.startGate) {
        if ([self.startGate isEqual:port.ownerGate]){
            return NO;
        }
    }
    if (self.endGate) {
        if ([self.endGate isEqual:port.ownerGate]){
            return NO;
        }
    }
    return YES;
}

-(void)updateRealInput{
    if (self.startPort) {
        self.realInput = self.startPort.realInput;
        [self updateColor];
    }
}

-(void)connectNewPort:(Port*)newPort{
    if (newPort) {
        if ([self wantConnectThisPort:newPort]){
            if ([newPort isAbleToConnect]) {
                if (newPort.multiConnect) {
                    self.startPort = newPort;
                    self.startGate = newPort.ownerGate;
                } else {
                    self.endPort = newPort;
                    self.endGate = newPort.ownerGate;
                }
                [newPort connectToWire:self];
                [self drawLine];
                if (self.startPort && self.endPort) {
                    [self didConnectBothSides];
                }
                return;
            }
        }
    }
    [self kill];
}

-(void)connectNewPort:(Port*)newPort withPosition:(CGPoint)point{
    if (newPort) {
        if ([self wantConnectThisPort:newPort]){
            if ([newPort isAbleToConnect]) {
                if (newPort.multiConnect) {
                    self.startPort = newPort;
                    self.startGate = newPort.ownerGate;
                } else {
                    self.endPort = newPort;
                    self.endGate = newPort.ownerGate;
                }
                [newPort connectToWire:self];
                [self drawLineWithPosition:point];
                if (self.startPort && self.endPort) {
                    [self didConnectBothSides];
                }
                return;
            }
        }
    }
    [self kill];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([@"position" isEqualToString:keyPath]) {
        [self performSelectorInBackground:@selector(drawLine) withObject:nil];
    }
    if ([@"boolStatus" isEqualToString:keyPath]) {
        self.boolStatus = self.startPort.boolStatus;
        [self updateColor];
    }
    if ([@"realInput" isEqualToString:keyPath]) {
        [self performSelectorInBackground:@selector(updateRealInput) withObject:nil];
    }
    if ([@"willKill" isEqualToString:keyPath]) {
        [self kill];
    }
    if ([@"killWire" isEqualToString:keyPath]) {
        if ([change objectForKey:NSKeyValueChangeNewKey]) {
            [self kill];
        }
    }

}

-(void)updateColor{
    if (!self.realInput) {
        self.strokeColor = [SKColor redColor];
    } else {
        if (self.boolStatus) {
            self.strokeColor = [SKColor greenColor];
        } else {
            self.strokeColor = [SKColor blackColor];
        }
    }
}

-(void)kill{
    if (self.endPort){
        [self.endPort willRemoveWire];
    }
    [self removeAllActions];
    [self removeFromParent];
}

-(void)didConnectBothSides{
    [self.startPort addObserver:self forKeyPath:@"boolStatus" options:0 context:nil];
    [self.startPort addObserver:self forKeyPath:@"realInput" options:0 context:nil];
    [self.startPort addObserver:self forKeyPath:@"killWire" options:NSKeyValueObservingOptionNew context:nil];
    [self.startGate addObserver:self forKeyPath:@"position" options:0 context:nil];
    [self.startGate addObserver:self forKeyPath:@"willKill" options:0 context:nil];
    didRegisterStartPort = YES;
    [self.endPort addObserver:self forKeyPath:@"killWire" options:NSKeyValueObservingOptionNew context:nil];
    [self.endGate addObserver:self forKeyPath:@"willKill" options:0 context:nil];
    [self.endGate addObserver:self forKeyPath:@"position" options:0 context:nil];
    didRegisterEndPort = YES;
    
    [self updateRealInput];
    self.boolStatus = self.startPort.boolStatus;
    [self updateColor];
    
    [self.startPort finishedConnectProcess];
    [self.endPort finishedConnectProcess];
}

-(void)drawLine{
    CGPoint startPos;
    CGPoint endPos;
    if (self.startPort && self.endPort) {
        startPos = [self.startPort mapPosition];
        endPos = [self.endPort mapPosition];
    } else if (self.startPort) {
        startPos = [self.startPort mapPosition];
        endPos = [self.delegate getDragingPosition];
    } else if (self.endPort) {
        endPos = [self.endPort mapPosition];
        startPos = [self.delegate getDragingPosition];
    } else {
        //Wire should have one or more port
        [self kill];
        return;
    }
    
    CGMutablePathRef drawPath = CGPathCreateMutable();
    CGPathMoveToPoint(drawPath, NULL, startPos.x, startPos.y);
    CGPathAddLineToPoint(drawPath, NULL, endPos.x, endPos.y);
    self.path = drawPath;
    CGPathRelease(drawPath);
}

-(void)drawLineWithPosition:(CGPoint)point{
    CGPoint startPos;
    CGPoint endPos;
    if (self.startPort && self.endPort) {
        startPos = [self.startPort mapPosition];
        endPos = [self.endPort mapPosition];
    } else if (self.startPort) {
        startPos = [self.startPort mapPosition];
        endPos = point;
    } else if (self.endPort) {
        endPos = [self.endPort mapPosition];
        startPos = point;
    } else {
        //Wire should have one or more port
        [self kill];
        return;
    }
    
    CGMutablePathRef drawPath = CGPathCreateMutable();
    CGPathMoveToPoint(drawPath, NULL, startPos.x, startPos.y);
    CGPathAddLineToPoint(drawPath, NULL, endPos.x, endPos.y);
    self.path = drawPath;
    CGPathRelease(drawPath);
}


-(void)dealloc{
    if (didRegisterStartPort) {
        [self.startGate removeObserver:self forKeyPath:@"position"];
        [self.startPort removeObserver:self forKeyPath:@"boolStatus"];
        [self.startPort removeObserver:self forKeyPath:@"realInput"];
        [self.startPort removeObserver:self forKeyPath:@"killWire"];
        [self.startGate removeObserver:self forKeyPath:@"willKill"];
    }
    if (didRegisterEndPort) {
        [self.endPort removeObserver:self forKeyPath:@"killWire"];
        [self.endGate removeObserver:self forKeyPath:@"willKill"];
        [self.endGate removeObserver:self forKeyPath:@"position"];
    }
}
@end
