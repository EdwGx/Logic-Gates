//
//  Gates.h
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Port.h"

@class Port;
@interface Gates : SKSpriteNode{
    BOOL outStatus;
}

-(void)initPort;
-(void)initImage;
-(void)updateOutput;
-(void)addObserserToInPort;
-(id)initGate;
-(NSString*)imageName;
-(int8_t)getDefultGateTypeValue;
-(Port*)portInPoint:(CGPoint)point;

@property int8_t gateType;
@property(strong) NSArray* inPort;
@property(strong) NSArray* outPort;
@end
