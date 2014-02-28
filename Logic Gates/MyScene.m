//
//  MyScene.m
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "MyScene.h"
#import "AND_Gate.h"
#import "Gates.h"
#import "Port.h"


@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        AND_Gate* a = [[AND_Gate alloc]initGate];
        a.position = CGPointMake(100, 100);
        a.alpha = 0.2;
        [self addChild:a];
        
        AND_Gate* b = [[AND_Gate alloc]initGate];
        b.position = CGPointMake(300, 200);
        b.alpha = 0.2;
        [self addChild:b];

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
            if ([inNode isAbleToConnect]) {
                self.dragWire = [[Wire alloc]initWithAnyPort:inNode];
                self.dragWire.delegate = self;
                [self addChild:self.dragWire];
            }
        } else{
            self.dragingObject = node;
        }
    }
    
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (self.dragingObject) {
        CGPoint newTouchLocation = [touch locationInNode:self];
        self.dragingObject.position = CGPointMake(
              self.dragingObject.position.x + newTouchLocation.x - lastTouchLocation.x,
              self.dragingObject.position.y + newTouchLocation.y - lastTouchLocation.y);
    } else if (self.dragWire){
        [self.dragWire drawLine];
    }
    lastTouchLocation = [touch locationInNode:self];
    
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
