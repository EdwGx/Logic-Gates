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
        self.boolStatus = false;
        self.realInput = false;
        wireConnectable = false;
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

-(void)connectToWire:(Wire *)newWire{
    if (newWire) {
        if (!self.multiConnect){
            self.inWire = newWire;
            [self.inWire addObserver:self forKeyPath:@"boolStatus" options:0 context:nil];
            [self.inWire addObserver:self forKeyPath:@"realInput" options:0 context:nil];
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
    [self.inWire removeObserver:self forKeyPath:@"boolStatus"];
    [self.inWire removeObserver:self forKeyPath:@"realInput"];
}

@end
