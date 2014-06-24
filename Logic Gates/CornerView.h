//
//  CornerView.h
//  Logic Gates
//
//  Created by Edward Guo on 2014-06-23.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gates.h"

typedef NS_ENUM(NSUInteger, CornerDisplayType){
    InputNameEditorType,
    OutputBooleanFormulaType
};

typedef NS_ENUM(NSUInteger, CornerViewState){
    CornerViewAppearingState,
    CornerViewWaitingState,
    CornerViewEditingState,
};



@interface CornerView : UIView

@property(nonatomic) CornerDisplayType displayType;
@property(nonatomic, readonly) CornerViewState state;
@property(nonatomic, weak) Gates* selectedGate;

- (id)initWithFrame:(CGRect)frame SelectedGate:(Gates*)gate;
-(void)showUp;
@end

