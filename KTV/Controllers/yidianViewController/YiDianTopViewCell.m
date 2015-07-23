//
//  YiDianTopViewCell.m
//  KTV
//
//  Created by stevenhu on 15/5/2.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "YiDianTopViewCell.h"

@implementation YiDianTopViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOneSong:(Song *)oneSong {
//    NSLog(@"%@",oneSong.number);
    self.songName.text=[oneSong.songname copy];
    self.singer.text=[oneSong.singer copy];
    _oneSong=oneSong;
}


@end
