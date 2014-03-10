//
//  MyScene.m
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "MyScene.h"

#import "AND_Gate.h"
#import "OR_Gate.h"
#import "XOR_Gate.h"
#import "NOT_Gate.h"

#import "NAND_Gate.h"
#import "NOR_Gate.h"
#import "XNOR_Gate.h"

#import "LightBulb.h"
#import "Switch.h"

#import "Port.h"

@implementation MyScene{
    BOOL killMode;
    BOOL changingKillMode;
    BOOL menuMoving;
    BOOL menuOut;
    BOOL dragMap;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        
        killMode = NO;
        changingKillMode = NO;
        self.ModeChanger = [SKSpriteNode spriteNodeWithImageNamed:@"ModeImage"];
        self.ModeChanger.zPosition = 10;
        self.ModeChanger.position = CGPointMake(size.width-30, 30);
        SKAction *action1 = [SKAction rotateToAngle:0.25*M_PI duration:0];
        [self.ModeChanger runAction:action1];
        [self addChild:self.ModeChanger];
        
        self.saveMapButton = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.2 green:0.2 blue:1.0 alpha:1.0]
                                                          size:CGSizeMake(30, 30)];
        self.saveMapButton.zPosition = 10;
        self.saveMapButton.position = CGPointMake(size.width-30, size.height-30);
        [self addChild:self.saveMapButton];
        
        self.selectionMenu = [SKSpriteNode spriteNodeWithImageNamed:@"menuArrow"];
        self.selectionMenu.zPosition = 16;
        self.selectionMenu.position = CGPointMake(0, size.height/2);
        [self addChild:self.selectionMenu];
        
        self.map = [[CircuitMap alloc]initMapWithScene:self];
        [self addChild:self.map];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    [super didMoveToView:view];
    UIPinchGestureRecognizer* pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchFrom:)];
    UITapGestureRecognizer* doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTapFrom:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [[self view] addGestureRecognizer:pinchGestureRecognizer];
    [[self view] addGestureRecognizer:doubleTapGestureRecognizer];
}

-(void)handlePinchFrom:(UIPinchGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self.map setScale:recognizer.scale*self.map.xScale];
        recognizer.scale = 1.0;
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //Called when a touch begins
    UITouch* touch = [touches anyObject];
    lastTouchLocation = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:lastTouchLocation];
    if ([node isKindOfClass:[Gates class]]) {
        Gates*GNode = (Gates*)node;
        Port *inNode = [GNode portCloseToPointInScene:[self convertPoint:lastTouchLocation toNode:self.map] Range:0.5];
        if (inNode) {
            if (killMode) {
                [inNode killAllWire];
            } else {
                if ([inNode isAbleToConnect]) {
                    self.dragWire = [[Wire alloc]initWithAnyPort:inNode andStartPosition:[self convertPoint:lastTouchLocation toNode:self.map]];
                    self.dragWire.delegate = self;
                    [self.map addChild:self.dragWire];
                }
            }
        } else{
            if (killMode) {
                [GNode kill];
            } else {
                CGPoint locInNode = [touch locationInNode:node];
                [GNode touchDownWithPointInNode:locInNode];
                self.dragingObject = GNode;
            }
        }
    } else if ([node isEqual:self.ModeChanger]){
        if (!changingKillMode) {
            killMode = !killMode;
            [self.ModeChanger runAction:[SKAction rotateByAngle:1.75*M_PI duration:0.5]completion:^{
                changingKillMode = NO;}];
        }
    } else if ([node isEqual:self.selectionMenu]){
        if (!menuMoving) {
            if (menuOut) {
                [self moveMenuIn];
            }else{
                [self moveMenuOut];
            }
        }
    }else if ([node isEqual:self.saveMapButton]){
        [self.map saveMap];
    }else if (self.selectSp && !menuMoving) {
        CGPoint location = [touch locationInNode:self];
        SKNode* node = [self nodeAtPoint:location];
        if (node) {
            if ([[node parent]isEqual:self.selectSp]){
                int8_t type = [self.selectSp getTouchGateTypeWithName:node.name];
                if (type != 0) {
                    node.alpha = 0.0;
                    CGPoint point = [self convertPoint:node.position fromNode:self.selectSp];
                    [self createNewGate:type Position:point];
                }
            }
        }
    } else if ([self nodeIsEmptySpace:node]){
        //What happend when touch empty space(Actully there are some nodes)
        BOOL returnValue = [self findPortCloseToLocation:[self convertPoint:lastTouchLocation toNode:self.map]];
        if (!returnValue) {
            dragMap = YES;
        }
    }
    
}

-(void)handleDoubleTapFrom:(UITapGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint pointInScene = [self convertPointFromView:[recognizer locationInView:self.view]];
        CGPoint targetPoint = [self convertPoint:pointInScene toNode:self.map];
        CGPoint centerPoint = [self convertPoint:CGPointMake(self.size.width/2.0,self.size.height/2.0) toNode:self.map];
        CGVector vector = CGVectorMake(centerPoint.x - targetPoint.x, centerPoint.y -targetPoint.y);
        
        [self.map runAction:[SKAction moveBy:vector duration:0.2]];
        [self.map runAction:[SKAction scaleTo:1.0 duration:0.2]];
    }
}

-(BOOL) nodeIsEmptySpace:(SKNode*)node{
    return ([node isEqual:self]||[node isKindOfClass:[Wire class]]||[node isEqual:self.map]);
}

-(void)moveMenuIn{
    menuMoving = YES;
    menuOut = NO;
    SKAction *action = [SKAction moveByX:-self.size.width+20 y:0 duration:0.5];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *maction = [SKAction sequence:@[action,remove]];
    SKAction *spin = [SKAction rotateByAngle:-M_PI duration:0.5];
    [self.selectSp runAction:maction completion:^{
        self.selectSp = nil;
    }];
    [self.selectionMenu runAction:spin];
    [self.selectionMenu runAction:action completion:^{
        menuMoving = NO;
    }];
}

-(void)moveMenuOut{
    menuMoving = YES;
    self.selectSp = [[SelectionSprite alloc]initWithScene:self Size:self.size];
    self.selectSp.zPosition = 15;
    SKAction *action = [SKAction moveByX:self.size.width-20 y:0 duration:0.5];
    SKAction *spin = [SKAction rotateByAngle:M_PI duration:0.5];
    [self addChild:self.selectSp];
    [self.selectSp runAction:action];
    [self.selectionMenu runAction:spin];
    [self.selectionMenu runAction:action completion:^{
        menuMoving = NO;
        menuOut = YES;
    }];
}

-(BOOL)findPortCloseToLocation:(CGPoint)point{
    for (SKNode* childNode in [self.map children]) {
        if ([childNode isKindOfClass:[Gates class]]) {
            Gates* gChild = (Gates*)childNode;
            if ([gChild isPossibleHavePortCloseToPoint:point]) {
                Port* cloestPort = [gChild portCloseToPointInScene:point Range:1.0];
                if (cloestPort) {
                    if (killMode) {
                        [cloestPort killAllWire];
                    } else {
                        if ([cloestPort isAbleToConnect]) {
                            self.dragWire = [[Wire alloc]initWithAnyPort:cloestPort andStartPosition:point];
                            self.dragWire.delegate = self;
                            [self.map addChild:self.dragWire];
                        }
                    }
                    return YES;
                }
            }
        }
    }
    return NO;
}


-(void)createNewGate:(int8_t)type Position:(CGPoint)point{
    Gates* newGate;
    switch (type) {
        case 1:
            newGate = [[AND_Gate alloc]initGate];
            break;
            
        case 2:
            newGate = [[OR_Gate alloc]initGate];
            break;
            
        case 3:
            newGate = [[XOR_Gate alloc]initGate];
            break;
            
        case 4:
            newGate = [[NAND_Gate alloc]initGate];
            break;
            
        case 5:
            newGate = [[NOR_Gate alloc]initGate];
            break;
            
        case 6:
            newGate = [[XNOR_Gate alloc]initGate];
            break;
            
        case 7:
            newGate = [[NOT_Gate alloc]initGate];
            break;
            
        case 8:
            newGate = [[Switch alloc]initGate];
            break;
            
        case 9:
            newGate = [[LightBulb alloc]initGate];
            break;
            
        default:
            newGate = nil;
            break;
    }
    if (newGate) {
        newGate.position = [self convertPoint:point toNode:self.map];
        [self.map addChild:newGate];
        self.dragingObject = newGate;
        
        SKAction* back = [SKAction runBlock:^{
            self.selectionMenu.position = CGPointMake(-30, self.size.height/2);
        }];
        SKAction* spin = [SKAction rotateToAngle:0 duration:0.2];
        SKAction* showUp = [SKAction moveToX:0 duration:0.2];
        SKAction* allActions = [SKAction sequence:@[back,spin,showUp]];
        
        menuMoving = YES;
        [self.selectionMenu runAction:allActions completion:^{
            menuOut = NO;
            menuMoving = NO;
        }];
        [self.selectSp removeFromParent];
        self.selectSp = nil;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint newTouchLocation = [touch locationInNode:self];
    if (menuOut&&self.selectSp) {
        CGFloat newY = self.selectSp.position.y + newTouchLocation.y - lastTouchLocation.y;
        newY = MIN(newY, self.selectSp.size.height/2);
        newY = MAX(newY, self.size.height-self.selectSp.size.height/2);
        self.selectSp.position = CGPointMake(self.selectSp.position.x, newY);
    } else if (self.dragingObject) {
        self.dragingObject.position = CGPointMake(
              self.dragingObject.position.x + newTouchLocation.x - lastTouchLocation.x,
              self.dragingObject.position.y + newTouchLocation.y - lastTouchLocation.y);
    } else if (self.dragWire){
        [self.dragWire drawLine];
    } else if (dragMap){
        [self.map moveByPoint:
         CGPointMake(newTouchLocation.x - lastTouchLocation.x, newTouchLocation.y - lastTouchLocation.y)];
    }
    lastTouchLocation = newTouchLocation;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    if (self.dragingObject) {
        self.dragingObject = nil;
    }
    if (self.dragWire) {
        [self dragWireEndWithLocation:touch];
        self.dragWire = nil;
    }
}

-(void)dragWireEndWithLocation:(UITouch*)touch{
    SKNode* node = [self nodeAtPoint:[touch locationInNode:self.map]];
    if ([node isKindOfClass:[Gates class]]) {
        Gates*GNode = (Gates*)node;
        Port *inNode = [GNode portCloseToPointInScene:[touch locationInNode:self.map] Range:1.0];
        if (inNode) {
            //Check that Port can connect one more wire.
            if ([inNode isAbleToConnect]) {
                [self.dragWire connectNewPort:inNode];
                return;
            }
        }
    }else if ([node isEqual:self]||[node isKindOfClass:[Wire class]]||[node isEqual:self.map]){
        for (SKNode* childNode in [self.map children]) {
            if ([childNode isKindOfClass:[Gates class]]) {
                Gates* gChild = (Gates*)childNode;
                CGPoint loc = [self convertPoint:lastTouchLocation toNode:self.map];
                if ([gChild isPossibleHavePortCloseToPoint:loc]) {
                    Port* cloestPort = [gChild portCloseToPointInScene:loc Range:1.0];
                    if ([cloestPort isAbleToConnect]) {
                        [self.dragWire connectNewPort:cloestPort];
                        return;
                    }
                }
            }
        }
    }
    [self.dragWire kill];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.dragingObject) {
        self.dragingObject = nil;
    }
    if (self.dragWire) {
        [self.dragWire removeFromParent];
        self.dragWire = nil;
    }
    if (dragMap) {
        dragMap = NO;
    }
}

-(CGPoint)getDragingPosition{
    return [self convertPoint:lastTouchLocation toNode:self.map];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
