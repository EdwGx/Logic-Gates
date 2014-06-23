//
//  Button.h
//  Logic Gates
//
//  Created by Edward Guo on 2014-06-23.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Button : SKSpriteNode
-(void)setTouchDownTarget:(id)target Action:(SEL)sector;
-(void)removeTouchDownTargetAndAction;
@end
