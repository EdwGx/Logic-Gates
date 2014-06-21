//
//  Gates.h
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PortDelegate.h"
#import "Port.h"

@class Port;

@interface Gates : SKSpriteNode <PortDelegate>

-(void)initPort;
-(void)initImage;
-(void)updateOutput;
-(void)updateRealIntput;
-(void)kill;

-(id)initGate;
-(NSString*)imageName;
-(int8_t)getDefultGateTypeValue;
-(BOOL)isRealInputSource;
-(Port*)portCloseToPointInScene:(CGPoint)point Range:(float)range;
-(BOOL)isPossibleHavePortCloseToPoint:(CGPoint)point;

-(void)touchEndedInGate:(UITouch*)touch;
-(void)touchBeganInGate:(UITouch*)touch;

@property int8_t gateType;
@property BOOL realInput;
@property BOOL willKill;
@property(strong) NSArray* inPort;
@property(strong) NSArray* outPort;
@end
