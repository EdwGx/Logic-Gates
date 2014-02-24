//
//  Wire.h
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class Port;
@interface Wire : SKShapeNode{
    BOOL realInput;
}
-(id) initWithStartPort:(Port*)sPort andEndPort:(Port*)ePort;
@property(weak) Port *startPort;
@property(weak) Port *endPort;

@end
