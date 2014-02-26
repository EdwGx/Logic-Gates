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
        
        Port* p = [a.inPort objectAtIndex:0];
        CGPoint po = [p mapPosition];
        NSLog(@"%f,%f",po.x,po.y);
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //Called when a touch begins
    
    for (UITouch *touch in touches) {
        SKNode* node = [self nodeAtPoint:[touch locationInNode:self]];
        if ([node isKindOfClass:[Gates class]]) {
            CGPoint locInNode = [touch locationInNode:node];
            NSLog(@"%f,%f",locInNode.x,locInNode.y);
            Gates*GNode = (Gates*)node;
            Port *inNode = [GNode portInPoint:locInNode];
            if (inNode) {
                NSLog(@"YES");
            } else{
                self.dragingObject = node;
                lastTouchLocation = [touch locationInNode:self];
            }
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
        lastTouchLocation = newTouchLocation;

    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.dragingObject) {
        self.dragingObject = nil;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
