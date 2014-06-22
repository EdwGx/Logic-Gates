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
#import "PortDelegate.h"


@class Port;
@class Gates;
@class Wire;

@interface Port : NSObject{
    NSMutableSet* delegatesSet;
}

-(id)initWithPosition:(CGPoint)pos andPortType:(PortType)type andOwner:(Gates*)newOwner;
-(void) connectToWire:(Wire*)newWire;
-(void) finishedConnectProcess;
-(void) inWireWillRemove;
-(void) removeAllWire;

-(void) gatePositionDidChange;
-(void) inWireBoolStatusDidChange;
-(void) inWireRealInputDidChange;

-(void) addDelegate:(id<PortDelegate>)delegate;
-(void) removeDelegate:(id<PortDelegate>)delegate;

-(CGPoint) mapPosition;
-(BOOL)isAbleToConnect;

@property (nonatomic) PortType type;
@property (nonatomic) BOOL realInput;
@property (nonatomic) BOOL boolStatus;
@property (nonatomic) BOOL wireConnectable;

@property (nonatomic,weak) Gates* ownerGate;
@property (nonatomic,weak) Wire* inWire;

@property (nonatomic) CGPoint position;
@end
