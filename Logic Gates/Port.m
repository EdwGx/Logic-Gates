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
        registeredObserver = NO;
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
        if (registeredObserver) {
            [self.inWire removeObserver:self forKeyPath:@"boolStatus"];
            [self.inWire removeObserver:self forKeyPath:@"realInput"];
            registeredObserver = NO;
        }
        self.boolStatus = NO;
        self.realInput = NO;
        self.inWire = nil;
    }
}

-(void)finishedConnectProcess{
    if (!self.multiConnect){
        [self.inWire addObserver:self forKeyPath:@"boolStatus" options:0 context:nil];
        [self.inWire addObserver:self forKeyPath:@"realInput" options:0 context:nil];
        registeredObserver = YES;
        
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([@"boolStatus" isEqualToString:keyPath]) {
        self.boolStatus = self.inWire.boolStatus;
    }
    if ([@"realInput" isEqualToString:keyPath]) {
        self.realInput = self.inWire.realInput;
    }
}

-(void)dealloc{
    if (registeredObserver) {
        [self.inWire removeObserver:self forKeyPath:@"boolStatus"];
        [self.inWire removeObserver:self forKeyPath:@"realInput"];
    }
}

@end
