//
//  UIImageView+Animation.h
//  ZZKTV
//
//  Created by stevenhu on 15/4/5.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Animation) {
   
}
- (void)shakeAndFlyAnimationToView:(UIBarButtonItem*)item;

- (void)startImagesAutoSwitch:(NSArray*)images;

- (void)stopImagesAutoSwitch;

@end
