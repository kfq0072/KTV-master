//
//  SingsTableViewCell.m
//  KTV
//
//  Created by stevenhu on 15/4/21.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "SingsTableViewCell.h"

@implementation SingsTableViewCell



- (void)setSinger:(Singer *)singer {
    _singer = singer;
    _SingerLabel.text = singer.singer;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
