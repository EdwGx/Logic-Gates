//
//  CornerView.m
//  Logic Gates
//
//  Created by Edward Guo on 2014-06-23.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "CornerView.h"

@implementation CornerView{
    UILabel* _label;
    UITextField* _textField;
}

- (id)initWithFrame:(CGRect)frame DisplayType:(CornerDisplayType)displayType
{
    CGRect newFrame = CGRectMake(0, -40, CGRectGetHeight(frame), 40);
    self = [super initWithFrame:newFrame];
    if (self) {
        self.alpha = 0.2;
        self.backgroundColor = [UIColor colorWithRed:0.2039 green:0.5961 blue:0.8588 alpha:0.8];
        
        _displayType = displayType;
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(newFrame), 30)];
        _label.textAlignment = NSTextAlignmentCenter;
        if (_displayType == InputNameEditorType) {
            _label.text = @"tap to set the input name";
        }else{
            _label.text = @"tap to generate boolean formula";
        }
        _label.center = CGPointMake(CGRectGetMidX(newFrame), CGRectGetHeight(newFrame)/2);//CGRectGetMidY(newFrame));
        [self addSubview:_label];
        
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

-(void)booleanFormulaOfSelectedOutput:(NSString *)formula{
    
}

-(void)tap:(UITapGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded && _state != CornerViewEditingState) {
        _state = CornerViewEditingState;
        if (self.displayType == InputNameEditorType) {
            
            [_label removeFromSuperview];
            
            UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
            doneButton.frame = CGRectMake(0,0,100,100);
            [doneButton setTitle:@"done" forState:UIControlStateNormal];
            [doneButton sizeToFit];
            doneButton.center = CGPointMake(CGRectGetMaxX(self.frame)- CGRectGetWidth(doneButton.frame)/2 - 10, CGRectGetHeight(self.frame)/2);
            [doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:doneButton];
            
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetMaxX(self.frame)- CGRectGetWidth(doneButton.frame) - 30, 30)];
            _textField.center = CGPointMake(_textField.center.x,CGRectGetHeight(self.frame)/2);
            _textField.placeholder = @"enter input name";
            _textField.returnKeyType = UIReturnKeyDone;
            _textField.borderStyle = UITextBorderStyleLine;
            _textField.backgroundColor = [UIColor whiteColor];
            
            NSString* oldName = @"";
            if (self.delegate) {
                oldName = [self.delegate getSelectedInputName];
            }
            
            if (![oldName isEqualToString:@""]) {
                _textField.text = oldName;
            }
            [_textField addTarget:self action:@selector(done) forControlEvents:UIControlEventEditingDidEndOnExit];
            [self addSubview:_textField];
            
            [_textField becomeFirstResponder];
        }
        
    }
}

-(void)done{
    NSString*testString = [_textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([testString length]>0) {
        [_textField resignFirstResponder];
    }
}

-(void)showUp{
    _state = CornerViewAppearingState;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
        self.center = CGPointMake(self.center.x,self.center.y + 40);
    } completion:^(BOOL finished) {
        _state = CornerViewWaitingState;
    }];
    
    [self performSelector:@selector(disappear) withObject:nil afterDelay:5.0];
    
}

-(void)disappear{
    if (_state != CornerViewEditingState) {
        [self removeFromSuperview];
    }
}

@end
