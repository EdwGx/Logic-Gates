//
//  MapFileScene.m
//  Logic Gates
//
//  Created by edguo on 2014-03-21.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "MapFileScene.h"

@implementation MapFileScene{
    SKScene *mScene;
    CircuitMap* mMap;
    CGFloat yLength;
    BOOL lockButton;
    
    UITableView* _tableView;
}
-(id)initWithSize:(CGSize)size MainScene:(SKScene*)mainScene Map:(CircuitMap*)map{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        
        mScene = mainScene;
        mMap = map;
        
        yLength = 0;
        lockButton = false;
        mMap.fileIOMenu = self;
        
        //BackButton
        self.backButton = [[SKSpriteNode alloc]initWithImageNamed:@"backButton"];
        self.backButton.position = CGPointMake(40, self.size.height - 40);
        [self addChild:self.backButton];
        
        //AddButton
        self.addButton = [[SKSpriteNode alloc]initWithImageNamed:@"addButton"];
        self.addButton.position = CGPointMake(40, 40);
        [self addChild:self.addButton];
        
                                                                   
                                                        
        /*
        self.buttonMap = [SKNode node];
        [self addChild:self.buttonMap];
        
        [self performSelectorInBackground:@selector(setupButtons) withObject:nil];
        */
        
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;//mMap.filesList.count - 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = mMap.filesList[1];
    return cell;
}

-(void)setupButtons{
    CGFloat yPos = 0;
    CGSize buttonSize = CGSizeMake(self.size.width-120, 36);
    for (NSUInteger i = 1; i  < [mMap.filesList count]; i++) {
        NSString* name = [mMap.filesList objectAtIndex:i];
        ButtonSprite* button = [[ButtonSprite alloc]initWithName:name buttonID:i];
        button.size = buttonSize;
        button.position = CGPointMake(0, yPos);
        [self.buttonMap addChild:button];
        yPos -= 60.0;
        
        if (i == 1) {
            self.buttonMap.position = CGPointMake(self.size.width/2 + 40, self.size.height-30);
        }
    }
    yLength = -yPos;
}

-(void)didMoveToView:(SKView *)view{
    UISwipeGestureRecognizer* swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapFrom:)];
    UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanFrom:)];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self.view addGestureRecognizer:panGestureRecognizer];
    self.swipeRecognizer = swipeGestureRecognizer;
    self.tapRecognizer = tapGestureRecognizer;
    self.panRecognizer = panGestureRecognizer;
    
    CGRect viewRect = self.view.frame;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(100,
                                                               0,
                                                               CGRectGetHeight(viewRect)-100,
                                                               CGRectGetWidth(viewRect))
                                              style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor blueColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}

-(void)mapMove:(CGFloat)y{
    CGFloat newY = self.buttonMap.position.y-y;
    if (yLength>self.size.height) {
        newY = MAX(self.size.height-30, newY);
        newY = MIN(self.size.height+yLength-300, newY);
    } else {
        newY = self.buttonMap.position.y;
    }
    
    self.buttonMap.position = CGPointMake(self.buttonMap.position.x, newY);
}

-(void)handlePanFrom:(UIPanGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint pointInMap = [self convertPointFromView:[recognizer locationInView:self.view]];
        if (pointInMap.x > 100) {
            [self mapMove:[recognizer translationInView:self.view].y];
        }
        [recognizer setTranslation:CGPointZero inView:self.view];
        
    }
}

-(void)presentMainScene{
    [self.view removeGestureRecognizer:self.swipeRecognizer];
    [self.view removeGestureRecognizer:self.tapRecognizer];
    [_tableView removeFromSuperview];
    [self.view presentScene:mScene
                 transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.5]];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
            [self presentMainScene];
        }
    }
}

-(void)buttonTouchUp:(NSUInteger)index{
    ButtonSprite* newSelectButton;
    
    if (index != 0) {
        
        for (ButtonSprite*button in self.buttonMap.children) {
            if (self.selectButton) {
                if (button.button_id>index && button.button_id<=self.selectButton.button_id) {
                    SKAction* action = [SKAction moveByX:0 y:-20 duration:0.2];
                    [button runAction:action];
                } else if (button.button_id<=index && button.button_id>self.selectButton.button_id){
                    [button runAction:[SKAction moveByX:0 y:20 duration:0.2]];
                }
            } else {
                if (button.button_id>index) {
                    SKAction* action = [SKAction moveByX:0 y:-20 duration:0.2];
                    [button runAction:action];
                }
            }
            if (button.button_id == index) {
                newSelectButton = button;
            }
        }
        
        if (index == self.selectButton.button_id) {
            self.selectButton = nil;
            [self removeButtons];
            
        } else {
            if (self.selectButton) {
                [self removeButtons];
            }
            self.selectButton = newSelectButton;
            
            CGPoint selectPos = [self convertPoint:self.selectButton.position fromNode:self.buttonMap];
            
            CGFloat posX = selectPos.x - self.selectButton.size.width/2 + 25;
            CGFloat posY = selectPos.y - self.selectButton.size.height/2 - 20;
            
            SKSpriteNode* saveButton = [SKSpriteNode spriteNodeWithImageNamed:@"save_button"];
            saveButton.name = @"save";
            saveButton.position = CGPointMake(posX, posY);
            [self addChild:saveButton];
            
            posX += 60;
            SKSpriteNode* loadButton = [SKSpriteNode spriteNodeWithImageNamed:@"load_button"];
            loadButton.name = @"load";
            loadButton.position = CGPointMake(posX, posY);
            [self addChild:loadButton];
            
            posX += 60;
            SKSpriteNode* removeButton = [SKSpriteNode spriteNodeWithImageNamed:@"remove_button"];
            removeButton.name = @"remove";
            removeButton.position = CGPointMake(posX, posY);
            [self addChild:removeButton];
        }
    }else{
        for (ButtonSprite*button in self.buttonMap.children) {
            if (button.button_id > self.selectButton.button_id) {
                [button runAction:[SKAction moveByX:0 y:20 duration:0.2]];
            }
        }
        if (self.selectButton) {
            [self removeButtons];
        }
        self.selectButton = nil;
        
    }
}

-(void)removeButtons{
    SKNode* saveButton = [self childNodeWithName:@"save"];
    SKNode* loadButton = [self childNodeWithName:@"load"];
    SKNode* removeButton = [self childNodeWithName:@"remove"];
    
    SKAction* fade = [SKAction fadeOutWithDuration:0.2];
    SKAction* remove = [SKAction removeFromParent];
    SKAction* actions = [SKAction sequence:@[fade,remove]];
    
    [saveButton runAction:actions];
    [loadButton runAction:actions];
    [removeButton runAction:actions];
    
    
}

-(void)setupAddAlertView{
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
            [self saveMapWithFileName:textField.text];
        }
        
    }
}

-(void)saveMapWithFileName:(NSString*)name{
    lockButton = YES;
    [mMap performSelectorInBackground:@selector(saveMap:) withObject:name];
}

-(void)loadMapWithFileName:(NSString*)name{
    lockButton = YES;
    [mMap killAllGates];
    [mMap performSelectorInBackground:@selector(loadMap:) withObject:name];
}

-(void)removeMapWithFileName:(NSString*)name{
    [mMap performSelectorInBackground:@selector(removeMapFile:) withObject:name];
}

-(void)handleTapFrom:(UITapGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint pointInScene = [self convertPointFromView:[recognizer locationInView:self.view]];
        SKNode* node = [self nodeAtPoint:pointInScene];
        if (node && !lockButton) {
            if ([node.name isEqualToString:@"BUTTON"]) {
                ButtonSprite* button;
                if ([node isKindOfClass:[ButtonSprite class]]) {
                    button = (ButtonSprite*)node;
                }else if([node isKindOfClass:[SKLabelNode class]]){
                    button = (ButtonSprite*)node.parent;
                }
                if (button) {
                    if ([button isEqual:self.selectButton]) {
                        [self buttonTouchUp:0];
                    } else {
                        [self buttonTouchUp:button.button_id];
                    }
                }
            } else if ([node isEqual:self.addButton]){
                
                [self setupAddAlertView];
                
            } else if ([node isEqual:self.backButton]){
                
                [self presentMainScene];
                
            } else if ([node.name isEqualToString:@"save"] && self.selectButton){
                [self removeButtons];
                NSString*name = [mMap.filesList objectAtIndex:self.selectButton.button_id];
                [self saveMapWithFileName:name];
                
            } else if ([node.name isEqualToString:@"load"] && self.selectButton){
                [self removeButtons];
                NSString*name = [mMap.filesList objectAtIndex:self.selectButton.button_id];
                [self loadMapWithFileName:name];
                
            } else if ([node.name isEqualToString:@"remove"] && self.selectButton){
                [self removeButtons];
                NSString*name = [mMap.filesList objectAtIndex:self.selectButton.button_id];
                [self removeMapWithFileName:name];
                
            }
        }
        
    }
    
}

-(void)fileDidSave{
    lockButton = false;
}

-(void)fileDidLoad{
    lockButton = false;
}


@end
