//
//  MapFileScene.m
//  Logic Gates
//
//  Created by edguo on 2014-03-21.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "MapFileScene.h"

@implementation MapFileScene{
    SKScene *mScene;
    CircuitMap* mMap;
    CGFloat yLength;
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
        
        self.buttonMap = [SKNode node];
        
        [self performSelectorInBackground:@selector(setupButtons) withObject:nil];
        
    }
    return self;
}

-(void)setupButtons{
    CGFloat yPos = 0;
    CGSize buttonSize = CGSizeMake(self.size.width-60, 36);
    
    for (NSUInteger i = 1; i  < [mMap.filesList count]; i++) {
        NSString* name = [mMap.filesList objectAtIndex:i];
        ButtonSprite* button = [[ButtonSprite alloc]initWithName:name buttonID:i];
        button.size = buttonSize;
        button.position = CGPointMake(0, yPos);
        [self addChild:button];
        yPos -= 50.0;
        
        if (i == 1) {
            self.buttonMap.position = CGPointMake(self.size.width/2 + 40, self.size.height-25);
        }
    }
    yLength = -yPos;
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

-(void)buttonTouchUp:(NSUInteger)index{
    if (index>0) {
        for (ButtonSprite*button in self.buttonMap.children) {
            if (button.button_id>index) {
                SKAction* action = [SKAction moveByX:0 y:50 duration:0.2];
                [button runAction:action];
            }
        }
    }
}

-(void)setupAddAlertView{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"New Save File"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"cancel"
                                             otherButtonTitles:@"save", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField* textField = [alertView textFieldAtIndex:0];
    textField.placeholder = @"Enter a name";
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"New Save File"]) {
        if (buttonIndex == 1) {
            //UITextField* textField = [alertView textFieldAtIndex:0];
        }
        
    }
}

-(void)handleTapFrom:(UITapGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint pointInScene = [self convertPointFromView:[recognizer locationInView:self.view]];
        SKNode* node = [self nodeAtPoint:pointInScene];
        if (node) {
            if ([node.name isEqualToString:@"BUTTON"]) {
                ButtonSprite* button;
                if ([node isKindOfClass:[ButtonSprite class]]) {
                    button = (ButtonSprite*)node;
                }else if([node isKindOfClass:[SKLabelNode class]]){
                    button = (ButtonSprite*)node.parent;
                }
                if (button) {
                    [self buttonTouchUp:button.button_id];
                }
            } else if ([node isEqual:self.addButton]){
                [self setupAddAlertView];
            } else if ([node isEqual:self.backButton]){
                [self presentMainScene];
            }
        }
        
    }
    
}
@end
