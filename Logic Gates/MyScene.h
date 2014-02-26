//
//  MyScene.h
//  Logic Gates
//

//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene{
    CGPoint lastTouchLocation;
}

@property(weak) SKNode *dragingObject;
@end
