//
//  PortDelegate.h
//  Logic Gates
//
//  Created by Edward Guo on 2014-06-21.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(BOOL, PortType){
    InputPortType,
    OutputPortType
};

@protocol PortDelegate <NSObject>
@optional
-(void)portRealInputDidChange:(PortType)portType;
-(void)portBoolStatusDidChange:(PortType)portType;
-(void)portPositionDidChange;
-(void)portWillRemoveWires;
@end

