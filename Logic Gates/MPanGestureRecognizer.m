//
//  MPanGestureRecognizer.m
//  TestTouch
//
//  Created by Edward Guo on 2014-06-23.
//  Copyright (c) 2014 Peiliang Edward Guo. All rights reserved.
//

#import "MPanGestureRecognizer.h"

@implementation MPanGestureRecognizer
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    _startLocation = [[touches anyObject] locationInView:self.view];
}
@end
