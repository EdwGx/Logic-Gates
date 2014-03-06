//
//  CircuitMap.h
//  Logic Gates
//
//  Created by edguo on 3/5/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CircuitMap : SKNode
-(id)initMapWithScene:(SKScene*)newScene;
-(void)moveByPoint:(CGPoint)point;

@end
