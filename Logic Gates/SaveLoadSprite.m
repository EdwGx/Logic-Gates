//
//  SaveLoadSprite.m
//  Logic Gates
//
//  Created by edguo on 3/10/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "SaveLoadSprite.h"

@implementation SaveLoadSprite
-(id)initWithDataManger:(DataManger *)dataManger{
    if (self = [super init]) {
        self.dataMgr = dataManger;
    }
    return self;
}
@end
