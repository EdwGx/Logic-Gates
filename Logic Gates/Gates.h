//
//  Gates.h
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Gates : SKSpriteNode{
    BOOL outStatus;    
}
-(void)initPort;
-(void)initImage;
@property int8_t gateType;
@property(strong) NSArray* inPort;
@property(strong) NSArray* outPort;
@end
