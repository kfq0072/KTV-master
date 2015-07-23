//
//  SingsTableViewCell.h
//  KTV
//
//  Created by stevenhu on 15/4/21.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singer.h"

@interface SingsTableViewCell : UITableViewCell
@property (nonatomic, strong)Singer *singer;
@property (weak, nonatomic) IBOutlet UILabel *SingerLabel;
@end
