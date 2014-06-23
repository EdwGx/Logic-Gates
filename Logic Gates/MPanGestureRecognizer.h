//
//  MPanGestureRecognizer.h
//  TestTouch
//
//  Created by Edward Guo on 2014-06-23.
//  Copyright (c) 2014 Peiliang Edward Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface MPanGestureRecognizer : UIPanGestureRecognizer
@property(nonatomic, readonly) CGPoint startLocation;
@end
