//
//  DataManger.m
//  Logic Gates
//
//  Created by edguo on 3/7/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "DataManger.h"
#define currentFormatVersion 1

@implementation DataManger
-(id)init{
    if (self = [super init]) {
        self.saveFileList = nil;
        int attempt = 0;
        while (!self.saveFileList) {
            attempt++;
            NSString* saveListPath = [self getSaveListPath];
            if (![[NSFileManager defaultManager]fileExistsAtPath:saveListPath]) {
                [self createSaveFileNameList];
            }
            NSArray* array = [NSArray arrayWithContentsOfFile:saveListPath];
            NSNumber* version = [array objectAtIndex:0];
            if ([version isEqualToNumber:[NSNumber numberWithInt:currentFormatVersion]]) {
                self.saveFileList = array;
                break;
            }else{
                [self removeSaveDir];
                [self createSaveFileNameList];
            }
            if (attempt>3) {
                break;
            }
        }

    }
    return self;
}

-(void)saveMap:(NSString*)name NodeArray:(NSMutableArray*)array{
    //array Structure
    //-type
    //-x(float)
    //-y(float)
    //-Bool State
    //-In Port Array & Out Port Array
    //--Gate Index
    //--Port Index
    NSString* path = [[self getSaveDir] stringByAppendingPathComponent:[name stringByAppendingString:@".plist"]];
    BOOL noError = [array writeToFile:path atomically:YES];
    if (noError) {
        self.saveFileList = [self.saveFileList arrayByAddingObject:name];
    }
}

-(NSArray*)readMap:(NSString*)name{
    NSString* filePath = [[self getSaveDir] stringByAppendingPathComponent:[name stringByAppendingString:@".plist"]];
    if (![[NSFileManager defaultManager]fileExistsAtPath:name]) {
        return nil;
    }
    return [NSArray arrayWithContentsOfFile:filePath];
}

-(void)removeSaveDir{
    NSError *error;
    [[NSFileManager defaultManager]removeItemAtPath:[self getSaveDir] error:&error];
}

-(NSString*)getSaveDir{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    return [docPath stringByAppendingPathComponent:@"save"];
}

-(NSString*)getSaveListPath{
    return [[self getSaveDir] stringByAppendingString:@"saveList.plist"];
}
-(void)createSaveFileNameList{
    NSArray* array = [NSArray arrayWithObject:[NSNumber numberWithInt:currentFormatVersion]];
    [array writeToFile:[self getSaveListPath] atomically:YES];
}

@end
