//
//  Wire.h
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Port.h"
@class Port;
@protocol wireProtocol

-(struct CGPoint)getDragingPosition;

@end
@interface Wire : SKShapeNode{
    BOOL realInput;
    BOOL boolStatus;
}
-(id) initWithStartPort:(Port*)sPort andEndPort:(Port*)ePort;
-(void) drawLine;
-(void) kill;
@property(weak,nonatomic) Port* startPort;
@property(weak,nonatomic) Port* endPort;
@property(weak,nonatomic) id delegate;

@end
