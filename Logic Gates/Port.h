//
//  Port.h
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Port : SKNode{
    BOOL boolStatus;
    BOOL realInput;
    BOOL wireConnectable;
}
@property NSPointerArray *connectList;
@end
