//
//  BokongView.h
//  KTV
//
//  Created by stevenhu on 15/4/27.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BokongDelegate <NSObject>
@required
- (void)boKongHadDimssed;

@end

@interface BokongView : NSObject
@property(nonatomic,weak)id<BokongDelegate>delegate;
+(instancetype)instanceShare;
//-(void)animationPopView;
- (void)showAtView:(UIView*)view;
//-(void)showAtPoint:(CGPoint)point;
@end
