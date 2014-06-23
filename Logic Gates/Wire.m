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

            self.realInput = NO;
            
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

-(id)initWithStartPort:(Port*)sPort EndPort:(Port*)ePort{
    if (self = [super init]) {
        //Initialization
        if (sPort&&ePort) {
            self.startPort = sPort;
            self.endPort = ePort;

            self.startGate = sPort.ownerGate;
            self.endGate = ePort.ownerGate;

            self.realInput = NO;

            [sPort connectToWire:self];
            [ePort connectToWire:self];
            [self didConnectBothSides];
            [self drawLine];
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
    if (self.startPort && port.type == OutputPortType) {
        return NO;
    }
    if (self.endPort && port.type == InputPortType) {
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

-(void)connectNewPort:(Port*)newPort{
    if (newPort) {
        if ([self wantConnectThisPort:newPort]){
            if ([newPort isAbleToConnect]) {
                if (newPort.type == OutputPortType) {
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
                if (newPort.type == OutputPortType) {
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


-(void) setBoolStatus:(BOOL)value{
    if(_boolStatus != value){
        _boolStatus = value;
        [self updateColor];
        if (self.endPort) {
          [self.endPort inWireBoolStatusDidChange];
        }
    }
}

-(void) setRealInput:(BOOL)value{
    if(_realInput != value){
        _realInput = value;
        [self updateColor];
        if (self.endPort){
          [self.endPort inWireRealInputDidChange];
        }

    }
}

-(void)portBoolStatusDidChange:(PortType)portType{
    if (self.startPort && portType == OutputPortType) {
        self.boolStatus = self.startPort.boolStatus;
    }
}

-(void)portPositionDidChange{
    [self performSelectorInBackground:@selector(drawLine) withObject:nil];
}

-(void)portRealInputDidChange:(PortType)portType{
    if (self.startPort && portType == OutputPortType) {
        self.realInput = self.startPort.realInput;
    }
}

-(void)portWillRemoveWires{
    [self kill];
}

-(void)updateColor{
    if (!self.realInput) {
        self.color = [SKColor redColor];
    } else {
        if (self.boolStatus) {
            self.color = [SKColor greenColor];
        } else {
            self.color = [SKColor blackColor];
        }
    }
}

-(void)kill{
    if (self.startPort) {
        [self.startPort removeDelegate:self];
    }
    if (self.endPort){
        [self.endPort inWireWillRemove];
        [self.endPort removeDelegate:self];
    }
    [self removeAllActions];
    [self removeFromParent];
}

-(void)didConnectBothSides{
    [self.startPort addDelegate:self];
    [self.endPort addDelegate:self];
    
    self.realInput = self.startPort.realInput;
    self.boolStatus = self.startPort.boolStatus;

    [self.startPort finishedConnectProcess];
    [self.endPort finishedConnectProcess];
}

-(void)drawLine{
    if (self.startPort && self.endPort) {
        CGPoint startPos = [self.startPort mapPosition];
        CGPoint endPos = [self.endPort mapPosition];
        [self drawPathWithStartPosition:startPos andEndPosition:endPos];
    }
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
    [self drawPathWithStartPosition:startPos andEndPosition:endPos];
}

-(void)drawPathWithStartPosition:(CGPoint)startPos andEndPosition:(CGPoint)endPos{
    CGFloat length = (CGFloat)sqrt(pow(startPos.x-endPos.x, 2)+pow(startPos.y-endPos.y, 2));
    self.size = CGSizeMake(length, 4);
    CGFloat x = endPos.x - startPos.x;
    CGFloat y = endPos.y - startPos.y;
    CGFloat rotation;
    if (x == 0.0) {
        rotation = M_PI_2;
    } else{
        rotation = atan(y/x);
        if (x<0.0) {
            rotation += M_PI;
        }else{
            rotation += M_PI*2;
        }
    }
    self.zRotation = rotation;
    self.position = CGPointMake((endPos.x + startPos.x)/2, (endPos.y + startPos.y)/2);
    
    /*
    CGMutablePathRef drawPath = CGPathCreateMutable();
    CGPathMoveToPoint(drawPath, NULL, startPos.x, startPos.y);
    CGPathAddLineToPoint(drawPath, NULL, endPos.x, endPos.y);
    self.path = drawPath;
    CGPathRelease(drawPath);
     */
}
@end
