//
//  SettingViewController.m
//  KTV
//
//  Created by stevenhu on 15/4/29.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "SettingViewController.h"
#import "BBBadgeBarButtonItem.h"
#import "Utility.h"
#import "YiDianViewController.h"

#import "AboutViewController.h"
#import "CommandControler.h"
@interface SettingViewController () {
    CommandControler *cmd;
}
@property (nonatomic, strong) NSMutableArray *dataSrc;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView=backView;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight=60.0f;
    self.tableView.scrollEnabled=NO;
    self.dataSrc = [[NSMutableArray alloc] initWithObjects:@"重启主机",@"关闭主机",@"清除缓存数据",@"关于我们", nil];
    cmd=[[CommandControler alloc]init];
//    [self initToolBarAndNavigationItems];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataSrc.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    static NSString *cellIdentify=@"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
    }
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
        cell.textLabel.text=self.dataSrc[indexPath.row];
            break;
        case 3: {
            cell.textLabel.text=self.dataSrc[indexPath.row];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [cmd sendCmd_restartDevice];
            break;
        }
        case 1: {
            [cmd sendCmd_shutdownDevice];

            break;
        }
        case 2: {
            //clear tmp file and so on;
            [cmd clearCacheData];
            break;
        }
        case 3: {
            AboutViewController *vc=[[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
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

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

// tool bar navigation items
- (void)initToolBarAndNavigationItems {
    //toolbar
    UIBarButtonItem *flex0=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    UIBarButtonItem *kege=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"kege"] style:UIBarButtonItemStylePlain target:self action:@selector(clicked_kege:)];
    kege.tintColor=[UIColor whiteColor];
    
    UIBarButtonItem *flex1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    UIBarButtonItem *bokong=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bokong"] style:UIBarButtonItemStylePlain target:self action:@selector(clicked_bokong:)];
    bokong.tintColor=[UIColor whiteColor];
    
    UIBarButtonItem *flex2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    UIBarButtonItem *shenkong=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shenkong"] style:UIBarButtonItemStylePlain target:self action:@selector(clicked_shenkong:)];
    shenkong.tintColor=[UIColor whiteColor];
    
    UIBarButtonItem *flex3=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    UIBarButtonItem *setting=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(clicked_setting:)];
    setting.tintColor=[UIColor orangeColor];
    
    UIBarButtonItem *flex4=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    self.toolbarItems=@[flex0,kege,flex1,bokong,flex2,shenkong,flex3,setting,flex4];
    
    //navigation item
    UIButton *rightbtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightbtn.frame=CGRectMake(0, 0, 25, 25);
    [rightbtn.titleLabel sizeToFit];
    [rightbtn setImage:[UIImage imageNamed:@"yidian"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(clicked_yidian:) forControlEvents:UIControlEventTouchUpInside];
    BBBadgeBarButtonItem *barButton=[[BBBadgeBarButtonItem alloc] initWithCustomUIButton:rightbtn];
    self.navigationItem.rightBarButtonItem=barButton;
}

 
- (void)clicked_yidian:(id)sender {
    NSLog(@"Bar Button Item Pressed");
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    // If you don't want to remove the badge when it's zero just set
    barButton.shouldHideBadgeAtZero = YES;
    // Next time zero should still be displayed
    
    // You can customize the badge further (color, font, background), check BBBadgeBarButtonItem.h ;)
    YiDianViewController *yidianVC=[[YiDianViewController alloc]init];
    [self.navigationController pushViewController:yidianVC animated:YES];
}

// Fake adding element
- (IBAction)addItemToListButtonPressed {
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItem;
    barButton.badgeValue = [NSString stringWithFormat:@"%d", [barButton.badgeValue intValue] + 1];
}



@end
