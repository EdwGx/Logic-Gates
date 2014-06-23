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
#import "Button.h"

@class Wire;
@class SelectionSprite;
@interface MyScene : SKScene<circuitMapDelegate>{
    CGPoint lastTouchLocation;
    CGPoint dragingObjectStartLocation;
}
-(void)handlePinchFrom:(UIPinchGestureRecognizer*)recognizer;
-(void)handleDoubleTapFrom:(UITapGestureRecognizer*)recognizer;

-(void)moveMenuIn;
-(void)moveMenuOut;

/*
@property (nonatomic) SKNode* dragingObject;
*/
@property (nonatomic) Button* ModeChanger;
@property (nonatomic) Button* selectionMenu;
@property (nonatomic) Button* saveMapButton;

@property (nonatomic) Wire* dragWire;
@property (nonatomic) CircuitMap* map;
@property (nonatomic) SelectionSprite* selectSp;

@end
