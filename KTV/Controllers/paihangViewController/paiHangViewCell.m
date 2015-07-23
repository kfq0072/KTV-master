//
//  paiHangViewCell.m
//  KTV
//
//  Created by stevenhu on 15/4/26.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "paiHangViewCell.h"
#import "UILabel+Animation.h"
#import "CommandControler.h"
@implementation paiHangViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addSong:(id)sender {
    if (self.buttonitem && self.oneSong.number.length > 0) {
        CommandControler *cmd=[[CommandControler alloc]init];
        [cmd sendCmd_Diange:self.oneSong.number];
        [self.numberStr shakeAndFlyAnimationToView:self.buttonitem];
    }
}

- (void)setOneSong:(Song *)oneSong {
    self.songName.text=[oneSong.songname copy];
    self.singer.text=[oneSong.singer copy];
    _oneSong=oneSong;
}
@end
