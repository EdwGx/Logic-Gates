//
//  Gates.m
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "Gates.h"
#define portRange 2

@implementation Gates

-(id)initGate{
    if (self = [super init]) {
        self.gateType = [self getDefultGateTypeValue];
        self.zPosition = 5.0;
        [self initImage];
        [self initPort];
        [self addObserserToInPort];
    }
    return self;
}

-(void)initPort{
    /* Initialization of Ports*/
}

-(void)initImage{
    /* Initialization of Image*/
    UIImage *image = [UIImage imageNamed:[self imageName]];
    self.texture = [SKTexture textureWithImage:image];
    self.size = [image size];
    self.color = [SKColor whiteColor];
}

-(void)updateOutput{
    /*Get the ouput boolean*/
}

-(int8_t)getDefultGateTypeValue{
    return 0;
}

-(NSString*)imageName{
    return nil;
}

-(void)updateRealIntput{
    /*Get the real input boolean*/
    BOOL real = true;
    
    //Check do all ports have real input
    for (int i = 0; i < [self.inPort count]; i++) {
        Port* portObject = [self.inPort objectAtIndex:i];
        if (!portObject.realInput) {
            real = false;
            break;
        }
    }
    
    real = real || [self isRealInputSource] ;
        
    for (int i = 0; i < [self.inPort count]; i++) {
        Port* portObject = [self.inPort objectAtIndex:i];
        portObject.boolStatus = real;
    }
    
}

-(BOOL)isRealInputSource{
    return false;
}

-(Port*)portInPoint:(CGPoint)point{
    float shortest = portRange;
    Port* sPort = nil;
    
    for (int i=0; i < [self.inPort count]; i++) {
        Port* cPort = [self.inPort objectAtIndex:i];
        float dis = powf((cPort.position.x - point.x), 2) + powf((cPort.position.y - point.y), 2);
        if (dis < shortest) {
            shortest = dis;
            sPort = cPort;
        }
    }
    
    for (int i=0; i < [self.outPort count]; i++) {
        Port* cPort = [self.outPort objectAtIndex:i];
        float dis = powf((cPort.position.x - point.x), 2) + powf((cPort.position.y - point.y), 2);
        if (dis < shortest) {
            shortest = dis;
            sPort = cPort;
        }
    }
    
    return sPort;
    
}

-(void)addObserserToInPort{
    for (NSInteger i = 0; i<[self.inPort count]; i++) {
        if ([self.inPort objectAtIndex:i]) {
            [[self.inPort objectAtIndex:i] addObserver:self forKeyPath:@"boolStatus" options:0 context:nil];
            [[self.inPort objectAtIndex:i] addObserver:self forKeyPath:@"realInput" options:0 context:nil];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"boolStatus"]) {
        [self performSelectorInBackground:@selector(updateOutput) withObject:nil];
    }else if ([keyPath isEqualToString:@"realInput"]){
        [self performSelectorInBackground:@selector(updateRealIntput) withObject:nil];
    }
}

-(void)dealloc{
    for (NSInteger i = 0; i<[self.inPort count]; i++) {
            [[self.inPort objectAtIndex:i] removeObserver:self forKeyPath:@"boolStatus"];
            [[self.inPort objectAtIndex:i] removeObserver:self forKeyPath:@"realInput"];
    }
}


@end
