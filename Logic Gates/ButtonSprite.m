//
//  ButtonSprite.m
//  Logic Gates
//
//  Created by edguo on 3/10/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ButtonSprite.h"
#define minWidth 160
@implementation ButtonSprite
-(id)initWithName:(NSString*)name{
    if (self = [super init]) {
        SKLabelNode* label = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter"];
        label.text =name;
        label.fontSize = 20;
        label.fontColor = [SKColor whiteColor];
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        CGRect labelRect = [label calculateAccumulatedFrame];
        self.size = CGSizeMake(MAX(labelRect.size.width+20,minWidth), 30);
        label.position = CGPointZero;
        [self addChild:label];
        self.color = [SKColor colorWithRed:0.18 green:0.797 blue:0.44 alpha:1.0];
    }
    return self;
}
@end
