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
        [self addChild:a];
        
        AND_Gate* b = [[AND_Gate alloc]initGate];
        b.position = CGPointMake(300, 200);
        [self addChild:b];
        
        Port*p1 = (Port*)[a.inPort objectAtIndex:0];
        Wire* w = [[Wire alloc]initWithAnyPort:p1];
        Port*p2 = (Port*)[b.outPort objectAtIndex:0];
        [w connectNewPort:p2];
        [self addChild:w];
        SKAction *ac1 = [SKAction performSelector:@selector(drawLine) onTarget:w];
        SKAction *ac2 = [SKAction repeatAction:ac1 count:2];
        [w runAction:ac2];
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //Called when a touch begins
    UITouch* touch = [touches anyObject];
    SKNode* node = [self nodeAtPoint:[touch locationInNode:self]];
    if ([node isKindOfClass:[Gates class]]) {
        CGPoint locInNode = [touch locationInNode:node];
        Gates*GNode = (Gates*)node;
        Port *inNode = [GNode portInPoint:locInNode];
        if (inNode) {
            self.dragWire = [[Wire alloc]initWithAnyPort:inNode];
            self.dragWire.delegate = self;
            [self addChild:self.dragWire];
        } else{
            self.dragingObject = node;
            lastTouchLocation = [touch locationInNode:self];
        }
    }
    lastTouchLocation = [touch locationInNode:self];
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
    if (self.dragingObject) {
        self.dragingObject = nil;
    }
    if (self.dragWire) {
        [self.dragWire removeFromParent];
        self.dragWire = nil;
    }
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
