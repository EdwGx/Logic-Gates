//
//  SaveLoadSprite.m
//  Logic Gates
//
//  Created by edguo on 3/10/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "SaveLoadSprite.h"
#import "ButtonSprite.h"
#define leftBorder 20
#define barWidth 120
@implementation SaveLoadSprite{
    NSUInteger numberOfFiles;
    CGSize screenSize;
    NSUInteger outID;
}
-(id)initWithMap:(CircuitMap *)map ScreenSize:(CGSize)screenS{
    if (self = [super init]) {
        self.map = map;
        numberOfFiles = [self.map.dataMgr.saveFileList count];
        CGFloat height = MAX(screenS.height, numberOfFiles*50);
        self.size = CGSizeMake(barWidth, height);
        self.color = [SKColor colorWithRed:0.1 green:0.73 blue:0.6 alpha:1.0];
        screenSize = screenS;
        self.position = CGPointMake(barWidth/2+screenS.width, screenSize.height/2);
        self.zPosition = 20;
        [self setupLabels];
    }
    return self;
}
-(void)setupLabels{
    CGFloat yPos = 25.0;
    ButtonSprite* button = [[ButtonSprite alloc]initWithName:@"add" buttonID:0];
    button.position = [self convertCoordinateCenterFromTopLeftToCenter:CGPointMake(leftBorder+button.size.width/2, yPos)];
    [self addChild:button];
    yPos += 50.0;
    for (NSUInteger i = 1; i  < [self.map.dataMgr.saveFileList count]; i++) {
        NSString* name = [self.map.dataMgr.saveFileList objectAtIndex:i];
        ButtonSprite* button = [[ButtonSprite alloc]initWithName:name buttonID:i];
        button.position = [self convertCoordinateCenterFromTopLeftToCenter:CGPointMake(leftBorder+button.size.width/2, yPos)];
        [self addChild:button];
        yPos += 50.0;
    }

}

-(void)touchNodeAtPoint:(CGPoint)point{
    SKNode*node = [self nodeAtPoint:point];
    if ([node.name isEqualToString:@"BUTTON"]) {
        ButtonSprite *BNode;
        if ([node isKindOfClass:[SKLabelNode class]]) {
            BNode = (ButtonSprite*)[node parent];
        }else if ([node isKindOfClass:[ButtonSprite class]]){
            BNode = (ButtonSprite*)node;
        }
        if (BNode) {
            if (BNode.button_id == 0) {
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"New Save File"
                                                                   message:nil
                                                                  delegate:self
                                                         cancelButtonTitle:@"cancel"
                                                         otherButtonTitles:@"save", nil];
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField* textField = [alertView textFieldAtIndex:0];
                textField.placeholder = @"Enter a name";
                [alertView show];
                /*
                
                 */
            }else{
                if (BNode.button_id == outID) {
                    SKAction* action = [SKAction moveToX:leftBorder+BNode.size.width/2-self.size.width/2 duration:0.2];
                    [BNode runAction:action completion:^{
                        outID = 0;
                    }];
                }else{
                    outID = BNode.button_id;
                    CGFloat posX = MAX(screenSize.width-BNode.size.width/2-leftBorder*2, BNode.size.width/2);
                    posX = posX - self.position.x;
                    SKAction* action = [SKAction moveToX:posX duration:0.2];
                    [BNode runAction:action];
                }
            }
        }
    }
}

-(void)kill{
    SKAction *fadeAction = [SKAction moveByX:self.size.width y:0 duration:0.2];
    SKAction *remove = [SKAction removeFromParent];
    [self runAction:[SKAction sequence:@[fadeAction,remove]]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"New Save File"]) {
        if (buttonIndex == 1) {
            UITextField* textField = [alertView textFieldAtIndex:0];
            [self.map saveMap:textField.text];
            [self kill];
        }
        
    }
}
                                
-(CGPoint)convertCoordinateCenterFromTopLeftToCenter:(CGPoint)point{
    return CGPointMake(point.x-self.size.width/2, -point.y+self.size.height/2);
}



@end
