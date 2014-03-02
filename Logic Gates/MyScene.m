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

#import "Gates.h"
#import "Port.h"

@implementation MyScene{
    BOOL killMode;
    BOOL changingKillMode;
    BOOL menuMoving;
    BOOL menuOut;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        
        killMode = false;
        changingKillMode = false;
        self.ModeChanger = [SKSpriteNode spriteNodeWithImageNamed:@"ModeImage"];
        self.ModeChanger.zPosition = 10;
        self.ModeChanger.position = CGPointMake(size.width-30, size.height-50);
        SKAction *action1 = [SKAction rotateToAngle:0.25*M_PI duration:0];
        [self.ModeChanger runAction:action1];
        [self addChild:self.ModeChanger];
        
        self.selectionMenu = [SKSpriteNode spriteNodeWithImageNamed:@"menuArrow"];
        self.selectionMenu.zPosition = 16;
        self.selectionMenu.position = CGPointMake(0, size.height/2);
        [self addChild:self.selectionMenu];
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //Called when a touch begins
    UITouch* touch = [touches anyObject];
    lastTouchLocation = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:lastTouchLocation];
    if ([node isKindOfClass:[Gates class]]) {
        CGPoint locInNode = [touch locationInNode:node];
        Gates*GNode = (Gates*)node;
        Port *inNode = [GNode portInPoint:locInNode];
        if (inNode) {
            if (killMode) {
                [inNode killAllWire];
            } else {
                if ([inNode isAbleToConnect]) {
                    self.dragWire = [[Wire alloc]initWithAnyPort:inNode andStartPosition:lastTouchLocation];
                    self.dragWire.delegate = self;
                    [self addChild:self.dragWire];
                }
            }
        } else{
            if (killMode) {
                [GNode kill];
            } else {
                [GNode touchDownWithPointInNode:locInNode];
                self.dragingObject = GNode;
            }
        }
    } else if ([node isEqual:self.ModeChanger]){
        if (!changingKillMode) {
            killMode = !killMode;
            [self.ModeChanger runAction:[SKAction rotateByAngle:1.75*M_PI duration:0.5]completion:^{
                changingKillMode = false;}];
        }
    } else if ([node isEqual:self.selectionMenu]){
        if (!menuMoving) {
            if (menuOut) {
                menuMoving = true;
                SKAction *action = [SKAction moveByX:-self.size.width+20 y:0 duration:0.5];
                SKAction *remove = [SKAction removeFromParent];
                SKAction *maction = [SKAction sequence:@[action,remove]];
                SKAction *spin = [SKAction rotateByAngle:-M_PI duration:0.5];
                [self.selectSp runAction:maction completion:^{
                    self.selectSp = nil;
                }];
                [self.selectionMenu runAction:spin];
                [self.selectionMenu runAction:action completion:^{
                    menuMoving = false;
                    menuOut = false;
                }];
            }else{
                menuMoving = true;
                self.selectSp = [[SelectionSprite alloc]initWithScene:self Size:self.size];
                self.selectSp.zPosition = 15;
                SKAction *action = [SKAction moveByX:self.size.width-20 y:0 duration:0.5];
                SKAction *spin = [SKAction rotateByAngle:M_PI duration:0.5];
                [self addChild:self.selectSp];
                [self.selectSp runAction:action];
                [self.selectionMenu runAction:spin];
                [self.selectionMenu runAction:action completion:^{
                    menuMoving = false;
                    menuOut = true;
                }];
            }
        }
    }else if (self.selectSp && !menuMoving) {
        CGPoint location = [touch locationInNode:self];
        SKNode* node = [self nodeAtPoint:location];
        if (node) {
            if ([[node parent]isEqual:self.selectSp]){
                int8_t type = [self.selectSp getTouchGateTypeWithName:node.name];
                if (type != 0) {
                    node.alpha = 0.0;
                    [self createNewGate:type Position:lastTouchLocation];
                }
            }
        }
    }
    
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
        newGate.position = point;
        [self addChild:newGate];
        self.dragingObject = newGate;
        
        SKAction* back = [SKAction runBlock:^{
            self.selectionMenu.position = CGPointMake(-30, self.size.height/2);
        }];
        SKAction* spin = [SKAction rotateToAngle:0 duration:0.2];
        SKAction* showUp = [SKAction moveToX:0 duration:0.2];
        SKAction* allActions = [SKAction sequence:@[back,spin,showUp]];
        
        menuMoving = true;
        [self.selectionMenu runAction:allActions completion:^{
            menuOut = false;
            menuMoving = false;
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
    }
    lastTouchLocation = newTouchLocation;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    /*
    if (self.selectSp && !menuMoving) {
        CGPoint location = [touch locationInNode:self];
        SKNode* node = [self nodeAtPoint:location];
        if (node) {
            if ([[node parent]isEqual:self.selectSp]){
                int8_t type = [self.selectSp getTouchGateTypeWithName:node.name];
                if (type != 0) {
                    node.alpha = 0.0;
                    [self createNewGate:type Position:lastTouchLocation];
                }
            }
        }
    }*/
    if (self.dragingObject) {
        self.dragingObject = nil;
    }
    if (self.dragWire) {
        [self dragWireEndWithLocation:touch];
        self.dragWire = nil;
    }
}

-(void)dragWireEndWithLocation:(UITouch*)touch{
    SKNode* node = [self nodeAtPoint:[touch locationInNode:self]];
    if ([node isKindOfClass:[Gates class]]) {
        CGPoint locInNode = [touch locationInNode:node];
        Gates*GNode = (Gates*)node;
        Port *inNode = [GNode portInPoint:locInNode];
        if (inNode) {
            //Check that Port can connect one more wire.
            if ([inNode isAbleToConnect]) {
                [self.dragWire connectNewPort:inNode];
                return;
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
}

-(CGPoint)getDragingPosition{
    return lastTouchLocation;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
