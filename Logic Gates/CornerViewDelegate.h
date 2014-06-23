//
//  CornerViewDelegate.h
//  Logic Gates
//
//  Created by Edward Guo on 2014-06-23.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CornerView.h"

@class CornerView;
@protocol CornerViewDelegate <NSObject>
-(NSString*)getSelectedInputName;
-(void)changeSelectedInputNameTo:(NSString*)name;
-(void)getBooleanFormulaOfSelectedOutput:(CornerView*)cornerView;
@end
