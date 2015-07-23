//
//  songTableViewCell.m
//  KTV
//
//  Created by stevenhu on 15/4/18.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//
#import "SongBottomCell.h"
#import "CommandControler.h"
@interface SongBottomCell ()
@property (weak, nonatomic) IBOutlet UIButton *collectionrec;
@property (weak, nonatomic) IBOutlet UIButton *priority;
@property (weak, nonatomic) IBOutlet UIButton *cutsong;

@end


@implementation SongBottomCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)clicked_collection:(id)sender {
    [_oneSong insertSongToCollectionTable];
}


- (IBAction)clicked_priority:(id)sender {
    [_oneSong prioritySong];
}

- (IBAction)clicked_cutsong:(id)sender {
    [_oneSong cutSong];
}


//
//- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view=[super hitTest:point withEvent:event];
//    if (view) {
//       return  nil;
//    }
//    return view;
//}



@end
