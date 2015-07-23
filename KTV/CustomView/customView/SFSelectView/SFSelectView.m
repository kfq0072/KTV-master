//
//  MRSelect.m
//  mWidget
//
//  Created by mCloud on 14/12/19.
//  Copyright (c) 2014年 mCloud. All rights reserved.
//

#import "SFSelectView.h"

@interface SFSelectView ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *myTableView;
    CAShapeLayer *shapeLayer;
    CGFloat natHeight;
    UIView *topView;
    float controlWidth;
    CGPoint point;
    BOOL visiable;
    UIView *chunkview;
    UIImageView *imageV;
    float offset;
    NSArray *images;
}
@end
@implementation SFSelectView

- (id)initWithItems:(NSArray*)items {
    CGRect rect=CGRectMake(0, 0, 40, 20);
    if (self = [self initWithFrame:rect]) {
        self.backgroundColor=[UIColor clearColor];
        [self setTextFont:[UIFont systemFontOfSize:12]];
        _image=[UIImage imageNamed:@"searchBar"];
        images=@[@"search_0548",@"search_0549",@"search_0550"];
        [self setImage:_image forState:UIControlStateNormal];
        [self setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        visiable=NO;
        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self setTitle:items[0] forState:UIControlStateNormal];
        [self setItems:items];
        self.imageEdgeInsets=UIEdgeInsetsMake(0, 30, 0, 0);
        self.titleEdgeInsets=UIEdgeInsetsMake(-10, -30, -10, 0);
        [self addTarget:self action:@selector(showSelectItems) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}


- (void)showSelectItems {
    visiable=!visiable;
    [self animationView];
    [myTableView reloadData];
    
}

- (void)animationView{
    if (!_items || _items.count<=0) return;
    if (self.frame.size.width <=0 || self.frame.size.height<=0) return;
    if (!myTableView) {
        UIViewController *TopVC=[UIApplication sharedApplication].keyWindow.rootViewController;
        if ([TopVC isKindOfClass:[UINavigationController class]]) {
            offset=44;
        } else offset=2;
        chunkview=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        myTableView = [[UITableView alloc]init];
        myTableView.showsHorizontalScrollIndicator=NO;
        myTableView.showsVerticalScrollIndicator=NO;
        myTableView.scrollEnabled=NO;
        myTableView.layer.cornerRadius=5.0f;
        myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        myTableView.backgroundColor=[UIColor clearColor];
        myTableView.dataSource = self;
        myTableView.delegate = self;
        myTableView.rowHeight=40;
        myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        
    }
    if (visiable) {
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        if (!window) {
            window= [[UIApplication sharedApplication].windows firstObject];
        }
        [window addSubview:chunkview];
        imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 100, [_items count]*40)];
        imageV.image=[UIImage imageNamed:@"selectView_bg"];
        myTableView.frame = CGRectMake(10,35,imageV.frame.size.width,imageV.frame.size.height);
        imageV.userInteractionEnabled=YES;
        //        imageV.layer.shadowColor=[UIColor grayColor].CGColor;
        //        imageV.layer.shadowOffset=CGSizeMake(-1, -2);
        //        imageV.layer.shadowOpacity=3;
        myTableView.backgroundView=imageV;
        [chunkview addSubview:myTableView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSelectItems)];
        [chunkview addGestureRecognizer:tap];
    } else {
        [chunkview removeFromSuperview];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.row!=2) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, tableView.rowHeight-1, tableView.bounds.size.width, 1)];
        lineView.backgroundColor=[UIColor grayColor];
        [cell addSubview:lineView];
    }
    cell.imageView.image=[UIImage imageNamed:images[indexPath.row]];
    [cell.textLabel setTextColor:[UIColor groupTableViewBackgroundColor]];
    cell.textLabel.text = _items[indexPath.row];
    cell.tag=indexPath.row;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selected_item:)];
    [cell addGestureRecognizer:tap];
    return cell;
}

- (void)selected_item:(UIGestureRecognizer*)recognizer {
    UITableViewCell *selectCell=(UITableViewCell*)[recognizer view];
    [self setTitle:selectCell.textLabel.text forState:UIControlStateNormal];
    _value=selectCell.textLabel.text;
    if ([self.delegate respondsToSelector:@selector(selectViewOnSelectedIndex:)]) {
        [self.delegate selectViewOnSelectedIndex:selectCell.tag];
    }
    visiable=!visiable;
    [self animationView];
}

-(void)setItems:(NSArray *)items {
    
    _items=items;
    NSUInteger temp = [_value intValue];
    if (_value!=nil && temp<=items.count) {
        [self setTitle:[_items objectAtIndex:temp] forState:UIControlStateNormal];
    } else {
        [self setTitle:_items[0] forState:UIControlStateNormal];
        _value=items[0];
    }
    [myTableView reloadData];
}

- (void)setTextFont:(UIFont*)font {
    self.titleLabel.font=font;
}

- (void)setTextColor:(UIColor*)color {
    [self setTitleColor:color forState:UIControlStateNormal];
}


-(CGFloat)getTopView {
    
    UIViewController *activityVC=nil;
    UIWindow *window= [UIApplication sharedApplication].keyWindow;
    if (window.windowLevel!=UIWindowLevelNormal) {
        NSArray *windows=[[UIApplication sharedApplication]windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel==UIWindowLevelNormal) {
                window=tmpWin;
                break;
            }
        }
    }
    UIView *view=[window.subviews objectAtIndex:0];
    id nextResponder=[view nextResponder];
    if([nextResponder isKindOfClass:[UIViewController class]]) {
        activityVC=nextResponder;
    } else {
        activityVC=[UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    if ([activityVC isKindOfClass:[UINavigationController class] ]) {
        topView=[(UINavigationController*)activityVC visibleViewController].view;
        natHeight=[(UINavigationController*)activityVC navigationBar].bounds.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;
        
    } else if([activityVC isKindOfClass:[UIViewController class] ]) {
        topView=activityVC.view;
    } else if([activityVC isKindOfClass:[UITabBarController class] ]) {
        topView=[(UITabBarController*) activityVC selectedViewController].view;
    }
    
    return natHeight;
}

- (void)viewDidLayoutSubviews {
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
