//
//  YiDianTopViewCell.h
//  KTV
//
//  Created by stevenhu on 15/5/2.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
@interface YiDianTopViewCell : UITableViewCell
@property(nonatomic,assign)BOOL opened;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singer;
@property (weak, nonatomic) IBOutlet UIImageView *sanjiaoxing;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property(nonatomic,weak)Song *oneSong;

@end
