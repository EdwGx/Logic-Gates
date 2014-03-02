//
//  SelectionSprite.h
//  Logic Gates
//
//  Created by edguo on 3/1/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SelectionSprite : SKSpriteNode
-(id)initWithScene:(SKScene*)scene Size:(CGSize)size;
-(int8_t)getTouchGateTypeWithName:(NSString*)name;

@property NSArray* typeArray;
@property(weak) SKScene* mainScene;
@end
