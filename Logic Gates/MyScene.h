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
#import "SaveLoadSprite.h"

@class Wire;
@class SelectionSprite;
@interface MyScene : SKScene<wireProtocol,SaveLoadSpriteProtocol>{
    CGPoint lastTouchLocation;
}
-(void)handlePinchFrom:(UIPinchGestureRecognizer*)recognizer;
-(void)handleDoubleTapFrom:(UITapGestureRecognizer*)recognizer;

-(void)moveMenuIn;
-(void)moveMenuOut;
@property SKNode *dragingObject;
@property Wire* dragWire;
@property SKSpriteNode* ModeChanger;
@property SKSpriteNode* selectionMenu;
@property CircuitMap* map;
@property SKSpriteNode*saveMapButton;
@property SKSpriteNode*readMapButton;
@property SelectionSprite* selectSp;
@property SaveLoadSprite* slSprite;

@end
