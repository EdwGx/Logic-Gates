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
@interface MyScene : SKScene<wireProtocol,circuitMapDelegate>{
    CGPoint lastTouchLocation;
    CGPoint dragingObjectStartLocation;
}
-(void)handlePinchFrom:(UIPinchGestureRecognizer*)recognizer;
-(void)handleDoubleTapFrom:(UITapGestureRecognizer*)recognizer;

-(void)moveMenuIn;
-(void)moveMenuOut;

@property (nonatomic) SKNode* dragingObject;
@property (nonatomic) SKSpriteNode* ModeChanger;
@property (nonatomic) SKSpriteNode* selectionMenu;
@property (nonatomic) SKSpriteNode*saveMapButton;
@property (nonatomic) SKSpriteNode*readMapButton;

@property (nonatomic) Wire* dragWire;
@property (nonatomic) CircuitMap* map;
@property (nonatomic) SelectionSprite* selectSp;

@property (weak, nonatomic) UITapGestureRecognizer* doubleTapRecognizer;
@property (weak, nonatomic) UIPinchGestureRecognizer* zoomRecognizer;

@end
