//
//  importManager.h
//  ZZKTV
//
//  Created by stevenhu on 15/4/11.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//typedef void(^OperationResult)(NSError *error);

@interface importManager : NSObject
// Properties for the importer and its background processing queue.
@property (nonatomic,strong)NSOperationQueue *operationQueue;

/**
 import singers
 */
// Properties for the Core Data stack.
@property (nonatomic, strong) NSPersistentStoreCoordinator *singersPersistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *singersManagedObjectContext;
@property (nonatomic, strong) NSString *persistentStorePath;

/**
 import songs
 */
// Properties for the Core Data stack.
@property (nonatomic, strong) NSPersistentStoreCoordinator *songsPersistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *songsManagedObjectContext;

//- (NSError*)save:(OperationResult)handler;
+ (instancetype)sharedInstance;
- (BOOL)importSingersDataFromURL:(NSURL*)url;
- (BOOL)importSongsDataFromURL:(NSURL*)url;
@end
