//
//  Port.m
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "Port.h"

@implementation Port
-(id)initWithPosition:(struct CGPoint)pos andStatusOfMultiConnection:(BOOL)multiConn{
    if (self = [super init]) {
        boolStatus = false;
        realInput = false;
        wireConnectable = false;
        multi = multiConn;
        self.position = pos;
    }
    return self;
}
@end
