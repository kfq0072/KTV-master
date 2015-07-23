//
//  listImport.h
//  ZZKTV
//
//  Created by stevenhu on 15/4/11.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Song,SonglistImport;
@protocol SongListImportDelegate <NSObject>
@optional
// Notification posted by NSManagedObjectContext when saved.
- (void)importerDidSave:(NSNotification *)saveNotification;
// Called by the importer when parsing is finished.
- (void)importerDidFinishParsingData:(SonglistImport *)importer;
// Called by the importer in the case of an error.
- (void)importer:(SonglistImport *)importer didFailWithError:(NSError *)error;
@end

@interface SonglistImport : NSOperation
@property (nonatomic, retain) NSURL *songListURL;
@property (nonatomic, assign) id <SongListImportDelegate> delegate;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectContext *insertionContext;
@property (nonatomic, retain, readonly) NSEntityDescription *songEntityDescription;
- (void)main;
@end
