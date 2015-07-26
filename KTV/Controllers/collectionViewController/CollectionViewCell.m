//
//  CollectionViewCell.m
//  KTV
//
//  Created by stevenhu on 15/5/2.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "CollectionViewCell.h"
#import "UIImageView+Animation.h"
#import "CommandControler.h"
@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _opened=selected;
    // Configure the view for the selected state
}

- (void)setOneSong:(Song *)oneSong {
    NSLog(@"%@",oneSong.songname);
    self.songName.text=[oneSong.songname copy];
    _oneSong=oneSong;
}

//- (IBAction)addSong:(id)sender {
//    if (self.buttonitem && self.oneCollectionRec.number.length > 0) {
//        CommandControler *cmd=[[CommandControler alloc]init];
//        [cmd sendCmd_Diange:self.oneCollectionRec.number];
//        [self.collectionFlagView shakeAndFlyAnimationToView:self.buttonitem];
//    }
//}
//
//- (void)setOneCollectionRec:(CollectionRec *)oneCollectionRec {
//    self.songName.text=oneCollectionRec.sname;
//    _oneCollectionRec=oneCollectionRec;
//}
@end
