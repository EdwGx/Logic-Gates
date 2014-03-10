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
            if (![[NSFileManager defaultManager]fileExistsAtPath:[self getSaveDir]]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:[self getSaveDir]
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:nil];
            }
            NSString* saveListPath = [self getSaveListPath];
            if (![[NSFileManager defaultManager]fileExistsAtPath:saveListPath]) {
                [self createSaveFileNameList];
            }
            NSArray* array = [NSArray arrayWithContentsOfFile:saveListPath];
            NSNumber* version = [array objectAtIndex:0];
            if ([version isEqualToNumber:[NSNumber numberWithInt:currentFormatVersion]]) {
                self.saveFileList = [NSMutableArray arrayWithArray:array];
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
        [self.saveFileList addObject:name];
        [self performSelectorInBackground:@selector(writeSafeList) withObject:nil];
    }
}

-(void)writeSafeList{
    [self.saveFileList writeToFile:[self getSaveListPath] atomically:YES];
}

-(NSArray*)readMap:(NSString*)name{
    NSString* filePath = [[self getSaveDir] stringByAppendingPathComponent:[name stringByAppendingString:@".plist"]];
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
    return [[self getSaveDir] stringByAppendingPathComponent:@"saveList.plist"];
}
-(void)createSaveFileNameList{
    NSArray* array = [NSArray arrayWithObject:[NSNumber numberWithInt:currentFormatVersion]];
    [array writeToFile:[self getSaveListPath] atomically:YES];
}

@end
