//
//  Port.m
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "Port.h"

@implementation Port
-(id)initWithPosition:(CGPoint)pos andStatusOfMultiConnection:(BOOL)multiConn andOwner:(Gates*)newOwner{
    if (self = [super init]) {
        self.boolStatus = NO;
        self.realInput = NO;
        self.wireConnectable = YES;
        self.killWire = NO;
        self.multiConnect = multiConn;
        self.position = pos;
        self.ownerGate = newOwner;
        self.inWire = nil;
    }
    return self;
}

-(CGPoint)mapPosition{
    return CGPointMake(self.position.x+self.ownerGate.position.x,self.position.y+self.ownerGate.position.y);
}

-(void)killAllWire{
    self.killWire = YES;
    self.killWire = NO;
}

-(BOOL)isAbleToConnect{
    if (!self.wireConnectable) {
        return NO;
    }
    if (self.multiConnect) {
        return YES;
    }else{
        if (self.inWire){
            return NO;
        }else{
            return YES;
        }
    }
}

-(void)willRemoveWire{
    if (!self.multiConnect) {
        self.boolStatus = NO;
        self.realInput = NO;
        self.inWire = nil;
    }
}

-(void)finishedConnectProcess{
    if (!self.multiConnect){
        self.boolStatus = self.inWire.boolStatus;
        self.realInput = self.inWire.realInput;

        [self.ownerGate updateRealIntput];
        [self.ownerGate updateOutput];
    }
}

-(void)connectToWire:(Wire *)newWire{
    if (newWire) {
        if (!self.multiConnect){
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
        [delegatesArray compact]
        for id<PortDelegate> pointer in delegatesArray{
            [pointer portBoolStatusDidChange];
        }

    }
}

-(void) setRealInput:(BOOL)value{
    if(_realInput != value){
        _realInput = value;
        [delegatesArray compact]
        for id<PortDelegate> pointer in delegatesArray{
            [pointer portRealInputDidChange];
        }

    }
}

-(void) addDelegate:(id<PortDelegate>)delegate{
    [delegatesArray addPointer:delegate];
}

-(void) removeDelegate:(id<PortDelegate>)delegate{
    for(NSUInterger i = 0;i++;i<[delegatesArray count]){
        if [delegate isEqual:[delegatesArray pointerAtIndex:i]]{
            [delegatesArray removePointerAtIndex:i];
        }
    }
}


@end
