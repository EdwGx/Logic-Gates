//
//  Wire.h
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Port.h"
#import "Gates.h"

@class Port;
@class Gates;
@protocol wireProtocol

-(CGPoint)getDragingPosition;

@end
@interface Wire : SKShapeNode{
    BOOL didRegisterStartPort;
    BOOL didRegisterEndPort;
}
-(id)initWithAnyPort:(Port*)sPort andStartPosition:(CGPoint)sPos;
-(id)initWithStartPort:(Port*)sPort EndPort:(Port*)ePort;

-(void) drawLine;
-(void) drawLineWithPosition:(CGPoint)point;
-(void) kill;
-(void) updateRealInput;
-(void) connectNewPort:(Port*)newPort;
-(void) connectNewPort:(Port*)newPort withPosition:(CGPoint)point;
-(BOOL) wantConnectThisPort:(Port*)port;

@property(weak) Port* startPort;
@property(weak) Port* endPort;

@property(weak) Gates* startGate;
@property(weak) Gates* endGate;

@property BOOL boolStatus;
@property BOOL realInput;

@property(weak) id delegate;
@end
