//
//  SelectionSprite.m
//  Logic Gates
//
//  Created by edguo on 3/1/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "SelectionSprite.h"
#define leftBorderWidth 100.0
#define topBorderWidth 60.0
#define minSpace 100.0

@implementation SelectionSprite
-(id)initWithScene:(SKScene *)scene Size:(CGSize)size{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        self.position = CGPointMake(-size.width/2+10, size.height/2);
        self.color = [SKColor colorWithRed:0.2 green:0.594 blue:0.855 alpha:0.9];
        self.typeArray = @[@"and_gate",@"or_gate",@"xor_gate",@"nand_gate",@"nor_gate",@"xnor_gate",@"not_gate",@"switch_off",@"bulb_off" ];
        NSArray* nameArray = @[@"AND Gate",@"OR Gate",@"XOR Gate",@"NAND Gate",@"NOR Gate",@"XNOR Gate",@"NOT Gate",@"Switch",@"Light Bulb" ];
        self.mainScene = scene;
        CGFloat width = size.width-20 ;
        //Find out how many row
        float i = leftBorderWidth;
        float j = 0.0;
        while (i+leftBorderWidth<=size.width) {
            j++;
            i += minSpace;
        }
        float minRows = ceilf([self.typeArray count]/j);
        minRows -= 1;
        CGFloat reqHeight = topBorderWidth*2+minSpace*minRows;
        CGFloat height = reqHeight<size.height?size.height:reqHeight;
        
        self.size = CGSizeMake(width,height);
        self.position = CGPointMake(-size.width/2+10, size.height-height/2);
        

        CGFloat posX = leftBorderWidth;
        CGFloat posY = topBorderWidth;
        CGFloat const fitSpace = (width - leftBorderWidth*2.0)/(j-1);

        for (int i = 0;i<[self.typeArray count];i++){
            NSString *name = [self.typeArray objectAtIndex:i];
            SKSpriteNode *sNode = [SKSpriteNode spriteNodeWithImageNamed:name];
            sNode.name = name;
            sNode.position = [self convertCoordinateCenterFromTopLeftToCenter:CGPointMake(posX, posY)];
            [self addChild:sNode];
            
            SKLabelNode* label = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
            label.position = CGPointMake(sNode.position.x, sNode.position.y - sNode.size.height/2 - 10);
            label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
            label.fontColor = [SKColor whiteColor];
            label.fontSize = 16;
            label.text = [nameArray objectAtIndex:i];
            [self addChild:label];
            
            if (posX+fitSpace+leftBorderWidth<=size.width) {
                posX += fitSpace;
            }else{
                posX = leftBorderWidth;
                posY += minSpace;
            }
        }
    }
    return self;
}

-(int8_t)getTouchGateTypeWithName:(NSString*)name{
    NSInteger indexInArray = [self.typeArray indexOfObject:name];
    if (indexInArray == NSNotFound){
        return (int8_t)0;
    }else{
        return (int8_t)indexInArray+1;
    }
}


-(CGPoint)convertCoordinateCenterFromTopLeftToCenter:(CGPoint)point{
    return CGPointMake(point.x-self.size.width/2, -point.y+self.size.height/2);
}


@end
