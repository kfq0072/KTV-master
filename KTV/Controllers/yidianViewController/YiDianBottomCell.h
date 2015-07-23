//
//  YiDianBottomCell.h
//  KTV
//
//  Created by stevenhu on 15/5/16.
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
@optional
- (void)removeFromCollection:(Song*)oneSong result:(KMessageStyle)result;

@end
@interface YiDianBottomCell : UITableViewCell
@property(nonatomic,weak)Song *oneSong;
@property (weak, nonatomic) IBOutlet UIButton *collectionrec;
@property (weak, nonatomic) IBOutlet UIButton *priority;
@property (weak, nonatomic) IBOutlet UIButton *cutsong;
@property (weak, nonatomic) IBOutlet UIButton *remove;
@property(nonatomic,weak)id<SongListSongDelegate> delegate;
@end
