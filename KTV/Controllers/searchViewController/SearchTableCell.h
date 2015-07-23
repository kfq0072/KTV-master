//
//  SearchTableCell.h
//  KTV
//
//  Created by stevenhu on 15/5/3.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
@interface SearchTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (assign,nonatomic)BOOL opened;
@property (weak, nonatomic) IBOutlet UIImageView *sanjiaoxing;
@property (weak, nonatomic) IBOutlet UIButton *diange_clicked;
@property(nonatomic,weak)Song *oneSong;
- (IBAction)addSong:(id)sender;

@end
