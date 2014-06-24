//
//  Gates.m
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "Gates.h"
#define portRange 15

@implementation Gates

-(id)initGate{
    if (self = [super init]) {
        self.gateType = [self getDefultGateTypeValue];
        self.zPosition = 5;
        self.willKill = NO;
        [self initPort];
        [self initImage];
        [self setInPortDelegate];
        [self updateRealIntput];
    }
    return self;
}

-(void)kill{
    for (Port *aPort in self.inPort){
        [aPort removeAllWire];
    }
    for (Port *aPort in self.outPort){
        [aPort removeAllWire];
    }
    [self removeAllActions];
    [self removeFromParent];
}

-(void)setInPortDelegate{
    for (Port* port in self.inPort){
        [port addDelegate:self];
    }
}

-(void)initPort{
    /* Initialization of Ports*/
}

-(void)initImage{
    /* Initialization of Image*/
    self.texture = [SKTexture textureWithImageNamed:[self imageName]];
    self.size = self.texture.size;
}


-(void)updateOutput{
    /*Get the ouput boolean*/
}

-(NSUInteger)getDefultGateTypeValue{
    return 0;
}

-(NSString*)imageName{
    return nil;
}

-(void)updateRealIntput{
    /*Get the real input boolean*/
    BOOL real = YES;

    //Check do all ports have real input
    for (Port* anInPort in self.inPort) {
        if (!anInPort.realInput) {
            real = NO;
            //break;
        }
    }

    if (self.realInput != real || [self isRealInputSource]){
        self.realInput = real || [self isRealInputSource];
        for (Port* anOutPort in self.outPort) {
            anOutPort.realInput = self.realInput;
        }
    }
}

-(BOOL)isRealInputSource{
    return NO;
}


-(BOOL)isPossibleHavePortCloseToPoint:(CGPoint)point{
    float dis = sqrtf(powf((self.position.x - point.x), 2) + powf((self.position.y - point.y), 2));
    float maxRange = portRange + MAX(self.size.height, self.size.width)/2;
    return (dis <= maxRange);
}

-(Port*)portCloseToPointInScene:(CGPoint)point Range:(float)range{
    float shortest = powf((portRange*range),2);
    Port* sPort = nil;

    for (int i=0; i < [self.inPort count]; i++) {
        Port* cPort = [self.inPort objectAtIndex:i];
        float dis = powf((cPort.position.x + self.position.x - point.x), 2) + powf((cPort.position.y + self.position.y - point.y), 2);
        if (dis < shortest) {
            shortest = dis;
            sPort = cPort;
        }
    }

    for (int i=0; i < [self.outPort count]; i++) {
        Port* cPort = [self.outPort objectAtIndex:i];
        float dis = powf((cPort.position.x + self.position.x - point.x), 2) + powf((cPort.position.y + self.position.y - point.y), 2);
        if (dis < shortest) {
            shortest = dis;
            sPort = cPort;
        }
    }

    return sPort;

}

-(void)setPosition:(CGPoint)position{
    [super setPosition:position];
    for (Port *aPort in self.inPort){
        [aPort gatePositionDidChange];
    }
    for (Port *aPort in self.outPort){
        [aPort gatePositionDidChange];
    }
}

-(void)portRealInputDidChange:(PortType)portType{
    if (portType == InputPortType) {
        [self performSelectorInBackground:@selector(updateRealIntput) withObject:nil];
    }
}

-(void)portBoolStatusDidChange:(PortType)portType{
    if (portType == InputPortType) {
        [self performSelectorInBackground:@selector(updateOutput) withObject:nil];
    }
}

-(void)updatePortPositonInDurtion:(NSTimeInterval)duration{
    SKAction* update = [SKAction customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        for (Port *aPort in self.inPort){
            [aPort gatePositionDidChange];
        }
        for (Port *aPort in self.outPort){
            [aPort gatePositionDidChange];
        }
    }];
    [self runAction:update];
}

-(NSString*)gateName{
    return @"GATE";
}

-(NSString*)booleanFormula{
    return @"DEFULT_GATE";
}
@end
