//
//  Wire.h
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Port.h"
#import "PortDelegate.h"
#import "Gates.h"

@class Port;
@class Gates;
@protocol wireProtocol

-(CGPoint)getDragingPosition;

@end
@interface Wire : SKShapeNode<PortDelegate>

-(id)initWithAnyPort:(Port*)sPort andStartPosition:(CGPoint)sPos;
-(id)initWithStartPort:(Port*)sPort EndPort:(Port*)ePort;

-(void) drawLine;
-(void) kill;
-(void) connectNewPort:(Port*)newPort;
-(void) connectNewPort:(Port*)newPort withPosition:(CGPoint)point;
-(BOOL) wantConnectThisPort:(Port*)port;

@property(weak) Port* startPort;
@property(weak) Port* endPort;

@property(weak) Gates* startGate;
@property(weak) Gates* endGate;

@property(nonatomic) BOOL boolStatus;
@property(nonatomic) BOOL realInput;

@property(weak) id delegate;
@end
