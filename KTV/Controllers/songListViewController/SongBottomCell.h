//
//  songTableViewCell.h
//  KTV
//
//  Created by stevenhu on 15/4/18.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "HuToast.h"
@protocol SongListSongDelegate <NSObject>
@required
- (void)addCollectionSong:(Song*)oneSong result:(KMessageStyle)result;
- (void)dingGeFromCollection:(Song*)oneSong result:(KMessageStyle)result;
- (void)cutSongFromCollection:(Song*)oneSong result:(KMessageStyle)result;
@end
@interface SongBottomCell : UITableViewCell
@property(nonatomic,weak)Song *oneSong;
@property(nonatomic,weak)id<SongListSongDelegate> delegate;

@end
