//
//  YiDianBottomCell.m
//  KTV
//
//  Created by stevenhu on 15/5/16.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "YiDianBottomCell.h"
#import "CollectionRec.h"
#import "NSManagedObject+helper.h"
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
    [CollectionRec async:^id(NSManagedObjectContext *ctx, NSString *className) {
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"CollectionRec"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"number==%@",_oneSong.number]];
        NSError *error;
        NSArray *tmpArray = [ctx executeFetchRequest:fetchRequest error:&error];
        if (error) {
            if ([self.delegate respondsToSelector:@selector(addCollectionSong:result:)]) {
                [self.delegate addCollectionSong:_oneSong result:KMessageStyleError];
            }
            return error;
        }else{
            return tmpArray;
        }
        
    } result:^(NSArray *result, NSError *error) {
        if (result.count<=0) {
            int rcid=[[[NSUserDefaults standardUserDefaults]objectForKey:@"COLLECTION_RCID"] intValue];
            NSNumber *newRcid=[NSNumber numberWithInt:rcid+1];
            NSManagedObject  *oneRecord=[NSEntityDescription insertNewObjectForEntityForName:@"CollectionRec" inManagedObjectContext:[Utility instanceShare].mainObjectContext];
            [oneRecord setValue:[NSNumber numberWithInt:rcid+1] forKey:@"rcid"];
            [oneRecord setValue:_oneSong.songname forKey:@"sname"];
            [oneRecord setValue:_oneSong.number forKey:@"number"];
            [[NSUserDefaults standardUserDefaults]setValue:newRcid forKey:@"COLLECTION_RCID"];
            [[Utility instanceShare]save:nil];
            if ([self.delegate respondsToSelector:@selector(addCollectionSong:result:)]) {
                [self.delegate addCollectionSong:_oneSong result:KMessageSuccess];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(addCollectionSong:result:)]) {
                [self.delegate addCollectionSong:_oneSong result:KMessageStyleInfo];
            }
        }
    }];
}

@end
