//
//  YiDianViewController.m
//  KTV
//
//  Created by stevenhu on 15/4/26.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "YiDianViewController.h"
#define TOPCELLIDENTIFY @"YiDianTopViewCell"
#import "YiDianTopViewCell.h"
#import "YiDianBottomCell.h"
#define BOTTOMCELLIDENTIFY @"YiDianBottomCell"
#import "CommandControler.h"
#import "Song.h"
#import "NSManagedObject+helper.h"

@interface YiDianViewController ()<SongListSongDelegate>
{
    NSInteger _previousRow;
    HuToast *myToast;
    CommandControler *cmd;
}
@property (nonatomic, strong) NSMutableArray *dataSrc;

@end

@implementation YiDianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"已点";
    _previousRow = -1;
    myToast=[[HuToast alloc]init];
    cmd=[[CommandControler alloc]init];
    _dataSrc=[[NSMutableArray alloc]init];
    [self initializeTableContent];
    UINib *nib=[UINib nibWithNibName:TOPCELLIDENTIFY bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TOPCELLIDENTIFY];
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableView.tableFooterView=backView;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    UIImageView *bgImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"songsList_bg"]];
    self.tableView.backgroundView=bgImageView;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
}

- (void)initializeTableContent {
//    [Song async:^id(NSManagedObjectContext *ctx, NSString *className) {
//        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Song"];
//        NSArray *yidianList=[cmd sendCmd_get_yiDianList];
//        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"number IN %@",yidianList]];
//        NSError *error;
//        NSArray *tmpArray = [ctx executeFetchRequest:fetchRequest error:&error];
//        if (error) {
//            return error;
//        }else{
//            return tmpArray;
//        }
//    } result:^(NSArray *result, NSError *error) {
//        _dataSrc=[result mutableCopy];
//        [self.tableView reloadData];
//    }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YiDianTopViewCell *cell=(YiDianTopViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.opened=!cell.opened;
    if (cell.opened) {
        cell.sanjiaoxing.hidden=NO;
    } else {
        cell.sanjiaoxing.hidden=YES;
    }
    if (_previousRow >= 0) {
        NSIndexPath *preIndexPath=[NSIndexPath indexPathForRow:_previousRow inSection:0];
        YiDianTopViewCell *preCell=(YiDianTopViewCell*)[tableView cellForRowAtIndexPath:preIndexPath];
        
        if (indexPath.row == _previousRow + 1) {
            //            NSLog(@"fff");
        }
        else if (indexPath.row == _previousRow) {
            
            [self.dataSrc removeObjectAtIndex:_previousRow+1];
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            _previousRow = -1;
        }
        else if (indexPath.row < _previousRow) {
            preCell.opened=!preCell.opened;
            if (preCell.opened) {
                preCell.sanjiaoxing.hidden=NO;
            } else {
                preCell.sanjiaoxing.hidden=YES;
            }
            
            [self.dataSrc removeObjectAtIndex:_previousRow+1];
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            _previousRow = indexPath.row;
            [self.dataSrc insertObject:@"增加的" atIndex:indexPath.row+1];
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else {
            preCell.opened=!preCell.opened;
            if (preCell.opened) {
                preCell.sanjiaoxing.hidden=NO;
            } else {
                preCell.sanjiaoxing.hidden=YES;
            }
            
            NSInteger oler=_previousRow;
            _previousRow = indexPath.row;
            [self.dataSrc insertObject:@"增加的" atIndex:indexPath.row+1];
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [self.dataSrc removeObjectAtIndex:oler+1];
            _previousRow -=1;
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oler+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } else {
        _previousRow = indexPath.row;
        [self.dataSrc insertObject:@"增加的" atIndex:_previousRow+1];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_previousRow >= 0 && _previousRow+1==indexPath.row) {
        YiDianBottomCell *cell=[tableView dequeueReusableCellWithIdentifier:BOTTOMCELLIDENTIFY];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:BOTTOMCELLIDENTIFY owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.delegate=self;
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"song_bt_bg"]];
            cell.oneSong=_dataSrc[_previousRow];
            cell.delegate=self;
        }
        return cell;
    } else {
        YiDianTopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPCELLIDENTIFY forIndexPath:indexPath];
        cell.oneSong=self.dataSrc[indexPath.row];
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


#pragma mark - SongBottom delegate
- (void)addCollectionSong:(Song *)oneSong result:(KMessageStyle)result {
    [myToast dissmiss];
    switch (result) {
        case KMessageSuccess: {
            NSIndexPath *indexPath=[NSIndexPath indexPathForItem:_previousRow inSection:0];
            YiDianTopViewCell *cell=(YiDianTopViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.opened=!cell.opened;
            if (cell.opened) {
                cell.sanjiaoxing.hidden=NO;
            } else {
                cell.sanjiaoxing.hidden=YES;
            }
            [_dataSrc removeObjectAtIndex:_previousRow+1];
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
    YiDianTopViewCell *cell=(YiDianTopViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.opened=!cell.opened;
    if (cell.opened) {
        cell.sanjiaoxing.hidden=NO;
    } else {
        cell.sanjiaoxing.hidden=YES;
    }
    [_dataSrc removeObjectAtIndex:_previousRow+1];
    [self.tableView  deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    _previousRow=-1;
    [myToast setToastWithMessage:@"顶歌成功" WithTimeDismiss:nil messageType:KMessageSuccess];
    //TODO::
}

- (void)cutSongFromCollection:(Song *)oneSong result:(KMessageStyle)result {
    [myToast dissmiss];
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:_previousRow inSection:0];
    YiDianTopViewCell *cell=(YiDianTopViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.opened=!cell.opened;
    if (cell.opened) {
        cell.sanjiaoxing.hidden=NO;
    } else {
        cell.sanjiaoxing.hidden=YES;
    }
    [_dataSrc removeObjectAtIndex:_previousRow+1];
    [self.tableView  deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    _previousRow=-1;
    [myToast setToastWithMessage:@"切歌成功" WithTimeDismiss:nil messageType:KMessageSuccess];
    //TODO::
    
    //cut song
}

- (void)removeFromCollection:(Song *)oneSong result:(KMessageStyle)result {
    //ding ge
    [myToast dissmiss];
    [self initializeTableContent];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:_previousRow inSection:0];
//    YiDianTopViewCell *cell=(YiDianTopViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
//    cell.opened=!cell.opened;
//    if (cell.opened) {
//        cell.sanjiaoxing.hidden=NO;
//    } else {
//        cell.sanjiaoxing.hidden=YES;
//    }
//    [_dataSrc removeObjectAtIndex:_previousRow+1];
//    [_dataSrc removeObjectAtIndex:_previousRow];
//    [self.tableView  deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow inSection:0],[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    _previousRow=-1;
    [myToast setToastWithMessage:@"移除成功" WithTimeDismiss:nil messageType:KMessageSuccess];
    //TODO::
}

#pragma mark -#########################################################


@end
