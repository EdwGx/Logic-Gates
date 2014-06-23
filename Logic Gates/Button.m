//
//  Button.m
//  Logic Gates
//
//  Created by Edward Guo on 2014-06-23.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "Button.h"
#import <objc/message.h>

@implementation Button{
    __weak id _touchDownTarget;
    SEL _touchDownSector;
}
-(void)setTouchDownTarget:(id)target Action:(SEL)sector{
    if ([target respondsToSelector:sector]) {
        self.userInteractionEnabled = YES;
        _touchDownSector = sector;
        _touchDownTarget = target;
    }
}
-(void)removeTouchDownTargetAndAction{
    _touchDownTarget = nil;
    _touchDownSector = NULL;
    self.userInteractionEnabled = NO;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_touchDownTarget) {
        objc_msgSend(_touchDownTarget, _touchDownSector,self);
    }
}
@end
