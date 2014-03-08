//
//  CircuitMap.h
//  Logic Gates
//
//  Created by edguo on 3/5/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DataManger.h"

@class DataManger;
@interface CircuitMap : SKNode
-(id)initMapWithScene:(SKScene*)newScene;
-(void)moveByPoint:(CGPoint)point;
-(void)saveMap;

@property(weak) SKScene* currentScene;
@property DataManger* dataMgr;
@end
