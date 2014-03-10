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
    NSMutableArray* nodeArray = [NSMutableArray arrayWithArray:[self children]];
    for (int k = 0; k < [nodeArray count]; k++) {
        if (![[nodeArray objectAtIndex:k] isKindOfClass:[Gates class]]) {
            [nodeArray removeObjectAtIndex:k];
        }
    }
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

-(void)readMap{
    for (Gates*gate in [self children]) {
        [gate kill];
    }
    NSArray*array = [self.dataMgr readMap:@"NONE"];
    if (!array) {
        return;
    }
    NSMutableArray*newGatesArray = [NSMutableArray arrayWithCapacity:[array count]];
    //Create Gates
    for (int i = 0;i<[array count];i++) {
        NSArray*subArray = [array objectAtIndex:i];
        //Fetching Type
        NSNumber*type = [subArray objectAtIndex:0];
        Gates*newGate = [self makeGateWithType:[type intValue]];
        //X
        NSNumber* numX = [subArray objectAtIndex:1];
        CGFloat posX = [numX doubleValue];
        //Y
        NSNumber* numY = [subArray objectAtIndex:2];
        CGFloat posY = [numY doubleValue];
        //Setting Location
        newGate.position = CGPointMake(posX, posY);
        //Setting output
        NSNumber* status = [subArray objectAtIndex:3];
        if ([status isEqualToNumber:[NSNumber numberWithBool:YES]]&&[type isEqualToNumber:[NSNumber numberWithInt:8]]) {
            Port* outPort1 = [newGate.inPort objectAtIndex:0];
            outPort1.boolStatus = [status boolValue];
        }
        [self addChild:newGate];
        [newGatesArray setObject:newGate atIndexedSubscript:i];
    }
    for (int i = 0;i<[array count];i++) {
        NSArray*subArray = [array objectAtIndex:i];
        NSArray*inArray = [subArray objectAtIndex:4];
        for (int j = 0;j<[inArray count];j++) {
            NSArray*indexArray = [inArray objectAtIndex:j];
            NSNumber* gateIndexNum = [indexArray objectAtIndex:0];
            NSNumber* portIndexNum = [indexArray objectAtIndex:1];
            int gateIndex = [gateIndexNum intValue];
            int portIndex = [portIndexNum intValue];
            if (gateIndex>=0 && portIndex>=0) {
                Gates* sGate = [newGatesArray objectAtIndex:gateIndex];
                Port* sPort = [sGate.outPort objectAtIndex:portIndex];
                
                Gates* eGate = [newGatesArray objectAtIndex:i];
                Port* ePort = [eGate.outPort objectAtIndex:j];
                
                Wire* newWire = [[Wire alloc]initWithStartPort:sPort EndPort:ePort];
                [self addChild:newWire];
            }
            
        }
    }
}

-(Gates*)makeGateWithType:(int)type{
    switch (type) {
        case 1:
            return  [[AND_Gate alloc]initGate];
            break;
            
        case 2:
            return [[OR_Gate alloc]initGate];
            break;
            
        case 3:
            return [[XOR_Gate alloc]initGate];
            break;
            
        case 4:
            return [[NAND_Gate alloc]initGate];
            break;
            
        case 5:
            return [[NOR_Gate alloc]initGate];
            break;
            
        case 6:
            return [[XNOR_Gate alloc]initGate];
            break;
            
        case 7:
            return [[NOT_Gate alloc]initGate];
            break;
            
        case 8:
            return [[Switch alloc]initGate];
            break;
            
        case 9:
            return [[LightBulb alloc]initGate];
            break;
            
        default:
            return nil;
            break;
    }
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