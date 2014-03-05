//
//  MyScene.h
//  Logic Gates
//

//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Wire.h"
#import "SelectionSprite.h"
#import "Gates.h"
#import "CircuitMap.h"

@class Wire;
@class SelectionSprite;
@interface MyScene : SKScene<wireProtocol>{
    CGPoint lastTouchLocation;
}
-(void)handlePinchFrom:(UIPinchGestureRecognizer*)recognizer;
@property SKNode *dragingObject;
@property Wire* dragWire;
@property SKSpriteNode* ModeChanger;
@property SKSpriteNode* selectionMenu;
@property CircuitMap* map;
@property SelectionSprite* selectSp;
@end
