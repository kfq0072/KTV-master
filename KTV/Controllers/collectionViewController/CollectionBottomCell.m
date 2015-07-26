//
//  CollectionBottomCell.m
//  KTV
//
//  Created by stevenhu on 15/5/12.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "CollectionBottomCell.h"
#import "NSManagedObject+helper.h"
#import "CommandControler.h"
@implementation CollectionBottomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clicked_cancelCollection:(id)sender {
    [_oneSong deleteSongFromCollectionTable];
}

- (IBAction)clicked_priory:(id)sender {
    [_oneSong prioritySong];
}

- (IBAction)clicked_cutSong:(id)sender {
    [_oneSong cutSong];
}

@end
