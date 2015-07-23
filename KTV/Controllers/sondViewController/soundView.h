//
//  soundView.h
//  KTV
//
//  Created by stevenhu on 15/5/2.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShenKongDelegate <NSObject>

-(void)exitShengKongView;

@end

@interface soundView : UIView
@property(nonatomic,assign)id<ShenKongDelegate>delegate;

@end
