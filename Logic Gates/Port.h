//
//  Port.h
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Wire.h"
#import "Gates.h"

@class Gates;
@class Wire;
@interface Port : SKNode{
    BOOL wireConnectable;
    }
-(id)initWithPosition:(struct CGPoint)pos andStatusOfMultiConnection:(BOOL)multiConn andOwner:(Gates*)newOwner;
-(void) connectToWire:(Wire*)newWire;
-(CGPoint) mapPosition;

@property BOOL multiConnect;
@property BOOL realInput;
@property BOOL boolStatus;

@property(weak) Wire* inWire;
@property(weak) Gates* ownerGate;
@end
