//
//  MyScene.m
//  Logic Gates
//
//  Created by edguo on 2/24/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "MyScene.h"

#import "MapIOView.h"

#import "AND_Gate.h"
#import "OR_Gate.h"
#import "XOR_Gate.h"
#import "NOT_Gate.h"

#import "NAND_Gate.h"
#import "NOR_Gate.h"
#import "XNOR_Gate.h"

#import "LightBulb.h"
#import "Switch.h"

#import "Port.h"
#import "ButtonSprite.h"
#import "MPanGestureRecognizer.h"

@implementation MyScene{
    BOOL killMode;
    BOOL changingKillMode;
    BOOL menuMoving;
    BOOL menuOut;
    BOOL dragMap;
    BOOL normalMode;
    
    BOOL _dragNodeAnimation;
    CGPoint _dragNodeStartPosition;
    __weak SKNode* _dragNode;
    
    __weak MPanGestureRecognizer* _panRecognizer;
    __weak UILongPressGestureRecognizer* _longPressRecognizer;
    __weak UITapGestureRecognizer* _singleTapRecognizer;
    __weak UITapGestureRecognizer* _doubleTapRecognizer;
    __weak UIPinchGestureRecognizer* _zoomRecognizer;
    
    __weak CornerView* _cornerView;
    __weak Gates* _cornerViewSelectedGate;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        
        SKTextureAtlas* gateTextureAtlas = [SKTextureAtlas atlasNamed:@"GateImages"];
        [gateTextureAtlas preloadWithCompletionHandler:^{
            self.selectionMenu = [Button spriteNodeWithImageNamed:@"menuArrow"];
            self.selectionMenu.zPosition = 16;
            self.selectionMenu.position = CGPointMake(0, size.height/2);
            [self addChild:self.selectionMenu];
            [self.selectionMenu setTouchDownTarget:self Action:@selector(touchSelectionMenuButton:)];
        }];

        killMode = NO;
        changingKillMode = NO;
        self.ModeChanger = [Button spriteNodeWithImageNamed:@"ModeImage"];
        self.ModeChanger.zPosition = 10;
        self.ModeChanger.position = CGPointMake(size.width-30, 30);
        SKAction *action1 = [SKAction rotateToAngle:0.25*M_PI duration:0];
        [self.ModeChanger runAction:action1];
        [self addChild:self.ModeChanger];
        [self.ModeChanger setTouchDownTarget:self Action:@selector(touchModeChanger:)];

        normalMode = YES;

        self.map = [[CircuitMap alloc]initMapWithDelegate:self];
        [self addChild:self.map];
    }
    return self;
}

-(void)touchSelectionMenuButton:(Button*)button{
    if (!menuMoving) {
        if (menuOut) {
            [self moveMenuIn];
        }else{
            [self moveMenuOut];
        }
    }
}

-(void)touchModeChanger:(Button*)button{
    if (normalMode&&!self.selectSp){
        if (!changingKillMode) {
            killMode = !killMode;
            [self.ModeChanger runAction:[SKAction rotateByAngle:1.75*M_PI duration:0.5]completion:^{
                changingKillMode = NO;}];
        }
    }
}

-(void)didMoveToView:(SKView *)view{
    [super didMoveToView:view];
    //Setup GestureRecognizers
    UIPinchGestureRecognizer* pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchFrom:)];
    UITapGestureRecognizer* doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTapFrom:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    doubleTapGestureRecognizer.enabled = NO;
    [[self view] addGestureRecognizer:pinchGestureRecognizer];
    [[self view] addGestureRecognizer:doubleTapGestureRecognizer];
    _doubleTapRecognizer = doubleTapGestureRecognizer;
    _zoomRecognizer = pinchGestureRecognizer;
    
    MPanGestureRecognizer* panGestureRecognizer = [[MPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    _panRecognizer = panGestureRecognizer;
    
    
    UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressFrom:)];
    [self.view addGestureRecognizer:longPressGestureRecognizer];
    _longPressRecognizer = longPressGestureRecognizer;
    
    
    UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    _singleTapRecognizer = singleTapGestureRecognizer;
    _singleTapRecognizer.cancelsTouchesInView = NO;
}

-(void)handlePanFrom:(MPanGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        if (!self.selectSp) {
            CGPoint currentLocation = [self convertPoint:[self.view convertPoint:[recognizer locationInView:self.view] toScene:self] toNode:self.map];
            CGPoint startLocation = [self convertPoint:[self.view convertPoint:recognizer.startLocation toScene:self] toNode:self.map];
            
            SKNode* node = [self nodeAtPoint:startLocation];
            if ([node isKindOfClass:[Gates class]]&&normalMode) {
                Gates* gateNode = (Gates*)node;
                Port * portNode = [gateNode portCloseToPointInScene:startLocation Range:0.5];
                if (portNode) {
                    //[portNode removeAllWire];
                    if ([portNode isAbleToConnect]) {
                        self.dragWire = [[Wire alloc]initWithAnyPort:portNode andStartPosition:currentLocation];
                        [self.map addChild:self.dragWire];
                    }
                }
            }else if ([self nodeIsEmptySpace:node]){
                Port* portNode = [self findPortCloseToLocation:startLocation];
                if (!portNode) {
                    dragMap = YES;
                }else{
                    if (killMode) {
                        [portNode removeAllWire];
                    } else {
                        if ([portNode isAbleToConnect]) {
                            self.dragWire = [[Wire alloc]initWithAnyPort:portNode andStartPosition:currentLocation];
                            [self.map addChild:self.dragWire];
                        }
                    }
                }
            }
            [recognizer setTranslation:CGPointZero inView:self.view];
        }
        
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        
        if (self.dragWire){
            [self.dragWire drawLineWithPosition:[self convertPoint:[self.view convertPoint:[recognizer locationInView:self.view] toScene:self] toNode:self.map]];
        } else if (dragMap){
            
            CGPoint translation = [recognizer translationInView:self.view];
            translation = CGPointMake(translation.x, -translation.y);
            
            [self.map moveByPoint:translation];
            
        }
        [recognizer setTranslation:CGPointZero inView:self.view];
        
    }else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
        
        if (self.dragWire) {
            [self dragWireEndWithLocation:[self convertPoint:[self.view convertPoint:[recognizer locationInView:self.view] toScene:self] toNode:self.map]];
            self.dragWire = nil;
        }
        if (dragMap) {
            dragMap = NO;
        }
        [recognizer setTranslation:CGPointZero inView:self.view];
        
    }
}

-(void)handleLongPressFrom:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchLocation = [self convertPoint:[self.view convertPoint:[recognizer locationInView:self.view] toScene:self] toNode:self.map];
        SKNode* node = [self.map nodeAtPoint:touchLocation];
        
        BOOL startDragNode = NO;
        
        if (([node isKindOfClass:[Gates class]]&&normalMode)&&!self.selectSp) {
            Gates* gateNode = (Gates*)node;
            _dragNodeStartPosition = touchLocation;
            _dragNode = gateNode;
            startDragNode = YES;
            [gateNode updatePortPositonInDurtion:0.17];
        } else if (self.selectSp && !menuMoving) {
            CGPoint location = [self.view convertPoint:[recognizer locationInView:self.view] toScene:self];
            SKNode* node = [self nodeAtPoint:location];
            if (node) {
                if ([[node parent]isEqual:self.selectSp]){
                    NSUInteger type = [self.selectSp getTouchGateTypeWithName:node.name];
                    if (type != 0) {
                        node.alpha = 0.0;
                        
                        Gates* newGate = [self createNewGate:type];
                        if (newGate) {
                            [self.map addChild:newGate];
                            _dragNodeStartPosition = touchLocation;
                            _dragNode = newGate;
                            _dragNode.position = touchLocation;
                            startDragNode = YES;
                            [newGate updatePortPositonInDurtion:0.17];
                        }
                    }
                }
            }
        }
        
        if (startDragNode) {
            SKAction* transparent = [SKAction fadeAlphaTo:0.8 duration:0.15];
            SKAction* scale = [SKAction scaleTo:1.2 duration:0.15];
            SKAction* group = [SKAction group:@[transparent,scale]];
            [_dragNode runAction:group];
            _dragNode.zPosition += 1;
            [_dragNode runAction:[SKAction moveTo:_dragNodeStartPosition duration:0.15] withKey:@"snap"];
            _dragNodeAnimation = YES;
        }
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        
        if (_dragNode) {
            if (_dragNodeAnimation) {
                [_dragNode removeActionForKey:@"snap"];
                _dragNodeAnimation = NO;
            }
            _dragNode.position = [self convertPoint:[self.view convertPoint:[recognizer locationInView:self.view] toScene:self] toNode:self.map];
        }
        
    }else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
        
        if (_dragNode) {
            CGPoint currentLocation = [self convertPoint:[self.view convertPoint:[recognizer locationInView:self.view] toScene:self] toNode:self.map];
            
            _dragNode.position = currentLocation;
            if ([_dragNode isKindOfClass:[Gates class]]) {
                [(Gates*)_dragNode updatePortPositonInDurtion:0.1];
            }
            
            SKAction* transparent = [SKAction fadeAlphaTo:1.0 duration:0.1];
            SKAction* scale = [SKAction scaleTo:1.0 duration:0.1];
            SKAction* group = [SKAction group:@[transparent,scale]];
            
            [_dragNode runAction:group];

            _dragNode.zPosition -= 1;
            
            _dragNode = nil;
        }
        
    }
}

-(void)handleSingleTapFrom:(UITapGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (!self.selectSp) {
            CGPoint touchLocation = [self convertPoint:[self.view convertPoint:[recognizer locationInView:self.view] toScene:self] toNode:self.map];
            SKNode* node = [self.map nodeAtPoint:touchLocation];
            if ([node isKindOfClass:[Gates class]]&&normalMode) {
                Gates* gateNode = (Gates*)node;
                if (killMode) {
                    [gateNode kill];
                }else{
                    SKLabelNode* label = [SKLabelNode labelNodeWithFontNamed:@"Avenir-Roman"];
                    label.text = [gateNode gateName];
                    label.fontSize = 12;
                    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
                    label.position = CGPointMake(gateNode.position.x, gateNode.position.y - gateNode.size.height);
                    [self.map addChild:label];
                    
                    SKAction* wait = [SKAction waitForDuration:2];
                    SKAction* disappear = [SKAction fadeOutWithDuration:1];
                    SKAction* remove = [SKAction removeFromParent];
                    SKAction* sequence = [SKAction sequence:@[wait,disappear,remove]];
                    [label runAction:sequence];
                    
                    GateType type = gateNode.gateType;
                    if ((type == GateTypeLightBulb && gateNode.realInput)|| type == GateTypeSwitch) {
                        if (_cornerView) {
                            _cornerView.selectedGate = gateNode;
                        }else{
                            CornerView* cView = [[CornerView alloc] initWithFrame:self.view.frame SelectedGate:gateNode];
                            [self.view addSubview:cView];
                            _cornerView = cView;
                            [_cornerView showUp];
                            
                        }
                    }
                }
            }
        }
    }
}


-(void)presentMapFileScene{
    [self.view removeGestureRecognizer:_doubleTapRecognizer];
    [self.view removeGestureRecognizer:_zoomRecognizer];
    
    MapIOView * mioView = [[MapIOView alloc]initWithFrame:CGRectMake(0, 0,
                                                                     CGRectGetHeight(self.view.frame),
                                                                     CGRectGetWidth(self.view.frame))
                                                    Scene:self
                                                      Map:self.map];
    //self.view.userInteractionEnabled = NO;
    [self.view addSubview:mioView];
}

-(void)handlePinchFrom:(UIPinchGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self.map setScale:recognizer.scale*self.map.xScale];
        if (self.map.xScale == 1.0) {
            [self updateZoomMode:YES];
            _doubleTapRecognizer.enabled = NO;
        }else{
            [self updateZoomMode:NO];
            _doubleTapRecognizer.enabled = YES;
        }
        recognizer.scale = 1.0;
    }
}

-(void)updateZoomMode:(BOOL)new{
    if (new != normalMode) {
        normalMode = new;
        if (!normalMode) {
            [self.ModeChanger runAction:[SKAction moveByX:0 y:-60 duration:0.2]];
            [self.selectionMenu runAction:[SKAction moveByX:-50 y:0 duration:0.2]];
        } else {
            [self.ModeChanger runAction:[SKAction moveByX:0 y:60 duration:0.2]];
            [self.selectionMenu runAction:[SKAction moveByX:50 y:0 duration:0.2]];
        }
    }
}

-(void)handleDoubleTapFrom:(UITapGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded && self.map.xScale != 1.0) {
        CGPoint pointInScene = [self convertPointFromView:[recognizer locationInView:self.view]];
        CGPoint targetPoint = [self convertPoint:pointInScene toNode:self.map];
        CGPoint centerPoint = [self convertPoint:CGPointMake(self.size.width/2.0,self.size.height/2.0) toNode:self.map];
        CGVector vector = CGVectorMake(centerPoint.x - targetPoint.x, centerPoint.y -targetPoint.y);

        [self.map runAction:[SKAction moveBy:vector duration:0.2]];
        [self.map runAction:[SKAction scaleTo:1.0 duration:0.2]];
        [self updateZoomMode:YES];

        _doubleTapRecognizer.enabled = NO;
    }
}

-(BOOL) nodeIsEmptySpace:(SKNode*)node{
    return ([node isEqual:self]||[node isEqual:self.map]);
}

-(void)moveMenuIn{
    menuMoving = YES;
    menuOut = NO;
    SKAction *action = [SKAction moveByX:-self.size.width+20 y:0 duration:0.5];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *maction = [SKAction sequence:@[action,remove]];
    SKAction *spin = [SKAction rotateByAngle:-M_PI duration:0.5];
    [self.selectSp runAction:maction completion:^{
        self.selectSp = nil;
    }];
    [self.selectionMenu runAction:spin];
    [self.selectionMenu runAction:action completion:^{
        menuMoving = NO;
    }];
}

-(void)moveMenuOut{
    menuMoving = YES;
    self.selectSp = [[SelectionSprite  alloc]initWithScene:self Size:self.size];
    self.selectSp.zPosition = 15;
    SKAction *action = [SKAction moveByX:self.size.width-20 y:0 duration:0.5];
    SKAction *spin = [SKAction rotateByAngle:M_PI duration:0.5];
    [self addChild:self.selectSp];
    [self.selectSp runAction:action];
    [self.selectionMenu runAction:spin];
    [self.selectionMenu runAction:action completion:^{
        menuMoving = NO;
        menuOut = YES;
    }];
}

-(Port*)findPortCloseToLocation:(CGPoint)point{
    //Loop every Nodes in map
    for (SKNode* childNode in [self.map children]) {
        //Check if the child node is a Gate
        if ([childNode isKindOfClass:[Gates class]]) {
            Gates* gChild = (Gates*)childNode;
            //Check if location collide with a max possible rectangle
            if ([gChild isPossibleHavePortCloseToPoint:point]) {
                Port* cloestPort = [gChild portCloseToPointInScene:point Range:1.0];
                //if closetPort is nil means nothing
                if (cloestPort) {
                    return cloestPort;
                }
            }
        }
    }
    return nil;
}


-(Gates*)createNewGate:(NSUInteger)type{
    Gates* newGate;
    switch (type) {
        case 1:
            newGate = [[AND_Gate alloc]initGate];
            break;

        case 2:
            newGate = [[OR_Gate alloc]initGate];
            break;

        case 3:
            newGate = [[XOR_Gate alloc]initGate];
            break;

        case 4:
            newGate = [[NAND_Gate alloc]initGate];
            break;

        case 5:
            newGate = [[NOR_Gate alloc]initGate];
            break;

        case 6:
            newGate = [[XNOR_Gate alloc]initGate];
            break;

        case 7:
            newGate = [[NOT_Gate alloc]initGate];
            break;

        case 8:
            newGate = [[Switch alloc]initGate];
            break;

        case 9:
            newGate = [[LightBulb alloc]initGate];
            break;

        default:
            newGate = nil;
            break;
    }
    if (newGate) {
        SKAction* back = [SKAction runBlock:^{
            self.selectionMenu.position = CGPointMake(-30, self.size.height/2);
        }];
        SKAction* spin = [SKAction rotateToAngle:0 duration:0.2];
        SKAction* showUp = [SKAction moveToX:0 duration:0.2];
        SKAction* allActions = [SKAction sequence:@[back,spin,showUp]];

        menuMoving = YES;
        [self.selectionMenu runAction:allActions completion:^{
            menuOut = NO;
            menuMoving = NO;
        }];
        [self.selectSp removeFromParent];
        self.selectSp = nil;
        
        return newGate;
    }
    return nil;
}



-(void)dragWireEndWithLocation:(CGPoint)point{
    SKNode* node = [self nodeAtPoint:[self convertPoint:point toNode:self.map]];
    if ([node isKindOfClass:[Gates class]]) {
        Gates*GNode = (Gates*)node;
        Port *inNode = [GNode portCloseToPointInScene:[self convertPoint:point toNode:self.map] Range:1.0];
        if (inNode) {
            //Check that Port can connect one more wire.
            if ([inNode isAbleToConnect]) {
                [self.dragWire connectNewPort:inNode];
                return;
            }
        }
    }else if ([node isEqual:self]||[node isKindOfClass:[Wire class]]||[node isEqual:self.map]){
        for (SKNode* childNode in [self.map children]) {
            if ([childNode isKindOfClass:[Gates class]]) {
                Gates* gChild = (Gates*)childNode;
                CGPoint loc = [self convertPoint:lastTouchLocation toNode:self.map];
                if ([gChild isPossibleHavePortCloseToPoint:loc]) {
                    Port* cloestPort = [gChild portCloseToPointInScene:loc Range:1.0];
                    if ([cloestPort isAbleToConnect]) {
                        [self.dragWire connectNewPort:cloestPort];
                        return;
                    }
                }
            }
        }
    }
    [self.dragWire kill];
}


-(CGSize)getScreenSize{
    return self.size;
}

-(void)touchSaveMapButton:(Button*)button{
    if (!self.selectSp) {
        [self presentMapFileScene];
    }
}

-(void)fileSystemDidSetup{
    self.saveMapButton = [Button spriteNodeWithImageNamed:@"menu"];
    self.saveMapButton.zPosition = 10;
    self.saveMapButton.position = CGPointMake(self.size.width-30, self.size.height-60);
    [self addChild:self.saveMapButton];
    [self.saveMapButton setTouchDownTarget:self Action:@selector(touchSaveMapButton:)];
}


@end
