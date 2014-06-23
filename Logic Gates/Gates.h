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

-(void)touchEndedInGate:(CGPoint)point;
-(void)touchBeganInGate:(CGPoint)point;

-(void)updatePortPositonInDurtion:(NSTimeInterval)duration;

@property (nonatomic) int8_t gateType;
@property (nonatomic) BOOL realInput;
@property (nonatomic) BOOL willKill;
@property (nonatomic) NSArray* inPort;
@property (nonatomic) NSArray* outPort;
@end
