//
//  SearchTableCell.m
//  KTV
//
//  Created by stevenhu on 15/5/3.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "SearchTableCell.h"
#import "CommandControler.h"

@implementation SearchTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _opened=selected;

    // Configure the view for the selected state
}

- (void)setOneSong:(Song *)oneSong {
    self.songName.text=[oneSong.songname copy];
    _oneSong=oneSong;
}

- (IBAction)addSong:(id)sender {
    if (self.oneSong.number.length > 0) {
        CommandControler *cmd=[[CommandControler alloc]init];
        [cmd sendCmd_Diange:self.oneSong.number];
    }
}
@end
