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

@property(nonatomic, weak) Port* startPort;
@property(nonatomic, weak) Port* endPort;

@property(nonatomic, weak) Gates* startGate;
@property(nonatomic, weak) Gates* endGate;

@property(nonatomic) BOOL boolStatus;
@property(nonatomic) BOOL realInput;

@property(nonatomic, weak) id delegate;
@end
