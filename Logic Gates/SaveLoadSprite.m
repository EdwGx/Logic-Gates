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
@implementation SaveLoadSprite{
    NSUInteger numberOfFiles;
    CGSize screenSize;
    NSUInteger outID;
}
-(id)initWithDataManger:(DataManger *)dataManger ScreenSize:(CGSize)screenS{
    if (self = [super init]) {
        self.dataMgr = dataManger;
        numberOfFiles = [self.dataMgr.saveFileList count];
        CGFloat height = MAX(screenS.height, numberOfFiles*50);
        self.size = CGSizeMake(50, height);
        self.color = [SKColor colorWithRed:0.1 green:0.73 blue:0.6 alpha:1.0];
        screenSize = screenS;
    }
    return self;
}
-(void)setupLabels{
    CGFloat yPos = 25.0;
    ButtonSprite* button = [[ButtonSprite alloc]initWithName:@"add" buttonID:0];
    button.position = [self convertCoordinateCenterFromTopLeftToCenter:CGPointMake(leftBorder   +button.size.width, yPos)];
    [self addChild:button];
    yPos += 50.0;
    for (NSUInteger i = 1; i  < [self.dataMgr.saveFileList count]; i++) {
        NSString* name = [self.dataMgr.saveFileList objectAtIndex:i];
        ButtonSprite* button = [[ButtonSprite alloc]initWithName:name buttonID:i];
        button.position = [self convertCoordinateCenterFromTopLeftToCenter:CGPointMake(leftBorder   +button.size.width, yPos)];
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
            if (BNode.button_id != 0) {
                CGFloat posX = MAX(screenSize.width-BNode.size.width, BNode.size.width);
                posX = posX - self.position.x;
                SKAction* action = [SKAction moveToX:posX duration:0.2];
                [BNode runAction:action];
            }
        }
    }
}
                                
-(CGPoint)convertCoordinateCenterFromTopLeftToCenter:(CGPoint)point{
    return CGPointMake(point.x-self.size.width/2, -point.y+self.size.height/2);
}



@end
