//
//  CollectionBottomCell.h
//  KTV
//
//  Created by stevenhu on 15/5/12.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "HuToast.h"
@protocol CollectionSongDelegate <NSObject>
@required
- (void)deleteCollectionSong:(Song*)oneSong result:(KMessageStyle)result;
- (void)dingGeFromCollection:(Song*)oneSong result:(KMessageStyle)result;
- (void)cutSongFromCollection:(Song*)oneSong result:(KMessageStyle)result;
@end

@interface CollectionBottomCell : UITableViewCell
@property(nonatomic,weak)Song *oneSong;
@property(nonatomic,weak)id<CollectionSongDelegate> delegate;
@end
