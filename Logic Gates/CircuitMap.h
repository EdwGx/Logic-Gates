//
//  CircuitMap.h
//  Logic Gates
//
//  Created by edguo on 3/5/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "AND_Gate.h"
#import "OR_Gate.h"
#import "XOR_Gate.h"
#import "NOT_Gate.h"

#import "NAND_Gate.h"
#import "NOR_Gate.h"
#import "XNOR_Gate.h"

#import "LightBulb.h"
#import "Switch.h"

@class CircuitMap;
@protocol circuitMapDelegate<NSObject>
-(CGSize)getScreenSize;
@optional
-(void)fileSystemDidSetup;
@end

@interface CircuitMap : SKNode
-(id)initMapWithDelegate:(id)delegate;
-(void)moveByPoint:(CGPoint)point;
-(void)saveMap:(NSString*)fileName;
-(void)loadMap:(NSString*)fileName;
-(void)removeMapFile:(NSString*)name;

@property(weak) id<circuitMapDelegate> delegate;
@property NSMutableArray* filesList;
@property BOOL isFileSystemWork;
@end
