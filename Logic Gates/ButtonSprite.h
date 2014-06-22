//
//  ButtonSprite.h
//  Logic Gates
//
//  Created by edguo on 3/10/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ButtonSprite : SKSpriteNode
-(id)initWithName:(NSString*)name buttonID:(NSUInteger)number;
+(instancetype)buttonWithName:(NSString*)name buttonID:(NSUInteger)number;
@property (nonatomic) NSUInteger button_id;
@end
