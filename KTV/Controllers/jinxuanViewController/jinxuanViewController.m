//
//  jinxuanViewController.m
//  KTV
//
//  Created by stevenhu on 15/4/25.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "jinxuanViewController.h"
#import "jingXuanTableViewCell.h"
#define CELLIDENTIFY @"jingXuanTableViewCell"
#import "NSManagedObject+helper.h"
#import "Typelist.h"
#import "SingersViewController.h"
#import "SingerAreaViewController.h"
#import "YiDianViewController.h"
#import "BBBadgeBarButtonItem.h"
#import "BokongView.h"
#import "SettingViewController.h"
#import "SoundViewController.h"
@interface jinxuanViewController ()
{
    NSArray *dataList;
    UIImage *tableBgImage;

}
@end

@implementation jinxuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"精选集";
    tableBgImage=[UIImage imageNamed:@"songsList_bg"];
    UIImageView *bgImageView=[[UIImageView alloc]initWithImage:tableBgImage];
    self.tableView.backgroundView=bgImageView;
    self.tableView.rowHeight=60.0f;
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView=backView;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    UINib *nib=[UINib nibWithNibName:CELLIDENTIFY bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CELLIDENTIFY];
    [self initNavigationItem];
    [self initializeTableContent];
}

- (void)initializeTableContent {
//    [Typelist async:^id(NSManagedObjectContext *ctx, NSString *className) {
//        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Typelist"];
//        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"zztype==3"]];
//        NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"zztypename" ascending:NO];
//        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//        NSError *error;
//        NSArray *tmpArray = [ctx executeFetchRequest:fetchRequest error:&error];
//        if (error) {
//            return error;
//        }else{
//            return tmpArray;
//        }
//        
//    } result:^(NSArray *result, NSError *error) {
//        dataList = result;
//        [self.tableView reloadData];
//    }];
}

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    __weak __typeof(BBBadgeBarButtonItem*)weakBarButton=barButton;
    [[Utility instanceShare]setYidianBadgeWidth:weakBarButton];
    [barButton registNofification];
}

- (void)viewDidDisappear:(BOOL)animated {
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    [barButton removeNotification];
    [super viewDidDisappear:animated];
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
    return dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    jingXuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFY forIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
     Typelist *onetype=dataList[indexPath.row];
    cell.numberName.text=[NSString stringWithFormat:@"%02d",(int)indexPath.row+1];
    cell.numberName.font=[UIFont fontWithName:@"DIN Condensed" size:12];
    cell.typeName.text=onetype.ztypename;
    // Configure the cell...
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SingersViewController *vc=[[SingersViewController alloc]init];
    Typelist *onetype=dataList[indexPath.row];
    vc.area=onetype.ztype;
    [self.navigationController pushViewController:vc animated:YES];
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

//navigationbar
- (void)initNavigationItem {
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
    YiDianViewController *yidianVC=[[YiDianViewController alloc]init];
    [self.navigationController pushViewController:yidianVC animated:YES];
}

// Fake adding element
- (IBAction)addItemToListButtonPressed {
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    [[Utility instanceShare]setYidianBadgeWidth:barButton];

}

@end
