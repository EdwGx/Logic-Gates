//
//  CornerView.h
//  Logic Gates
//
//  Created by Edward Guo on 2014-06-23.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "CornerViewDelegate.h"

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
@property(nonatomic, weak) id<CornerViewDelegate> delegate;
@property(nonatomic, readonly) CornerViewState state;
- (id)initWithFrame:(CGRect)frame DisplayType:(CornerDisplayType)displayType;
-(void)booleanFormulaOfSelectedOutput:(NSString*)formula;
-(void)showUp;
@end

