//
//  SingerTypeCell.h
//  KTV
//
//  Created by stevenhu on 15/4/21.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingerAreaTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *SingerLabel;

- (void)downLoadImage:(NSString*)imageName;

@end
