//
//  songListViewController.m
//  zzKTV
//
//  Created by mCloud on 15/3/30.
//  Copyright (c) 2015年 StevenHu. All rights reserved.
//

#import "SearchSongListViewController.h"
#import "ResultTableViewController.h"
#import "Utility.h"
#import "PinYinForObjc.h"
#define TOPCELLIDENTIFY @"SearchTableCell"
#import "SearchTableCell.h"
#define BOTTOMCELLIDENTIFY @"SongBottomCell"
#import "SongBottomCell.h"
#import "YiDianViewController.h"
#import "BBBadgeBarButtonItem.h"
#import "Song.h"
#import "NSManagedObject+helper.h"
#import "SFSelectView.h"
//#import "huSearchBar.h"
//#import "UIImageView+Animation.h"
//#import <objc/runtime.h>
@interface SearchSongListViewController ()<searchSongDelegate>{
    NSInteger _previousRow;
    UIView *promtView;
    SFSelectView *_leftView;
    
}
@property (nonatomic,strong)NSMutableArray *dataList;
@property (nonatomic,strong)NSIndexPath *selectedIndexPath;
@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)ResultTableViewController *resultVC;


@end

@implementation SearchSongListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.title=@"歌曲";
    self.navigationItem.backBarButtonItem=nil;
    
    [self initializeTableContent];
    
}

- (void)initializeTableContent {
    UIImageView *bgImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"songsList_bg"]];
    self.tableView.backgroundView=bgImageView;
    self.definesPresentationContext = YES;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    UINib *nib=[UINib nibWithNibName:@"SearchTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TOPCELLIDENTIFY];
    _previousRow = -1;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=50;
    self.tableView.autoresizingMask=YES;
    _resultVC=[[ResultTableViewController alloc]init];
    _resultVC.delegate=self;
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:_resultVC];
    self.searchController.searchResultsUpdater=_resultVC;
    self.searchController.searchBar.delegate=_resultVC;
    [self.searchController.searchBar sizeToFit];
    self.searchController.hidesNavigationBarDuringPresentation=NO;
    self.tableView.tableHeaderView=self.searchController.searchBar;
    self.automaticallyAdjustsScrollViewInsets=YES;
    //    self.navigationItem.titleView=self.searchController.searchBar;
    self.searchController.searchBar.placeholder=@"输入歌星、歌曲、简拼";
    self.searchController.searchBar.backgroundImage=[self imageWithColor:[UIColor clearColor]];
    //    [self initToolBarAndNavigationItems];
    [self createDefaultView];
    UIView *backView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView=backView;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.searchController.searchBar performSelectorOnMainThread:@selector(becomeFirstResponder) withObject:self waitUntilDone:NO];
    [super viewDidAppear:animated];
}

- (void)createDefaultView {
    promtView=[[UIView alloc]initWithFrame:CGRectMake(self.view.center.x-300/2, 60, 300, 150)];
    UILabel *labelStr=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    labelStr.numberOfLines=0;
    labelStr.textColor=[UIColor groupTableViewBackgroundColor];
    labelStr.font=[UIFont systemFontOfSize:15];
    labelStr.text=@"输入搜索内容的首字母即可查询歌曲哈！";
    
    UILabel *labelStr1=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(labelStr.frame)+20, 300, 40)];
    labelStr1.numberOfLines=0;
    labelStr1.textColor=[UIColor groupTableViewBackgroundColor];
    labelStr1.font=[UIFont systemFontOfSize:15];
    labelStr1.text=@"刘德华 输入\"ldh\"";
    
    UILabel *labelStr2=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(labelStr1.frame), 300, 40)];
    labelStr2.numberOfLines=0;
    labelStr2.textColor=[UIColor groupTableViewBackgroundColor];
    labelStr2.font=[UIFont systemFontOfSize:15];
    labelStr2.text=@"宁夏 输入\"nx\"";
    
    [promtView addSubview:labelStr];
    [promtView addSubview:labelStr1];
    [promtView addSubview:labelStr2];
    [self.view addSubview:promtView];
    
    //modify searchbar
    _leftView= [[SFSelectView alloc]initWithItems:@[@"全部",@"歌曲",@"歌手"]];
    _leftView.delegate = _resultVC;
    UITextField *textField;
    for (UIView *view in [self.searchController.searchBar subviews])
    {
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:[UITextField class]])
            {
                textField = (UITextField *)subView;
            }
        }
        
    }
    
    textField.clearButtonMode = UITextFieldViewModeNever;
    
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = _leftView;
    
    
}

- (void)showPromtView:(BOOL)isShow {
    promtView.hidden=isShow;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}


-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
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


// Fake adding element
- (IBAction)addItemToListButtonPressed {
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItem;
    barButton.badgeValue = [NSString stringWithFormat:@"%d", [barButton.badgeValue intValue] + 1];
}

- (void)searchDone {
    NSLog(@"search Done");
    promtView.hidden=NO;
}

- (void)searching {
    promtView.hidden=YES;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canResignFirstResponder {
    return YES;
}
@end
