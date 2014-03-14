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
#import "ButtonSprite.h"
@class SaveLoadSprite;
@protocol SaveLoadSpriteProtocol

-(void)setToNil;

@end
@interface SaveLoadSprite : SKSpriteNode<UIAlertViewDelegate>
-(id)initWithMap:(CircuitMap *)map ScreenSize:(CGSize)screenS Delegate:(id)delegate;
-(void)touchNodeAtPoint:(CGPoint)point;
@property(weak) id<SaveLoadSpriteProtocol> delegate;
@property(weak) CircuitMap *map;
@property(weak) ButtonSprite *buttonOut;
@end
