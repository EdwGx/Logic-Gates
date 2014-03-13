//
//  SaveLoadSprite.h
//  Logic Gates
//
//  Created by edguo on 3/10/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DataManger.h"
#import "CircuitMap.h"

@interface SaveLoadSprite : SKSpriteNode<UIAlertViewDelegate>
-(id)initWithMap:(CircuitMap *)map ScreenSize:(CGSize)screenS;
-(void)touchNodeAtPoint:(CGPoint)point;
@property(weak) CircuitMap *map;
@end
