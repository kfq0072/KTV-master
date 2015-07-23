//
//  huSearchBar.m
//  ZZKTV
//
//  Created by stevenhu on 15-3-22.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import "huSearchBar.h"
#import "Utility.h"
#define MENU_POPOVER_FRAME  CGRectMake(8, 44, 140, 88)
@interface huSearchBar ()<clickedSearchTypeDelegate>
{
    UIButton *leftbtn;
    NSArray *menueItems;
}
//@property(nonatomic,strong) MLKMenuPopover *menuPopover;
@end

@implementation huSearchBar
- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in self.subviews) {
        if ([Utility user_iosVersion]>=7.0) {
//             [view recursiveDescription]
            for (UIView *subSubView in subView.subviews) {
//                MRLOG(@"bottom:%@\n",subSubView.description);
                if ([subSubView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                    [subSubView removeFromSuperview];
                }
//                if ([subSubView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
//                    UITextField *leftView=(UITextField*)subSubView;
//                    for (UIView *v in subSubView.subviews) {
//                        if ([v isKindOfClass:[UIImageView class]])
//                            if ([NSStringFromClass([v class]) isEqualToString:@"UIImageView"]) {
//                                [self modifySearchBarLeftView:leftView];
//                            }
//                    }
//                }
                
            }
        } else if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) { // /iOS6以下版
            [subView removeFromSuperview];
        }
    }
    
}
//- (void)modifySearchBarLeftView:(UITextField*)leftView {
//    leftView.leftViewMode=UITextFieldViewModeAlways;
//    leftbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 24)];
//    [leftbtn addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
//    [leftbtn setBackgroundImage:[UIImage imageNamed:@"button_p 11"] forState:UIControlStateNormal];
//    leftbtn.layer.cornerRadius=8;
//    leftbtn.titleLabel.adjustsFontSizeToFitWidth=true;
//    [leftbtn.titleLabel sizeToFit];
////    leftbtn.titleLabel.font=[UIFont systemFontOfSize:16];
//    leftbtn.titleLabel.contentMode= UIViewContentModeCenter;
//    leftbtn.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
//    leftbtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
//    [leftbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [leftbtn setTitle:@"全部" forState:UIControlStateNormal];
//    leftbtn.titleEdgeInsets=UIEdgeInsetsMake(-5, 0, 0, 0);
//    leftView.leftView=leftbtn;
//    
// 
//}
//#pragma mark -
//#pragma mark Actions
//
//- (void)selectType:(id)sender {
//    [self.superview resignFirstResponder];
//    //items
//    menueItems=[NSArray arrayWithObjects:@"Menu Item 1", @"Menu Item 2", nil];
//    [_menuPopover dismissMenuPopover];
//    _menuPopover=[[MLKMenuPopover alloc]initWithFrame:MENU_POPOVER_FRAME menuItems:menueItems];
////    _menuPopover.menuPopoverDelegate=self;
//    [_menuPopover showInView:self];
//}
//
//
//#pragma mark -
//#pragma mark MLKMenuPopoverDelegate
//
//- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
//{
//    [self.menuPopover dismissMenuPopover];
//    
//    NSString *title = [NSString stringWithFormat:@"%@ selected.",[menueItems objectAtIndex:selectedIndex]];
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//    [alertView show];
//}
//
//- (void)selectSearchType:(UIView *)view {
//    if (_selectTypeDelegate) {
//        
//    }
//}

@end
