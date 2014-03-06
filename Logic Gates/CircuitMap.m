//
//  CircuitMap.m
//  Logic Gates
//
//  Created by edguo on 3/5/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "CircuitMap.h"
#define minZoomOut 0.25
@implementation CircuitMap{
    CGFloat maxPosX,maxPosY,minPosX,minPosY;
    CGFloat currentScale;
    SKScene* currentScene;
}

-(id)initMapWithScene:(SKScene*)newScene{
    if (self = [super init]) {
        currentScene = newScene;
        self.position = CGPointMake(currentScene.size.width/2, currentScene.size.height/2);
        [self setScale:1.0];
        
    }
    return self;
}

-(void)updateBound{
    CGSize halfScene = CGSizeMake(currentScene.size.width/2, currentScene.size.height/2);
    maxPosX = (halfScene.width*currentScale)/minZoomOut;
    minPosX = halfScene.width*2.0 - maxPosX;
    
    maxPosY = (halfScene.height*currentScale)/minZoomOut;
    minPosY = halfScene.height*2.0 - maxPosY;
}

-(void)moveByPoint:(CGPoint)point{
    self.position = [self boundPosition:CGPointMake(self.position.x+point.x, self.position.y+point.y)];
}

-(CGPoint)boundPosition:(CGPoint)point{
    point.x = MIN(maxPosX, point.x);
    point.x = MAX(minPosX, point.x);
    
    point.y = MIN(maxPosY, point.y);
    point.y = MAX(minPosY, point.y);
    return point;
}

-(void)setScale:(CGFloat)scale{
    currentScale = scale;
    currentScale = MIN(currentScale, 1.0);
    currentScale = MAX(currentScale, minZoomOut);
    
    [self updateBound];
    self.position = [self boundPosition:self.position];
    [super setScale:currentScale];
}

@end
