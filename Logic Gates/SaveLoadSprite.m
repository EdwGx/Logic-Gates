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
}
-(id)initWithDataManger:(DataManger *)dataManger ScreenHeight:(CGFloat)height{
    if (self = [super init]) {
        self.dataMgr = dataManger;
        numberOfFiles = [self.dataMgr.saveFileList count];
        height = MAX(height, numberOfFiles*50);
        self.size = CGSizeMake(50, height);
        self.color = [SKColor colorWithRed:0.1 green:0.73 blue:0.6 alpha:1.0];
    }
    return self;
}
-(void)setupLabels{
    CGFloat yPos = 25.0;
    for (NSUInteger i = 1; i  < [self.dataMgr.saveFileList count]; i++) {
        NSString* name = [self.dataMgr.saveFileList objectAtIndex:i];
        ButtonSprite* button = [[ButtonSprite alloc]initWithName:name];
        button.position = [self convertCoordinateCenterFromTopLeftToCenter:CGPointMake(leftBorder   +button.size.width, yPos)];
        yPos += 50.0;
    }

}
                                
-(CGPoint)convertCoordinateCenterFromTopLeftToCenter:(CGPoint)point{
    return CGPointMake(point.x-self.size.width/2, -point.y+self.size.height/2);
}

@end
