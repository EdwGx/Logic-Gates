//
//  SaveLoadSprite.m
//  Logic Gates
//
//  Created by edguo on 3/10/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "SaveLoadSprite.h"

#define leftBorder 20
#define barWidth 120
@implementation SaveLoadSprite{
    NSUInteger numberOfFiles;
    CGSize screenSize;
}
-(id)initWithMap:(CircuitMap *)map ScreenSize:(CGSize)screenS Delegate:(id)delegate{
    if (self = [super init]) {
        self.map = map;
        [self.map addObserver:self forKeyPath:@"filesList" options:0 context:nil];
        self.delegate = delegate;
        numberOfFiles = [self.map.filesList count];
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
    [self removeAllChildren];
    ButtonSprite* button = [[ButtonSprite alloc]initWithName:@"add" buttonID:0];
    button.position = [self convertCoordinateCenterFromTopLeftToCenter:CGPointMake(leftBorder+button.size.width/2, yPos)];
    [self addChild:button];
    yPos += 50.0;
    for (NSUInteger i = 1; i  < [self.map.filesList count]; i++) {
        NSString* name = [self.map.filesList objectAtIndex:i];
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
            }else{
                if ([BNode isEqual:self.buttonOut]) {
                    SKAction* action = [SKAction moveToX:leftBorder+BNode.size.width/2-self.size.width/2 duration:0.2];
                    [BNode runAction:action completion:^{
                        self.buttonOut = nil;
                    }];
                    [[self childNodeWithName:@"save"] removeFromParent];
                    [[self childNodeWithName:@"load"] removeFromParent];
                    [[self childNodeWithName:@"remove"] removeFromParent];
                }else{
                    if (self.buttonOut) {
                        SKAction* action = [SKAction moveToX:leftBorder+self.buttonOut.size.width/2-self.size.width/2 duration:0.2];
                        [self.buttonOut runAction:action];
                        [[self childNodeWithName:@"save"] removeFromParent];
                        [[self childNodeWithName:@"load"] removeFromParent];
                        [[self childNodeWithName:@"remove"] removeFromParent];
                    }
                    self.buttonOut = BNode;
                    CGFloat posX = MAX(screenSize.width-BNode.size.width/2-leftBorder-210, BNode.size.width/2);
                    posX = posX - self.position.x;
                    SKAction* action = [SKAction moveToX:posX duration:0.2];
                    [BNode runAction:action completion:^{
                        [self setUpMenu];
                    }];
                }
            }
        }
    }
    else if ([node.name isEqualToString:@"save"]){
        NSString*name = [self.map.filesList objectAtIndex:self.buttonOut.button_id];
        [self.map saveMap:name];
        [self kill];
    } else if ([node.name isEqualToString:@"load"]){
        NSString*name = [self.map.filesList objectAtIndex:self.buttonOut.button_id];
        [self.map loadMap:name];
        [self kill];
    } else if ([node.name isEqualToString:@"remove"]){
        NSString*name = [self.map.filesList objectAtIndex:self.buttonOut.button_id];
        [self.map removeMapFile:name];
        [self kill];
    }
}

-(void)setUpMenu{
    CGFloat posX = self.buttonOut.position.x - self.buttonOut.size.width/2 + 25;
    CGFloat posY = self.buttonOut.position.y - self.buttonOut.size.height/2 - 30;
    
    SKSpriteNode* sprite1 = [SKSpriteNode spriteNodeWithImageNamed:@"save_button"];
    sprite1.name = @"save";
    sprite1.position = CGPointMake(posX, posY);
    [self addChild:sprite1];
    
    posX += 60;
    SKSpriteNode* sprite2 = [SKSpriteNode spriteNodeWithImageNamed:@"load_button"];
    sprite2.name = @"load";
    sprite2.position = CGPointMake(posX, posY);
    [self addChild:sprite2];
    
    posX += 60;
    SKSpriteNode* sprite3 = [SKSpriteNode spriteNodeWithImageNamed:@"remove_button"];
    sprite3.name = @"remove";
    sprite3.position = CGPointMake(posX, posY);
    [self addChild:sprite3];
    
}

-(void)kill{
    SKAction *fadeAction = [SKAction moveByX:self.size.width y:0 duration:0.2];
    [self runAction:fadeAction completion:^{
        [self.delegate setSLMenuToNil];
    }];
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object isEqual:self.map]) {
        if ([keyPath isEqualToString:@"filesList"]) {
            [self setupLabels];
        }
    }
}
                                
-(CGPoint)convertCoordinateCenterFromTopLeftToCenter:(CGPoint)point{
    return CGPointMake(point.x-self.size.width/2, -point.y+self.size.height/2);
}

-(void)dealloc{
    [self.map removeObserver:self forKeyPath:@"filesList"];
}


@end
