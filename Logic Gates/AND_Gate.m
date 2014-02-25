//
//  AND_Gate.m
//  Logic Gates
//
//  Created by edguo on 2/25/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "AND_Gate.h"
#import "Port.h"

@implementation AND_Gate
-(void)initPort{
    Port *inP1 = [[Port alloc]initWithPosition:CGPointMake(6, 12) andStatusOfMultiConnection:false andOwner:self];
    Port *inP2 = [[Port alloc]initWithPosition:CGPointMake(6, 28) andStatusOfMultiConnection:true andOwner:self];
    self.inPort = [NSArray arrayWithObjects:inP1,inP2, nil];
    
    Port *outP1 = [[Port alloc]initWithPosition:CGPointMake(74, 20) andStatusOfMultiConnection:true andOwner:self];
    self.outPort = [NSArray arrayWithObject:outP1];
    
    [self addChild:inP1];
    [self addChild:inP2];
    [self addChild:outP1];
}
-(void)initImage{
    self.texture = [SKTexture textureWithImageNamed:@"Gates/Logic Gates/Image/and_gate.png"];
}
@end
