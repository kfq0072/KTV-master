//
//  huSearchBar.h
//  ZZKTV
//
//  Created by stevenhu on 15-3-22.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol clickedSearchTypeDelegate
@optional
-(void)selectSearchType:(UIView*)view;
@end

@interface huSearchBar : UISearchBar
@property(nonatomic,weak)id<clickedSearchTypeDelegate> selectTypeDelegate;
@end
