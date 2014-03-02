//
//  SelectionSprite.m
//  Logic Gates
//
//  Created by edguo on 3/1/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "SelectionSprite.h"
#define leftBorderWidth 100.0
#define topBorderWidth 100.0
#define space 100.0

@implementation SelectionSprite
-(id)initWithScene:(SKScene *)scene Size:(CGSize)size{
    if (self = [super init]) {
        self.position = CGPointMake(-size.width/2+10, size.height/2);
        self.color = [SKColor blueColor];
        self.typeArray = @[@"and_gate",@"or_gate",@"xor_gate",@"nand_gate",@"nor_gate",@"xnor_gate",@"not_gate",@"switch_off",@"bulb_off" ];
        
        CGFloat width = size.width-20 ;
        //Find out how many row
        float i = leftBorderWidth;
        float j = 0.0;
        while (i+leftBorderWidth<=size.width) {
            j++;
            i += space;
        }
        float minRows = ceilf([self.typeArray count]/j);
        minRows -= 1;
        CGFloat reqHeight = topBorderWidth*2+space*minRows;
        CGFloat height = reqHeight<size.height?size.height:reqHeight;
        NSLog(@"size:%f,%f",width,height);
        
        self.size = CGSizeMake(width,height);
        self.position = CGPointMake(-size.width/2+10, size.height-height/2);
        

        CGFloat posX = leftBorderWidth;
        CGFloat posY = topBorderWidth;

        for (int i = 0;i<[self.typeArray count];i++){
            NSString *name = [self.typeArray objectAtIndex:i];
            SKSpriteNode *sNode = [SKSpriteNode spriteNodeWithImageNamed:name];
            sNode.position = [self convertCoordinateCenterFromTopLeftToCenter:CGPointMake(posX, posY)];
            [self addChild:sNode];
            
            if (posX+space+topBorderWidth<=size.width) {
                posX += space;
            }else{
                posX = leftBorderWidth;
                posY += space;
            }
        }
    }
    return self;
}

-(CGPoint)convertCoordinateCenterFromTopLeftToCenter:(CGPoint)point{
    return CGPointMake(point.x-self.size.width/2, -point.y+self.size.height/2);
}


@end
