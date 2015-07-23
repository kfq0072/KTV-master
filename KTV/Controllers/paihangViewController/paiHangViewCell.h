//
//  paiHangViewCell.h
//  KTV
//
//  Created by stevenhu on 15/4/26.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
@interface paiHangViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberStr;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singer;
@property (assign,nonatomic)BOOL opened;
@property (weak,nonatomic)UIBarButtonItem *buttonitem;
@property (weak, nonatomic) IBOutlet UIImageView *sanjiaoxing;
@property (weak, nonatomic) IBOutlet UIImageView *paihangFlagView;
@property(nonatomic,weak)Song *oneSong;


- (IBAction)addSong:(id)sender;

@end
