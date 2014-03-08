//
//  CircuitMap.m
//  Logic Gates
//
//  Created by edguo on 3/5/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "CircuitMap.h"
#import "Gates.h"

#define minZoomOut 0.25
@implementation CircuitMap{
    CGFloat maxPosX,maxPosY,minPosX,minPosY;
    CGFloat currentScale;
}

-(id)initMapWithScene:(SKScene*)newScene{
    if (self = [super init]) {
        self.currentScene = newScene;
        [self setScale:1.0];
        self.dataMgr = [[DataManger alloc] init];
    }
    return self;
}

-(void)updateBound{
    CGSize halfScene = CGSizeMake(self.currentScene.size.width/2, self.currentScene.size.height/2);
    maxPosX = (halfScene.width*currentScale)/minZoomOut;
    minPosX = halfScene.width*2.0 - maxPosX;
    
    maxPosY = (halfScene.height*currentScale)/minZoomOut;
    minPosY = halfScene.height*2.0 - maxPosY;
}

-(void)setPosition:(CGPoint)position{
    [super setPosition:[self boundPosition:position]];
}

-(void)moveByPoint:(CGPoint)point{
    self.position = CGPointMake(self.position.x+point.x, self.position.y+point.y);
}

-(CGPoint)boundPosition:(CGPoint)point{
    point.x = MIN(maxPosX, point.x);
    point.x = MAX(minPosX, point.x);
    
    point.y = MIN(maxPosY, point.y);
    point.y = MAX(minPosY, point.y);
    return point;
}

-(void)saveMap{
    const NSArray* nodeArray = [self children];
    NSMutableArray* saveArray = [NSMutableArray arrayWithCapacity:[nodeArray count]];
    for (int j = 0;j < [nodeArray count];j++) {
        Gates*node = [nodeArray objectAtIndex:j];
        NSMutableArray* inArray = [NSMutableArray arrayWithCapacity:[node.inPort count]];
        for (int i = 0;i < [node.inPort count];i++){
            Port* inPort = [node.inPort objectAtIndex:i];
            NSNumber* gateIndex;
            NSNumber* portIndex;
            if (inPort.inWire) {
                gateIndex = [NSNumber numberWithInteger:
                                       [nodeArray indexOfObject:inPort.inWire.startGate]];
                portIndex = [NSNumber numberWithInteger:
                                       [inPort.inWire.startGate.outPort indexOfObject:inPort.inWire.startPort]];
            }else{
                gateIndex = [NSNumber numberWithInteger:-1];
                portIndex = [NSNumber numberWithInteger:-1];
            }
            NSArray* connectArray = [NSArray arrayWithObjects:gateIndex,portIndex, nil];
            [inArray setObject:connectArray atIndexedSubscript:i];
        }
        
        NSNumber* type = [NSNumber numberWithInt:node.gateType];
        NSNumber* posX = [NSNumber numberWithDouble:node.position.x];
        NSNumber* posY = [NSNumber numberWithDouble:node.position.y];
        NSNumber* status = [NSNumber numberWithBool:NO];
        if ([type isEqualToNumber:[NSNumber numberWithInt:8]]) {
            Port* outPort1 = [node.outPort objectAtIndex:0];
            status = [NSNumber numberWithBool:outPort1.boolStatus];
        }
        NSArray*  gateSaveArray = [NSArray arrayWithObjects:type,posX,posY,status,inArray, nil];
        [saveArray setObject:gateSaveArray atIndexedSubscript:j];
    }
    [self.dataMgr saveMap:@"NONE" NodeArray:saveArray];
    
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
