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
    UIActivityIndicatorView* _activityIndicator;
    NSUInteger _timerCount;
    
}

- (id)initWithFrame:(CGRect)frame SelectedGate:(Gates*)gate
{
    CGRect newFrame = CGRectMake(0, -40, CGRectGetHeight(frame), 40);
    self = [super initWithFrame:newFrame];
    if (self) {
        self.alpha = 0.2;
        self.backgroundColor = [UIColor colorWithRed:0.2039 green:0.5961 blue:0.8588 alpha:0.8];
        
        _selectedGate = gate;
        _displayType = (_selectedGate.gateType == GateTypeSwitch)?InputNameEditorType:OutputBooleanFormulaType;
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(newFrame), 30)];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        if (_displayType == InputNameEditorType) {
            _label.text = @"tap to set the input name";
        }else{
            _label.text = @"tap to generate boolean formula";
        }
        _label.center = CGPointMake(CGRectGetMidX(newFrame), CGRectGetHeight(newFrame)/2);
        [self addSubview:_label];
        
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

-(void)booleanFormulaOfSelectedOutput:(NSString *)formula{
    UITextView* textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.frame) - 60, 0)];
    textView.text = formula;
    textView.editable = NO;
    textView.textColor = [UIColor whiteColor];
    textView.alpha = 0.0;
    textView.backgroundColor = [UIColor clearColor];
    [textView setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:textView];
    
    CGSize maxSize = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) - 60, MAXFLOAT)];
    CGSize textViewSize = CGSizeMake(CGRectGetWidth(self.frame) - 60, MIN(maxSize.height, 100));
    
    textView.scrollEnabled = YES;
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
    
    UIButton* endButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [endButton setTitle:@"done" forState:UIControlStateNormal];
    [endButton sizeToFit];
    endButton.center = CGPointMake(CGRectGetMaxX(self.frame)- CGRectGetWidth(endButton.frame)/2 - 10, CGRectGetHeight(self.frame)/2);
    [endButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:endButton];
    
    
    [UIView animateWithDuration:1.0 animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, textViewSize.height + 20);
        textView.frame = CGRectMake(10, 10, textViewSize.width, textViewSize.height);
        textView.alpha = 1.0;
    }];
}

-(void)tap:(UITapGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded && _state != CornerViewEditingState) {
        _state = CornerViewEditingState;
        _timerCount += 1;
        if (self.displayType == InputNameEditorType) {
            
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
            
            NSString* oldName = [_selectedGate.userData objectForKey:@"InputName"];
            
            if (![oldName isEqualToString:@""]) {
                _textField.text = oldName;
            }
            [_textField addTarget:self action:@selector(done) forControlEvents:UIControlEventEditingDidEndOnExit];
            [self addSubview:_textField];
            
            [_textField becomeFirstResponder];
            
        } else {
            
            [_label removeFromSuperview];
            
            _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            _activityIndicator.center = _label.center;
            [self addSubview:_activityIndicator];
            [_activityIndicator startAnimating];
            
            [self performSelectorInBackground:@selector(getSelectedGateBooleanFormula) withObject:nil];
        }
        
    }
}

-(void)setSelectedGate:(Gates *)selectedGate{
    if (![selectedGate isEqual:_selectedGate]) {
        if (_state == CornerViewWaitingState || _state == CornerViewAppearingState) {
            _displayType = (selectedGate.gateType == GateTypeSwitch)?InputNameEditorType:OutputBooleanFormulaType;
            
            if (_displayType == InputNameEditorType) {
                _label.text = @"tap to set the input name";
            }else{
                _label.text = @"tap to generate boolean formula";
            }
            
            _selectedGate = selectedGate;
            
            [self performSelector:@selector(disappear) withObject:nil afterDelay:5.0];
            _timerCount += 1;
        }
    }
}


-(void)done{
    NSString*testString = [_textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([testString length]>0) {
        [_selectedGate.userData setValue:_textField.text forKey:@"InputName"];
        [_textField resignFirstResponder];
        [self removeFromSuperview];
    }
}

-(void)getSelectedGateBooleanFormula{
    NSString* formula = [_selectedGate booleanFormula];
    [self performSelectorOnMainThread:@selector(booleanFormulaOfSelectedOutput:) withObject:formula waitUntilDone:NO];
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
    _timerCount += 1;
    
}

-(void)disappear{
    _timerCount -= 1;
    if (_timerCount == 0) {
        [self removeFromSuperview];
    }
}

@end
