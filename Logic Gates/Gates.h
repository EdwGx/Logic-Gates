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
@interface Gates : SKSpriteNode

-(void)initPort;
-(void)initImage;
-(void)updateOutput;
-(void)addObserserToInPort;
-(void)updateRealIntput;
-(void)kill;

-(BOOL)touchDownWithPointInNode:(CGPoint)point;
-(void)touchUpWithPointInNode:(CGPoint)point;

-(id)initGate;
-(NSString*)imageName;
-(int8_t)getDefultGateTypeValue;
-(BOOL)isRealInputSource;
-(Port*)portInPoint:(CGPoint)point;

@property int8_t gateType;
@property BOOL realInput;
@property BOOL willKill;
@property(strong) NSArray* inPort;
@property(strong) NSArray* outPort;
@end
