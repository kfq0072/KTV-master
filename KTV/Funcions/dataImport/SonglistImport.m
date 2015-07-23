//
//  listImport.m
//  ZZKTV
//
//  Created by stevenhu on 15/4/11.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import "SonglistImport.h"
#import "Song.h"
#import "Singer.h"
#import "SingerListImport.h"

@interface SonglistImport () {
    @private
    NSString *localSLPath;
}

@end

@implementation SonglistImport
@synthesize songListURL, delegate, persistentStoreCoordinator,insertionContext,songEntityDescription,singerImport;

- (void)main {
    if (delegate && [delegate respondsToSelector:@selector(importerDidSave:)]) {
        [[NSNotificationCenter defaultCenter]addObserver:delegate selector:@selector(importerDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.insertionContext];
    }
    //1. request web data download file
//    NSURLRequest *request=[NSURLRequest requestWithURL:songListURL];
//    connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    //2. parsing txt file
    if (![self checkFileExist:@"songlist.txt"])  return;
    NSError *error;
    NSString *contentStr=[NSString stringWithContentsOfFile:localSLPath encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        NSArray *totalLinesArray=[contentStr componentsSeparatedByString:@"\r\n"];
        totalLinesArray=[self clearWhite:totalLinesArray];
        for (NSString *onelineContext in totalLinesArray) {
            NSArray *oneLineArray=[onelineContext componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
             NSLog(@"%@",oneLineArray);
//
        }
       
    }

}

- (NSArray*)clearWhite:(NSArray*)array {
    static BOOL a=NO;
    NSMutableArray *arr=[array mutableCopy];
    for (int i=0;i<array.count;i++) {
        if ([array[i] isEqualToString:@""])
           [arr removeObjectAtIndex:i];
//            if (a)  NSLog(@"---<%@>",array[i]);
        
        }
    a=YES;
    return arr;
}

- (BOOL)checkFileExist:(NSString*)fileName {
    NSFileManager *manager=[NSFileManager defaultManager];
    localSLPath=[[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    return [manager fileExistsAtPath:localSLPath]?YES:NO;
}

- (NSManagedObjectContext*)insertionContext {
    if (insertionContext==nil) {
        insertionContext=[[NSManagedObjectContext alloc]init];
        [insertionContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return insertionContext;
}

- (SingerListImport*)singerImport {
    if (singerImport==nil) {
        singerImport=[[SingerListImport alloc]init];
//        singerImport.
    }
    return nil;
}

- (NSEntityDescription*)songEntityDescription {
    if (songEntityDescription==nil) {
        songEntityDescription=[NSEntityDescription entityForName:@"Song" inManagedObjectContext:self.insertionContext];
    }
    return songEntityDescription;
}


- (void)forwardError:(NSError*)error {
    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(importer:didFailWithError:)]) {
        [self.delegate importer:self didFailWithError:error];
    }
}
@end
