//
//  MapIOView.m
//  Logic Gates
//
//  Created by Edward Guo on 2014-06-22.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "MapIOView.h"

@implementation MapIOView{
    SKScene* _scene;
    CircuitMap* _map;
    
    UITableView* _tableView;
    
    UIButton* _addButton;
    UIButton* _backButton;
    
    UIActivityIndicatorView * _ioActivityIndicator;
}

- (id)initWithFrame:(CGRect)frame Scene:(SKScene*)scene Map:(CircuitMap*)map
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.2039 green:0.5961 blue:0.8588 alpha:0.8];
        
        _map = map;
        _map.fileIOMenu = self;
        _scene = scene;
        
        _scene.userInteractionEnabled = NO;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(100,
                                                                   0,
                                                                   CGRectGetWidth(frame)-100,
                                                                   CGRectGetHeight(frame))
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.allowsSelection = YES;
        [self addSubview:_tableView];
        
        UIImage* addButtonImage = [UIImage imageNamed:@"addButton"];
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:addButtonImage forState:UIControlStateNormal];
        _addButton.frame = CGRectMake(10, 100, addButtonImage.size.width, addButtonImage.size.height);
        [_addButton addTarget:self action:@selector(addButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addButton];
        
        UIImage* backButtonImage = [UIImage imageNamed:@"backButton"];
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:backButtonImage forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(10, 200, backButtonImage.size.width, backButtonImage.size.height);
        [_backButton addTarget:self action:@selector(backButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
    }
    return self;
}

-(void)addButtonTouchUp{
    [self setupAlertView];
}

-(void)backButtonTouchUp{
    _scene.userInteractionEnabled = YES;
    [self removeFromSuperview];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self lockButtons];
        [self removeMapWithFileName:_map.filesList[indexPath.row+1]];
        [self unlockButtons];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _map.filesList.count -1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.textLabel.text = _map.filesList[indexPath.row+1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self loadMapWithFileName:_map.filesList[indexPath.row+1]];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self lockButtons];
}

-(void)setupAlertView{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"New Save File"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"cancel"
                                             otherButtonTitles:@"save", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField* textField = [alertView textFieldAtIndex:0];
    textField.placeholder = @"Enter a name";
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"New Save File"]) {
        if (buttonIndex == 1) {
            UITextField* textField = [alertView textFieldAtIndex:0];
            
            [self lockButtons];
            
            [self saveMapWithFileName:textField.text];
        }
        
    }
}

-(void)lockButtons{
    _backButton.enabled = NO;
    _addButton.enabled = NO;
    
    _ioActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _ioActivityIndicator.center = _tableView.center;
    [self addSubview:_ioActivityIndicator];
    [_ioActivityIndicator startAnimating];
}

-(void)unlockButtons{
    _backButton.enabled = YES;
    _addButton.enabled = YES;
    if (_ioActivityIndicator) {
        [_ioActivityIndicator removeFromSuperview];
        _ioActivityIndicator = nil;
    }
}

-(void)saveMapWithFileName:(NSString*)name{
    [_map performSelectorInBackground:@selector(saveMap:) withObject:name];
}

-(void)loadMapWithFileName:(NSString*)name{
    [_map killAllGates];
    [_map performSelectorInBackground:@selector(loadMap:) withObject:name];
}

-(void)removeMapWithFileName:(NSString*)name{
    [_map removeMapFile:name];
    [_tableView reloadData];
}

-(void)fileDidLoad{
    NSLog(@"Y");
    [self unlockButtons];
}

-(void)fileDidSave{
    [self unlockButtons];
    [_tableView reloadData];
}
@end
