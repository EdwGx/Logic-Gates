//
//  SaveLoadSprite.h
//  Logic Gates
//
//  Created by edguo on 3/10/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DataManger.h"
@interface SaveLoadSprite : SKSpriteNode
-(id)initWithDataManger:(DataManger *)dataManger ScreenHeight:(CGFloat)height;

@property(weak) DataManger *dataMgr;
@end
