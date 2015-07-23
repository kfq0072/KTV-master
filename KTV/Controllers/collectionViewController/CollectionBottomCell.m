//
//  CollectionBottomCell.m
//  KTV
//
//  Created by stevenhu on 15/5/12.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "CollectionBottomCell.h"
#import "NSManagedObject+helper.h"
#import "CollectionRec.h"
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
    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"CollectionRec"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"number==%@",_oneSong.number]];
    NSError *error;
    NSArray *collections = [[Utility instanceShare].mainObjectContext executeFetchRequest:fetchRequest error:&error];
    if (collections.count>0) {
        CollectionRec * lastRecord = [collections lastObject];
        // 删除数据
        [[Utility instanceShare].mainObjectContext deleteObject:lastRecord];
        if ([lastRecord isDeleted]) {
            [[Utility instanceShare]save:nil];
            if ([self.delegate respondsToSelector:@selector(deleteCollectionSong:result:)]) {
            [self.delegate deleteCollectionSong:_oneSong result:KMessageSuccess];
            }
            
        } else {
            if ([self.delegate respondsToSelector:@selector(deleteCollectionSong:result:)]) {
            [self.delegate deleteCollectionSong:_oneSong result:KMessageWarning];
            }
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(deleteCollectionSong:result:)]) {
            [self.delegate deleteCollectionSong:_oneSong result:KMessageStyleInfo];
        }
    }
}

- (IBAction)clicked_priory:(id)sender {
    if (self.oneSong.number.length > 0) {
        CommandControler *cmd=[[CommandControler alloc]init];
        [cmd sendCmd_DiangeToTop:self.oneSong.number];
        if ([self.delegate respondsToSelector:@selector(dingGeFromCollection:result:)]) {
            [self.delegate dingGeFromCollection:_oneSong result:KMessageSuccess];
        }
    }
}

- (IBAction)clicked_cutSong:(id)sender {
    if (self.oneSong.number.length > 0) {
        CommandControler *cmd=[[CommandControler alloc]init];
        [cmd sendCmd_switchSong];
        if ([self.delegate respondsToSelector:@selector(cutSongFromCollection:result:)]) {
            [self.delegate cutSongFromCollection:_oneSong result:KMessageSuccess];
        }
    }
}

@end
