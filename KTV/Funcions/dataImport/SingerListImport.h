//
//  SingerListImport.h
//  ZZKTV
//
//  Created by stevenhu on 15/4/11.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Singer,SingerListImport;
@protocol SingerListImportDelegate <NSObject>
@optional
// Notification posted by NSManagedObjectContext when saved.
- (void)importerDidSave:(NSNotification *)saveNotification;
// Called by the importer when parsing is finished.
- (void)importerDidFinishParsingData:(SingerListImport *)importer;
// Called by the importer in the case of an error.
- (void)importer:(SingerListImport *)importer didFailWithError:(NSError *)error;
@end
@interface SingerListImport : NSOperation
@property (nonatomic, retain,readonly) NSURL *singerListURL;
@property (nonatomic, assign) id <SingerListImportDelegate> delegate;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong,readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSEntityDescription *singerEntityDescription;
@property (nonatomic, strong, readonly) NSPredicate *singerNamePredicateTemplate;

- (void)main;
//- (Singer *)singerWithName:(NSString *)name;
@end
