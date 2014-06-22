//
//  MapIOView.h
//  Logic Gates
//
//  Created by Edward Guo on 2014-06-22.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "CircuitMap.h"

@interface MapIOView : UIView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,circuitMapFileIODelegate>
- (id)initWithFrame:(CGRect)frame Scene:(SKScene*)scene Map:(CircuitMap*)map;
@end
