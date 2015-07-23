//
//  UISelect.h
//  mWidget
//
//  Created by mCloud on 14/12/19.
//  Copyright (c) 2014年 mCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectViewOnSelectedDelegate <NSObject>
- (void)selectViewOnSelectedIndex:(NSUInteger)index;
@end

@interface SFSelectView : UIButton
@property(nonatomic, assign)id<SelectViewOnSelectedDelegate>delegate;
@property(nonatomic,readonly,copy)NSString *value;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)UIImage *image;

- (void)setTextFont:(UIFont*)font;
- (void)setTextColor:(UIColor*)color;
- (id)initWithItems:(NSArray*)items;
@end
