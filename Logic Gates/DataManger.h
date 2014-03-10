//
//  DataManger.h
//  Logic Gates
//
//  Created by edguo on 3/7/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManger : NSObject
@property NSMutableArray* saveFileList;
-(void)saveMap:(NSString*)name NodeArray:(NSMutableArray*)array;
-(NSArray*)readMap:(NSString*)name;
@end
