//
//  MapFileScene.h
//  Logic Gates
//
//  Created by edguo on 2014-03-21.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CircuitMap.h"
#import "ButtonSprite.h"

@interface MapFileScene : SKScene<UIAlertViewDelegate>

-(id)initWithSize:(CGSize)size MainScene:(SKScene*)mainScene Map:(CircuitMap*)map;

@property SKSpriteNode* backButton;
@property SKSpriteNode* addButton;
@property SKNode* buttonMap;

@property(weak) UISwipeGestureRecognizer* swipeRecognizer;
@property(weak) UITapGestureRecognizer* tapRecognizer;
@property(weak) ButtonSprite* selectButton;
@end
