//
//  CircuitMap.m
//  Logic Gates
//
//  Created by edguo on 3/5/2014.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "CircuitMap.h"
#import "Gates.h"

#define minZoomOut 0.25
#define formatVersion 1

@implementation CircuitMap{
    CGFloat maxPosX,maxPosY,minPosX,minPosY;
    CGFloat currentScale;
    
}

-(id)initMapWithDelegate:(id<circuitMapDelegate>)delegate{
    if (self = [super init]) {
        self.delegate = delegate;
        [self setScale:1.0];
        self.isFileSystemWork = NO;
        [self performSelectorInBackground:@selector(setupFileSystem) withObject:nil];
    }
    return self;
}

-(void)updateBound{
    CGSize fullSize = [self.delegate getScreenSize];
    CGSize halfScene = CGSizeMake(fullSize.width/2, fullSize.height/2);
    
    maxPosX = (halfScene.width*currentScale)/minZoomOut;
    minPosX = halfScene.width*2.0 - maxPosX;
    
    maxPosY = (halfScene.height*currentScale)/minZoomOut;
    minPosY = halfScene.height*2.0 - maxPosY;
}

-(void)setPosition:(CGPoint)position{
    [super setPosition:[self boundPosition:position]];
}

-(void)moveByPoint:(CGPoint)point{
    self.position = CGPointMake(self.position.x+point.x, self.position.y+point.y);
}

-(CGPoint)boundPosition:(CGPoint)point{
    point.x = MIN(maxPosX, point.x);
    point.x = MAX(minPosX, point.x);
    
    point.y = MIN(maxPosY, point.y);
    point.y = MAX(minPosY, point.y);
    return point;
}

-(void)saveMap:(NSString*)fileName{
    NSMutableArray* nodeArray = [NSMutableArray arrayWithArray:[self children]];
    for (NSInteger k = [nodeArray count] - 1; k >= 0; k--) {
        if (![[nodeArray objectAtIndex:k] isKindOfClass:[Gates class]]) {
            [nodeArray removeObjectAtIndex:k];
        }
    }
    if ([nodeArray count] == 0) {
        return;
    }
    NSMutableArray* saveArray = [NSMutableArray arrayWithCapacity:[nodeArray count]];
    for (int j = 0;j < [nodeArray count];j++) {
        Gates*node = [nodeArray objectAtIndex:j];
        NSMutableArray* inArray = [NSMutableArray arrayWithCapacity:[node.inPort count]];
        for (int i = 0;i < [node.inPort count];i++){
            Port* inPort = [node.inPort objectAtIndex:i];
            NSNumber* gateIndex;
            NSNumber* portIndex;
            if (inPort.inWire) {
                gateIndex = [NSNumber numberWithInteger:
                                       [nodeArray indexOfObject:inPort.inWire.startGate]];
                portIndex = [NSNumber numberWithInteger:
                                       [inPort.inWire.startGate.outPort indexOfObject:inPort.inWire.startPort]];
            }else{
                gateIndex = [NSNumber numberWithInteger:-1];
                portIndex = [NSNumber numberWithInteger:-1];
            }
            NSArray* connectArray = [NSArray arrayWithObjects:gateIndex,portIndex, nil];
            [inArray setObject:connectArray atIndexedSubscript:i];
        }
        
        NSNumber* type = [NSNumber numberWithInt:node.gateType];
        NSNumber* posX = [NSNumber numberWithDouble:node.position.x];
        NSNumber* posY = [NSNumber numberWithDouble:node.position.y];
        NSNumber* status = [NSNumber numberWithBool:NO];
        
        NSArray*  gateSaveArray;
        if ([type isEqualToNumber:[NSNumber numberWithInt:8]]) {
            Port* outPort1 = [node.outPort objectAtIndex:0];
            status = [NSNumber numberWithBool:outPort1.boolStatus];
            NSString* name = [node.userData objectForKey:@"InputName"];
            gateSaveArray = [NSArray arrayWithObjects:type,posX,posY,status,inArray, name,nil];
        }else{
            gateSaveArray = [NSArray arrayWithObjects:type,posX,posY,status,inArray, nil];
        }
        [saveArray setObject:gateSaveArray atIndexedSubscript:j];
    }
    [saveArray addObject:fileName];
    [self performSelectorInBackground:@selector(saveMapToFileWithArray:) withObject:saveArray];
    
}

-(void)loadMap:(NSString*)fileName{
    NSArray*array = [self loadMapFromFile:fileName];
    if (!array) {
        return;
    }
    NSMutableArray*newGatesArray = [NSMutableArray arrayWithCapacity:[array count]];
    //Create Gates
    for (int i = 0;i<[array count];i++) {
        NSArray*subArray = [array objectAtIndex:i];
        //Fetching Type
        NSNumber*type = [subArray objectAtIndex:0];
        Gates*newGate = [self makeGateWithType:[type intValue]];
        if (!newGate){
            [self removeMapFile:fileName];
            return;
        }
        //X
        NSNumber* numX = [subArray objectAtIndex:1];
        CGFloat posX = [numX doubleValue];
        //Y
        NSNumber* numY = [subArray objectAtIndex:2];
        CGFloat posY = [numY doubleValue];
        //Setting Location
        newGate.position = CGPointMake(posX, posY);
        //Setting output
        NSNumber* status = [subArray objectAtIndex:3];
        if ([type isEqualToNumber:[NSNumber numberWithInt:8]]) {
            NSString* name = [subArray objectAtIndex:5];
            [newGate.userData setValue:name forKey:@"InputName"];
            if ([status isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                Port* outPort1 = [newGate.inPort objectAtIndex:0];
                outPort1.boolStatus = [status boolValue];
            }
        }
        [self addChild:newGate];
        [newGatesArray setObject:newGate atIndexedSubscript:i];
    }
    for (int i = 0;i<[array count];i++) {
        NSArray*subArray = [array objectAtIndex:i];
        NSArray*inArray = [subArray objectAtIndex:4];
        for (int j = 0;j<[inArray count];j++) {
            NSArray*indexArray = [inArray objectAtIndex:j];
            NSNumber* gateIndexNum = [indexArray objectAtIndex:0];
            NSNumber* portIndexNum = [indexArray objectAtIndex:1];
            int gateIndex = [gateIndexNum intValue];
            int portIndex = [portIndexNum intValue];
            if (gateIndex>=0 && portIndex>=0) {
                Gates* sGate = [newGatesArray objectAtIndex:gateIndex];
                Port* sPort = [sGate.outPort objectAtIndex:portIndex];
                
                Gates* eGate = [newGatesArray objectAtIndex:i];
                Port* ePort = [eGate.inPort objectAtIndex:j];
                
                Wire* newWire = [[Wire alloc]initWithStartPort:sPort EndPort:ePort];
                [self addChild:newWire];
            }
            
        }
    }
    if (self.fileIOMenu) {
        [self.fileIOMenu fileDidLoad];
    }
    
}

-(Gates*)makeGateWithType:(int)type{
    switch (type) {
        case 1:
            return  [[AND_Gate alloc]initGate];
            break;
            
        case 2:
            return [[OR_Gate alloc]initGate];
            break;
            
        case 3:
            return [[XOR_Gate alloc]initGate];
            break;
            
        case 4:
            return [[NAND_Gate alloc]initGate];
            break;
            
        case 5:
            return [[NOR_Gate alloc]initGate];
            break;
            
        case 6:
            return [[XNOR_Gate alloc]initGate];
            break;
            
        case 7:
            return [[NOT_Gate alloc]initGate];
            break;
            
        case 8:
            return [[Switch alloc]initGate];
            break;
            
        case 9:
            return [[LightBulb alloc]initGate];
            break;
            
        default:
            return nil;
            break;
    }
}

-(void)killAllGates{
    NSArray* childrenArray = [self children];
    for (SKNode*node in childrenArray) {
        if ([node isKindOfClass:[Gates class]]) {
            Gates* gNode = (Gates*)node;
            [gNode kill];
        }
    }
}
                          
-(void)setScale:(CGFloat)scale{
    currentScale = scale;
    currentScale = MIN(currentScale, 1.0);
    currentScale = MAX(currentScale, minZoomOut);
    
    [self updateBound];
    self.position = [self boundPosition:self.position];
    [super setScale:currentScale];
}

//Save&Load File Mangement
-(void)setupFileSystem{
    //Make sure save folder exist
    if (![[NSFileManager defaultManager]fileExistsAtPath:[self getSaveDirectory]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[self getSaveDirectory]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    //Make sure file list exist
    NSString* filesListPath = [self getFilesListPath];
    if (![[NSFileManager defaultManager]fileExistsAtPath:filesListPath]) {
        [self createFilesList];
    }
    
    //Make sure it use lastest version
    self.filesList = [NSMutableArray arrayWithContentsOfFile:filesListPath];
    NSNumber* version = [self.filesList objectAtIndex:0];
    if (![version isEqualToNumber:[NSNumber numberWithInt:formatVersion]]) {
        //Remove the old version
        [self removeSaveDirectory];
        
        //Create the new version
        [self createFilesList];
        
        //Load new list into array
        self.filesList = [NSMutableArray arrayWithContentsOfFile:filesListPath];
    }
    
    if ([self.filesList count] > 0 ) {
        self.isFileSystemWork = YES;
        [self.delegate fileSystemDidSetup];
    }else{
        self.isFileSystemWork = NO;
    }
}

-(void)refreshFilesList{
    if (self.isFileSystemWork) {
        self.filesList = [NSMutableArray arrayWithContentsOfFile:[self getFilesListPath]];
    }
}


-(void)saveMapToFileWithArray:(NSMutableArray*)array{
    //array Structure
    //-type
    //-x(float)
    //-y(float)
    //-Bool State
    //-In Port Array
    //--Gate Index
    //--Port Index
    NSString* name = [array lastObject];
    NSString* path = [self pathWithFileName:name];
    [array removeLastObject];
    BOOL noError = [array writeToFile:path atomically:YES];
    if (noError) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            if ([self.filesList indexOfObject:name] == NSNotFound) {
                [self.filesList addObject:name];
                [self performSelectorInBackground:@selector(writeFilesList) withObject:nil];
            }
        }
    }
    if (self.fileIOMenu) {
        [self.fileIOMenu fileDidSave];
    }
}

-(void)writeFilesList{
    [self.filesList writeToFile:[self getFilesListPath] atomically:YES];
}

-(NSArray*)loadMapFromFile:(NSString*)name{
    NSString* filePath = [self pathWithFileName:name];
    NSArray* newArray = [NSArray arrayWithContentsOfFile:filePath];
    if (newArray) {
        return newArray;
    }else{
        [self removeMapFile:name];
        return nil;
    }
}

-(void)removeMapFile:(NSString*)name{
    NSString* path = [self pathWithFileName:name];
    [self.filesList removeObject:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError* err;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&err];
    }
    [self performSelectorInBackground:@selector(writeFilesList) withObject:nil];
}

-(NSString*)pathWithFileName:(NSString*)name{
    return [[self getSaveDirectory] stringByAppendingPathComponent:[name stringByAppendingString:@".plist"]];
}

-(void)removeSaveDirectory{
    NSError *error;
    [[NSFileManager defaultManager]removeItemAtPath:[self getSaveDirectory] error:&error];
}

-(NSString*)getSaveDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    return [docPath stringByAppendingPathComponent:@"save"];
}

-(NSString*)getFilesListPath{
    return [[self getSaveDirectory] stringByAppendingPathComponent:@"filesList.plist"];
}
-(void)createFilesList{
    NSArray* array = [NSArray arrayWithObject:[NSNumber numberWithInt:formatVersion]];
    [array writeToFile:[self getFilesListPath] atomically:YES];
}


@end
