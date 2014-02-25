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
@protocol wireProtocol

-(CGPoint)getDragingPosition;

@end
@interface Wire : SKShapeNode{
}
-(id) initWithStartPort:(Port*)sPort andEndPort:(Port*)ePort;
-(void) drawLine;
-(void) kill;
@property(weak) Port* startPort;
@property(weak) Port* endPort;

@property(weak) Gates* startGate;
@property(weak) Gates* endGate;

@property(weak) id delegate;
@property BOOL boolStatus;
@property BOOL realInput;

@end
