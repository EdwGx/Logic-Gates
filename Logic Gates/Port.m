//
//  Port.m
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "Port.h"

@implementation Port
-(id)initWithPosition:(CGPoint)pos andPortType:(PortType)type andOwner:(Gates*)newOwner{
    if (self = [super init]) {
        self.boolStatus = NO;
        self.realInput = NO;
        self.wireConnectable = YES;
        self.type = type;
        self.position = pos;
        self.ownerGate = newOwner;
        self.inWire = nil;
        delegatesSet = [NSMutableSet set];
    }
    return self;
}

-(CGPoint)mapPosition{
    return CGPointMake(self.position.x*self.ownerGate.xScale+self.ownerGate.position.x,self.position.y*self.ownerGate.yScale+self.ownerGate.position.y);
}

-(void)removeAllWire{
    for (id<PortDelegate> pointer in delegatesSet){
        if ([pointer respondsToSelector:@selector(portWillRemoveWires)]) {
            [pointer portWillRemoveWires];
        }
    }
}

-(BOOL)isAbleToConnect{
    if (!self.wireConnectable) {
        return NO;
    }
    if (self.type == OutputPortType) {
        return YES;
    }else{
        if (self.inWire){
            return NO;
        }else{
            return YES;
        }
    }
}

-(void)inWireWillRemove{
    self.boolStatus = NO;
    self.realInput = NO;
    self.inWire = nil;
}

-(void)finishedConnectProcess{
    if (self.type == InputPortType){
        self.boolStatus = self.inWire.boolStatus;
        self.realInput = self.inWire.realInput;

        [self.ownerGate updateRealIntput];
        [self.ownerGate updateOutput];
    }
}

-(void)connectToWire:(Wire *)newWire{
    if (newWire) {
        if (self.type == InputPortType){
            self.inWire = newWire;
        }
    }
}

-(void) inWireBoolStatusDidChange{
  self.boolStatus = self.inWire.boolStatus;
}

-(void) inWireRealInputDidChange{
  self.realInput = self.inWire.realInput;
}

-(void) setBoolStatus:(BOOL)value{
    if(_boolStatus != value){
        _boolStatus = value;
        for (id<PortDelegate> pointer in delegatesSet){
            if ([pointer respondsToSelector:@selector(portBoolStatusDidChange:)]) {
                [pointer portBoolStatusDidChange:self.type];
            }
        }

    }
}

-(void) setRealInput:(BOOL)value{
    if(_realInput != value){
        _realInput = value;
        for (id<PortDelegate> pointer in delegatesSet){
            if ([pointer respondsToSelector:@selector(portRealInputDidChange:)]) {
                [pointer portRealInputDidChange:self.type];
            }
        }

    }
}

-(void)gatePositionDidChange{
    for (id<PortDelegate> pointer in delegatesSet){
        if ([pointer respondsToSelector:@selector(portPositionDidChange)]) {
            [pointer portPositionDidChange];
        }
    }
}

-(void) addDelegate:(id<PortDelegate>)delegate{
    [delegatesSet addObject:delegate];
}

-(void) removeDelegate:(id<PortDelegate>)delegate{
    [delegatesSet removeObject:delegate];
}


@end
