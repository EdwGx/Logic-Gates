//
//  MapFileScene.h
//  Logic Gates
//
//  Created by edguo on 2014-03-21.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CircuitMap.h"

@interface MapFileScene : SKScene

-(id)initWithSize:(CGSize)size MainScene:(SKScene*)mainScene Map:(CircuitMap*)map;

@property SKSpriteNode* backButton;
@property SKSpriteNode* addButton;

@property(weak) UISwipeGestureRecognizer* swipeRecognizer;
@property(weak) UITapGestureRecognizer* tapRecognizer;
@end
