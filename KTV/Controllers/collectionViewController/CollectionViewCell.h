//
//  CollectionViewCell.h
//  KTV
//
//  Created by stevenhu on 15/5/2.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionRec.h"
@interface CollectionViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UIImageView *collectionFlagView;
@property (weak, nonatomic) IBOutlet UIImageView *sanjiaoxing;
@property (assign,nonatomic)BOOL opened;
@property (weak,nonatomic)UIBarButtonItem *buttonitem;
@property(nonatomic,weak)CollectionRec *oneCollectionRec;
- (IBAction)addSong:(id)sender;

@end

