//
//  Song.h
//  KTV
//
//  Created by stevenhu on 15/4/24.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"
#import "HuToast.h"
@class Song;
@protocol SongDelegate <NSObject>
@optional
- (void)addSongToCollection:(Song*)oneSong result:(KMessageStyle)result;
- (void)deleteCollectionSong:(Song*)oneSong result:(KMessageStyle)result;
- (void)dingGeFromCollection:(Song*)oneSong result:(KMessageStyle)result;
- (void)cutSongFromCollection:(Song*)oneSong result:(KMessageStyle)result;
@end

@interface Song : NSObject
@property (nonatomic, copy) NSString * addtime;
@property (nonatomic, copy) NSString * bihua;
@property (nonatomic, copy) NSString * channel;
@property (nonatomic, copy) NSString * language;
@property (nonatomic, copy) NSString * movie;
@property (nonatomic, copy) NSString * newsong;
@property (nonatomic, copy) NSString * number;
@property (nonatomic, copy) NSString * pathid;
@property (nonatomic, copy) NSString * sex;
@property (nonatomic, copy) NSString * singer;
@property (nonatomic, copy) NSString * singer1;
@property (nonatomic, copy) NSString * songname;
@property (nonatomic, copy) NSString * songpiy;
@property (nonatomic, copy) NSString * spath;
@property (nonatomic, copy) NSString * stype;
@property (nonatomic, copy) NSString * volume;
@property (nonatomic, copy) NSString * word;
@property(nonatomic,weak)id<SongDelegate> delegate;

- (void)insertSongToCollectionTable;
- (void)deleteSongFromCollectionTable;
- (void)cutSong;
- (void)prioritySong;


@end
