 //
//  newSongViewController.m
//  KTV
//
//  Created by stevenhu on 15/4/25.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "newSongViewController.h"
#define TOPCELLIDENTIFY @"SongTopCell"
#import "SongTopCell.h"
#define BOTTOMCELLIDENTIFY @"SongBottomCell"
#import "SongBottomCell.h"
#import "YiDianViewController.h"
#import "Song.h"
#import "Utility.h"
#import "BBBadgeBarButtonItem.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface newSongViewController ()<MBProgressHUDDelegate,SongListSongDelegate> {
    NSInteger _previousRow;
    UIRefreshControl * bb;
    NSMutableArray *dataList;
    HuToast *myToast;
    int pageLimint;

}
@end

@implementation newSongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"新歌";
    pageLimint=20;
    myToast=[[HuToast alloc]init];
    UIImageView *bgImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newSong_bg"]];
    self.tableView.backgroundView=bgImageView;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    UINib *nib=[UINib nibWithNibName:@"SongTopCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TOPCELLIDENTIFY];
    _previousRow = -1;
    dataList=[[NSMutableArray alloc]init];
    UIImageView  *headerImageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    [headerImageV setImage:[UIImage imageNamed:@"newsong_header"]];
    self.tableView.tableHeaderView=headerImageV;
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView=backView;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=54;
    [self initNavigationItem];
    [self.tableView addGifFooterWithRefreshingTarget:self refreshingAction:@selector(loadMetadata:)];
    
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText=@"加载...";
    [hud showAnimated:YES whileExecutingBlock:^{
        [self initializeTableContent];
    } completionBlock:^{
        [hud removeFromSuperview];
    }];

}

- (void)loadMoreData
{
    // 1.添加数据
  
    // 拿到当前的上拉刷新控件，结束刷新状态

        [self.tableView reloadData];
        
        [self.tableView.footer endRefreshing];
}


- (void)initializeTableContent {
    NSString *newSongFlag=[[Utility instanceShare]encodeBase64:@"1"];
    NSString *sqlStr= [NSString stringWithFormat:@"select * from SongTable where newsong='%@' limit %d",newSongFlag,pageLimint];
    FMResultSet *rs=[[Utility instanceShare].db executeQuery:sqlStr];
    while ([rs next]) {
        Song *oneSong=[[Song alloc]init];
        oneSong.number = [rs stringForColumn:@"number"];
        oneSong.songname = [rs stringForColumn:@"songname"];
        oneSong.singer = [rs stringForColumn:@"singer"];
        oneSong.singer1 = [rs stringForColumn:@"singer1"];
        oneSong.songpiy = [rs stringForColumn:@"songpiy"];
        oneSong.word = [rs stringForColumn:@"word"];
        oneSong.language = [rs stringForColumn:@"language"];
        oneSong.volume = [rs stringForColumn:@"volume"];
        oneSong.channel = [rs stringForColumn:@"channel"];
        oneSong.sex = [rs stringForColumn:@"sex"];
        oneSong.stype = [rs stringForColumn:@"stype"];
        oneSong.newsong = [rs stringForColumn:@"newsong"];
        oneSong.movie = [rs stringForColumn:@"movie"];
        oneSong.pathid = [rs stringForColumn:@"pathid"];
        oneSong.bihua = [rs stringForColumn:@"bihua"];
        oneSong.addtime = [rs stringForColumn:@"addtime"];
        oneSong.spath = [rs stringForColumn:@"spath"];
        [dataList addObject:oneSong];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_previousRow >= 0 && _previousRow+1==indexPath.row) {
        SongBottomCell *cell=[tableView dequeueReusableCellWithIdentifier:BOTTOMCELLIDENTIFY];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:BOTTOMCELLIDENTIFY owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"song_bt_bg"]];
            cell.delegate=self;
            cell.oneSong=dataList[_previousRow];
        }
        return cell;
    } else {
        SongTopCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPCELLIDENTIFY forIndexPath:indexPath];
        cell.numberStr.text =[NSString stringWithFormat:@"%02d",(int)indexPath.row+1];
        cell.numberStr.font=[UIFont fontWithName:@"DIN Condensed" size:22];
        cell.oneSong=dataList[indexPath.row];
        cell.buttonitem=self.navigationItem.rightBarButtonItem;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        if (cell.opened) {
            cell.sanjiaoxing.hidden=NO;
        } else {
            cell.sanjiaoxing.hidden=YES;
        }
        
        return cell;
        
    }
    return nil;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SongTopCell *cell=(SongTopCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (![cell isKindOfClass:[SongTopCell class]]) return;
    if (cell.opened) {
        cell.sanjiaoxing.hidden=NO;
    } else {
        cell.sanjiaoxing.hidden=YES;
    }
    if (_previousRow >= 0) {
        NSIndexPath *preIndexPath=[NSIndexPath indexPathForRow:_previousRow inSection:0];
        SongTopCell *preCell=(SongTopCell*)[tableView cellForRowAtIndexPath:preIndexPath];
        
        if (indexPath.row == _previousRow + 1) {
            //            NSLog(@"fff");
        }
        else if (indexPath.row == _previousRow) {
            cell.opened=!cell.opened;
            if (cell.opened) {
                cell.sanjiaoxing.hidden=NO;
            } else {
                cell.sanjiaoxing.hidden=YES;
            }
            [dataList removeObjectAtIndex:_previousRow+1];
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            _previousRow = -1;
        }
        else if (indexPath.row < _previousRow) {
            if (preCell.opened) {
                preCell.sanjiaoxing.hidden=NO;
            } else {
                preCell.sanjiaoxing.hidden=YES;
            }
            
            [dataList removeObjectAtIndex:_previousRow+1];
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            _previousRow = indexPath.row;
            [dataList insertObject:@"增加的" atIndex:indexPath.row+1];
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else {
            if (preCell.opened) {
                preCell.sanjiaoxing.hidden=NO;
            } else {
                preCell.sanjiaoxing.hidden=YES;
            }
            
            NSInteger oler=_previousRow;
            _previousRow = indexPath.row;
            [dataList insertObject:@"增加的" atIndex:indexPath.row+1];
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [dataList removeObjectAtIndex:oler+1];
            _previousRow -=1;
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oler+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } else {
        _previousRow = indexPath.row;
        [dataList insertObject:@"增加的" atIndex:_previousRow+1];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataList.count;
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
    // Next time zero should still be displayed
    
    // You can customize the badge further (color, font, background), check BBBadgeBarButtonItem.h ;)
    YiDianViewController *yidianVC=[[YiDianViewController alloc]init];
    [self.navigationController pushViewController:yidianVC animated:YES];
}

#pragma mark - SongBottom delegate
- (void)addCollectionSong:(Song *)oneSong result:(KMessageStyle)result {
    [myToast dissmiss];
    switch (result) {
        case KMessageSuccess: {
            NSIndexPath *indexPath=[NSIndexPath indexPathForItem:_previousRow inSection:0];
            SongTopCell *cell=(SongTopCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.opened=!cell.opened;
            if (cell.opened) {
                cell.sanjiaoxing.hidden=NO;
            } else {
                cell.sanjiaoxing.hidden=YES;
            }
            [dataList removeObjectAtIndex:_previousRow+1];
            [self.tableView  deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            _previousRow=-1;
            [myToast setToastWithMessage:@"成功收藏"  WithTimeDismiss:nil messageType:KMessageSuccess];
            break;
        }
        case KMessageStyleError: {
            [myToast setToastWithMessage:@"收藏出错了,请重发"  WithTimeDismiss:nil messageType:KMessageStyleError];
            
            break;
        }
        case KMessageWarning: {
            [myToast setToastWithMessage:@"查询收藏出错了,请重发"  WithTimeDismiss:nil messageType:KMessageStyleError];
            
            break;
        }
        case KMessageStyleInfo: {
            [myToast setToastWithMessage:@"此歌已收藏"  WithTimeDismiss:nil messageType:KMessageStyleInfo];
            
            break;
        }
        case KMessageStyleDefault: {
            break;
        }
        default:
            break;
    }
    
}

- (void)dingGeFromCollection:(Song *)oneSong result:(KMessageStyle)result {
    //ding ge
    [myToast dissmiss];
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:_previousRow inSection:0];
    SongTopCell *cell=(SongTopCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.opened=!cell.opened;
    if (cell.opened) {
        cell.sanjiaoxing.hidden=NO;
    } else {
        cell.sanjiaoxing.hidden=YES;
    }
    [dataList removeObjectAtIndex:_previousRow+1];
    [self.tableView  deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    _previousRow=-1;
    [myToast setToastWithMessage:@"顶歌成功" WithTimeDismiss:nil messageType:KMessageSuccess];
    //TODO::
}

- (void)cutSongFromCollection:(Song *)oneSong result:(KMessageStyle)result {
    [myToast dissmiss];
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:_previousRow inSection:0];
    SongTopCell *cell=(SongTopCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.opened=!cell.opened;
    if (cell.opened) {
        cell.sanjiaoxing.hidden=NO;
    } else {
        cell.sanjiaoxing.hidden=YES;
    }
    [dataList removeObjectAtIndex:_previousRow+1];
    [self.tableView  deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    _previousRow=-1;
    [myToast setToastWithMessage:@"切歌成功" WithTimeDismiss:nil messageType:KMessageSuccess];
    //TODO::
    
    //cut song
}

#pragma mark -#########################################################


@end
