//
//  importManager.m
//  ZZKTV
//
//  Created by stevenhu on 15/4/11.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import "importManager.h"
static importManager *_sharedInsatnce=nil;

@implementation importManager

//单列
+ (instancetype)sharedInstance {
    @synchronized(self) {
        if(_sharedInsatnce==nil) {
            _sharedInsatnce=[[self alloc]init];
        }
    }
    return _sharedInsatnce;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInsatnce=[super allocWithZone:zone];
    });
    return _sharedInsatnce;
}

#pragma mark- Import Singers Data

- (BOOL)importSingersDataFromURL:(NSURL*)url {
//    self.importer=[[SonglistImport alloc]init];
//    self.importer.delegate=self;
//    self.importer.persistentStoreCoordinator=self.persistentStoreCoordinator;
//    self.importer.songListURL=url;
//    self.managedObjectContext=self.vc.managedObjectContext;
    return YES;
}

-(void)startToImport {
//    [self.operationQueue addOperation:self.importer];
}

- (NSOperationQueue*)operationQueue {
    if (!_operationQueue) {
        _operationQueue=[[NSOperationQueue alloc]init];
    }
    return _operationQueue;
}


- (NSPersistentStoreCoordinator*)singersPersistentStoreCoordinator {
    if (!_singersPersistentStoreCoordinator) {
        NSURL *storUrl=[NSURL fileURLWithPath:self.persistentStorePath];
        _singersPersistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
        NSError *error;
        NSPersistentStore *persistentStore=[_singersPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storUrl options:nil error:&error];
          NSAssert3(persistentStore != nil, @"Unhandled error adding persistent store in %s at line %d: %@", __FUNCTION__, __LINE__, [error localizedDescription]);
    }
    return _singersPersistentStoreCoordinator;
}


- (NSManagedObjectContext*)singersManagedObjectContext {
    if (!_singersManagedObjectContext) {
        _singersManagedObjectContext=[[NSManagedObjectContext alloc]init];
        [_singersManagedObjectContext setPersistentStoreCoordinator:self.singersPersistentStoreCoordinator];
    }
    return _singersManagedObjectContext;
}

- (NSString*)persistentStorePath {
    if (!_persistentStorePath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths lastObject];
        _persistentStorePath = [documentsDirectory stringByAppendingPathComponent:@"SongList.sqlite"];
    }
    return _persistentStorePath;
}


- (void)importerDidSave:(NSNotification *)saveNotification {
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
//    });
}
                  
#pragma mark - Import Songs
@end
