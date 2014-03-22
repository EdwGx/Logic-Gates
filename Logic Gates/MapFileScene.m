//
//  MapFileScene.m
//  Logic Gates
//
//  Created by edguo on 2014-03-21.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "MapFileScene.h"
#import "ButtonSprite.h"

@implementation MapFileScene{
    SKScene *mScene;
    CircuitMap* mMap;
}
-(id)initWithSize:(CGSize)size MainScene:(SKScene*)mainScene Map:(CircuitMap*)map{
    if (self = [super initWithSize:size]) {
        mScene = mainScene;
        mMap = map;
        
        //BackButton
        self.backButton = [[SKSpriteNode alloc]initWithColor:[SKColor yellowColor] size:CGSizeMake(45, 45)];
        self.backButton.position = CGPointMake(25, self.size.height - 25);
        [self addChild:self.backButton];
        
        //AddButton
        self.addButton = [[SKSpriteNode alloc]initWithColor:[SKColor blackColor] size:CGSizeMake(45, 45)];
        self.addButton.position = CGPointMake(25, 25);
        [self addChild:self.backButton];
        
        [self performSelectorInBackground:@selector(setupButtons) withObject:nil];
        
    }
    return self;
}

-(void)setupButtons{
    CGFloat yPos = self.size.height;
    CGFloat xPos = self.size.width/2 + 40;
    CGSize buttonSize = CGSizeMake(self.size.width-60, 36);
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

-(void)didMoveToView:(SKView *)view{
    UISwipeGestureRecognizer* swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapFrom:)];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.swipeRecognizer = swipeGestureRecognizer;
    self.tapRecognizer = tapGestureRecognizer;
    
}

-(void)presentMainScene{
    [self.view removeGestureRecognizer:self.swipeRecognizer];
    [self.view removeGestureRecognizer:self.tapRecognizer];
    [self.view presentScene:mScene];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
            [self presentMainScene];
        }
    }
}

-(void)handleTapFrom:(UITapGestureRecognizer*)recognizer{
    
}
@end
