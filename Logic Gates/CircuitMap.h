//
//  CircuitMap.h
//  Logic Gates
//
//  Created by edguo on 3/5/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DataManger.h"

#import "AND_Gate.h"
#import "OR_Gate.h"
#import "XOR_Gate.h"
#import "NOT_Gate.h"

#import "NAND_Gate.h"
#import "NOR_Gate.h"
#import "XNOR_Gate.h"

#import "LightBulb.h"
#import "Switch.h"

@class DataManger;
@interface CircuitMap : SKNode
-(id)initMapWithScene:(SKScene*)newScene;
-(void)moveByPoint:(CGPoint)point;
-(void)saveMap;
-(void)readMap;

@property(weak) SKScene* currentScene;
@property DataManger* dataMgr;
@end
