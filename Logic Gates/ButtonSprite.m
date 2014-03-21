//
//  ButtonSprite.m
//  Logic Gates
//
//  Created by edguo on 3/10/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ButtonSprite.h"
@implementation ButtonSprite
-(id)initWithName:(NSString*)name buttonID:(NSUInteger)number{
    if (self = [super init]) {
        SKLabelNode* label = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter"];
        label.name = @"BUTTON";
        label.text =name;
        label.fontSize = 25;
        label.fontColor = [SKColor whiteColor];
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        label.position = CGPointZero;
        [self addChild:label];
        self.color = [SKColor colorWithRed:0.18 green:0.797 blue:0.44 alpha:1.0];
        self.name = @"BUTTON";
        self.button_id = number;
    }
    return self;
}

+(instancetype)buttonWithName:(NSString*)name buttonID:(NSUInteger)number{
    return [[ButtonSprite alloc]initWithName:name buttonID:number];
}
@end
