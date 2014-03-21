//
//  MapFileScene.m
//  Logic Gates
//
//  Created by edguo on 2014-03-21.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "MapFileScene.h"
#import "CircuitMap.h"
#import "ButtonSprite.h"

@implementation MapFileScene{
    SKScene *mScene;
    CircuitMap* mMap;
}
-(id)initWithSize:(CGSize)size MainScene:(SKScene*)mainScene Map:(CircuitMap*)map{
    if (self = [super initWithSize:size]) {
        mScene = mainScene;
        mMap = map;
        
    }
    return self;
}

-(void)setupButtons{
    CGFloat yPos = self.size.height;
    CGFloat xPos = self.size.width/2;
    CGSize buttonSize = CGSizeMake(self.size.width-20, 36);
    [self removeAllChildren];
    
    yPos -= 25;
    ButtonSprite* button = [[ButtonSprite alloc]initWithName:@"add" buttonID:0];
    button.size = buttonSize;
    button.position = CGPointMake(xPos, yPos);
    [self addChild:button];
    yPos -= 50.0;
    
    for (NSUInteger i = 1; i  < [mMap.filesList count]; i++) {
        NSString* name = [mMap.filesList objectAtIndex:i];
        ButtonSprite* button = [[ButtonSprite alloc]initWithName:name buttonID:i];
        button.size = buttonSize;
        button.position = CGPointMake(xPos, yPos);
        [self addChild:button];
        yPos -= 50.0;
    }
}
@end
