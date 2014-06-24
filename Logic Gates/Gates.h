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

typedef NS_ENUM(NSUInteger, GateType) {
    GateTypeDefult,
    GateTypeAND,
    GateTypeOR,
    GateTypeXOR,
    GateTypeNAND,
    GateTypeNOR,
    GateTypeXNOR,
    GateTypeNOT,
    GateTypeSwitch,
    GateTypeLightBulb,
};

@class Port;

@interface Gates : SKSpriteNode <PortDelegate>

-(void)initPort;
-(void)initImage;
-(void)updateOutput;
-(void)updateRealIntput;
-(void)kill;

-(id)initGate;
-(NSString*)imageName;
-(GateType)getDefultGateType;
-(BOOL)isRealInputSource;
-(Port*)portCloseToPointInScene:(CGPoint)point Range:(float)range;
-(BOOL)isPossibleHavePortCloseToPoint:(CGPoint)point;

-(void)updatePortPositonInDurtion:(NSTimeInterval)duration;

-(NSString*)gateName;
-(NSString*)booleanFormula;

@property (nonatomic) GateType gateType;
@property (nonatomic) BOOL realInput;
@property (nonatomic) BOOL willKill;
@property (nonatomic) NSArray* inPort;
@property (nonatomic) NSArray* outPort;
@end
