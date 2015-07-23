//
//  UILabel+Animation.h
//  KTV
//
//  Created by mCloud on 15/4/27.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef void(^animationDone)(BOOL done);
//shakeAndFlyAnimationDone
@interface UILabel (Animation)
- (void)shakeAndFlyAnimationToView:(UIBarButtonItem*)item;
@end
