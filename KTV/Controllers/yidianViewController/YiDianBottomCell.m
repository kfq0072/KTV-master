//
//  YiDianBottomCell.m
//  KTV
//
//  Created by stevenhu on 15/5/16.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "YiDianBottomCell.h"
#import "CommandControler.h"
@implementation YiDianBottomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clicked_priority:(id)sender {
    if (self.oneSong.number.length > 0) {
        CommandControler *cmd=[[CommandControler alloc]init];
        [cmd sendCmd_moveSongToTop:@"1"];
        if ([self.delegate respondsToSelector:@selector(dingGeFromCollection:result:)]) {
            [self.delegate dingGeFromCollection:_oneSong result:KMessageSuccess];
        }
    }
}

- (IBAction)clicked_cutsong:(id)sender {
    if (self.oneSong.number.length > 0) {
        CommandControler *cmd=[[CommandControler alloc]init];
        [cmd sendCmd_switchSong];
        if ([self.delegate respondsToSelector:@selector(cutSongFromCollection:result:)]) {
            [self.delegate cutSongFromCollection:_oneSong result:KMessageSuccess];
        }
    }
}

- (IBAction)removeSong:(id)sender {
    if (self.oneSong.number.length > 0) {
        CommandControler *cmd=[[CommandControler alloc]init];
        [cmd sendCmd_remove_yidian:_oneSong.number];
        if ([self.delegate respondsToSelector:@selector(removeFromCollection:result:)]) {
            [self.delegate removeFromCollection:_oneSong result:KMessageSuccess];
        }
    }
}


- (IBAction)clicked_collection:(id)sender {
    [self addSongToCollection];
}

- (void)addSongToCollection {
    [_oneSong insertSongToCollectionTable];
}

@end
