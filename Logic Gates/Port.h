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
@interface Port : NSObject{
    BOOL registeredObserver;
}
-(id)initWithPosition:(CGPoint)pos andStatusOfMultiConnection:(BOOL)multiConn andOwner:(Gates*)newOwner;
-(void) connectToWire:(Wire*)newWire;
-(void) finishedConnectProcess;
-(void)willRemoveWire;
-(CGPoint) mapPosition;
-(BOOL)isAbleToConnect;

@property BOOL multiConnect;
@property BOOL realInput;
@property BOOL boolStatus;
@property BOOL wireConnectable;

@property(weak) Wire* inWire;
@property(weak) Gates* ownerGate;
@property CGPoint position;
@end
