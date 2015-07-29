//
//  ResultTableViewController.m
//  ZZKTV
//
//  Created by stevenhu on 15/3/30.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import "ResultTableViewController.h"
#import "Song.h"
#import "Singer.h"
#import "NSManagedObject+helper.h"
#import "Utility.h"
#import "PinYinForObjc.h"
#define TOPCELLIDENTIFY @"SearchTableCell"
#import "SearchTableCell.h"
#define BOTTOMCELLIDENTIFY @"SongBottomCell"
#define SINGERCELLIDENTIFY @"SingsTableViewCell"
#import "SongBottomCell.h"
#import "MBProgressHUD.h"
#import "SingsTableViewCell.h"
#define SONGTABLE @"SongTable"
#define SINGERTABLE @"SingerTable"
#import "SingersViewController.h"
@interface ResultTableViewController ()<UITableViewDataSource,UITableViewDelegate,searchSongDelegate,UISearchBarDelegate> {
    NSInteger _previousRow;
    BOOL canSearch;
}
@property (nonatomic,strong)NSIndexPath *selectedIndexPath;
@property (nonatomic,strong)NSMutableArray *dataList;
@property (nonatomic,strong)NSMutableArray *singerList;
@property (nonatomic,strong)FMDatabase *searchDb;

@end

@implementation ResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _previousRow=-1;
    canSearch=YES;
    _searchSelectIndex = 0;
    _dataList = [[NSMutableArray alloc] init];
    _singerList = [[NSMutableArray alloc] init];
    [self initializeSearchController];
    _searchDb = [Utility instanceShare].db;
    [_searchDb open];
    
}

- (void)initializeSearchController {
    UINib *nib=[UINib nibWithNibName:@"SearchTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TOPCELLIDENTIFY];
    _previousRow = -1;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=50;
    self.tableView.backgroundColor=[UIColor clearColor];
    UIView *backView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView=backView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - use song cell or singer cell
- (SearchTableCell*)songCell :(UITableView*)tableView :(NSIndexPath*)indexPath {
    SearchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPCELLIDENTIFY forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.oneSong=self.dataList[indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    if (cell.opened) {
        cell.sanjiaoxing.hidden=NO;
    } else {
        cell.sanjiaoxing.hidden=YES;
    }
    return cell;
}
- (SingsTableViewCell*)singerCell :(UITableView*)tableView :(NSIndexPath*)indexPath {
    SingsTableViewCell *singerCell = [tableView dequeueReusableCellWithIdentifier:SINGERCELLIDENTIFY];
    if (!singerCell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:SINGERCELLIDENTIFY owner:self options:nil];
        singerCell = [nib objectAtIndex:0];
        singerCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"song_bt_bg"]];
        singerCell.singer = self.dataList[indexPath.row];
        return singerCell;
    }else {
        return nil;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_previousRow >= 0 && _previousRow+1==indexPath.row) {
        SongBottomCell *cell=[tableView dequeueReusableCellWithIdentifier:BOTTOMCELLIDENTIFY];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:BOTTOMCELLIDENTIFY owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"song_bt_bg"]];
            cell.oneSong=self.dataList[_previousRow];
            
        }
        return cell;
    } else {
        if (_searchSelectIndex == 0) {//查询全部
            if ([self.dataList[indexPath.row] isKindOfClass:[Song class]]) {
                return [self songCell:tableView :indexPath];
            }else {
                return [self singerCell:tableView :indexPath];
            }
            
        }else if(_searchSelectIndex == searchSong) {//查询单个
            return [self songCell:tableView :indexPath];
        }else {
            return [self singerCell:tableView :indexPath];
        }
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[SearchTableCell class]]) {
    SearchTableCell *cell=(SearchTableCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.opened) {
        cell.sanjiaoxing.hidden=NO;
    } else {
        cell.sanjiaoxing.hidden=YES;
    }
    if (_previousRow >= 0) {
        NSIndexPath *preIndexPath=[NSIndexPath indexPathForRow:_previousRow inSection:0];
        SearchTableCell *preCell=(SearchTableCell*)[tableView cellForRowAtIndexPath:preIndexPath];
        
        if (indexPath.row == _previousRow + 1) {
        }
        else if (indexPath.row == _previousRow) {
            cell.opened=!cell.opened;
            if (cell.opened) {
                cell.sanjiaoxing.hidden=NO;
            } else {
                cell.sanjiaoxing.hidden=YES;
            }
            [_dataList removeObjectAtIndex:_previousRow+1];
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            _previousRow = -1;
        }
        else if (indexPath.row < _previousRow) {
            if (preCell.opened) {
                preCell.sanjiaoxing.hidden=NO;
            } else {
                preCell.sanjiaoxing.hidden=YES;
            }
            
            [_dataList removeObjectAtIndex:_previousRow+1];
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            _previousRow = indexPath.row;
            [_dataList insertObject:@"增加的" atIndex:indexPath.row+1];
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
            [_dataList insertObject:@"增加的" atIndex:indexPath.row+1];
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [_dataList removeObjectAtIndex:oler+1];
            _previousRow -=1;
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oler+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } else {
        _previousRow = indexPath.row;
        [_dataList insertObject:@"增加的" atIndex:_previousRow+1];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_previousRow+1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    }
    }else {
        SingersViewController *singerVC = [[SingersViewController alloc] init];
//        [self.navigationController pushViewController:singerVC animated:YES];
        [self presentViewController:singerVC animated:YES completion:nil];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you ado not want the specified item to be editable.
    return NO;
}

- (void)reloadData {
    if (self.dataList.count > 0) {
        if ([self.delegate respondsToSelector:@selector(searching)]) {
            [self.delegate searching];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(searchDone)]) {
            [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
            [self.delegate searchDone];
        }
    }
    
    [self.tableView reloadData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchStr=[searchController.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!canSearch) return;
    if ( searchStr && searchStr.length>0) {
        canSearch=NO;
//        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [self initializeTableContent:searchStr];
    } else {
        canSearch=YES;
        [self.dataList removeAllObjects];
        [self reloadData];
    }
    
}

#pragma mark - sql method
- (void)searchSongData:(NSString*)tableName :(NSString*)conditionColumn :(NSString*)searchStr :(NSString*)column {
    NSString *temStr = [NSString stringWithFormat:@"%@%@",searchStr,@"%"];
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE songname LIKE '%@' OR %@ LIKE '%@'",column,tableName,temStr,conditionColumn,temStr];
    FMResultSet *rs = [_searchDb executeQuery:sql];
    while ([rs next]) {
        Song *tempSong = [[Song alloc] init];
        tempSong.songname = [rs stringForColumn:column];
        [self.dataList addObject:tempSong];
    }
}

- (void)searchSingData:(NSString*)tableName :(NSString*)conditionColumn :(NSString*)searchStr :(NSString*)column {
    NSString *temStr = [NSString stringWithFormat:@"%@%@",searchStr,@"%"];
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE singer LIKE '%@' OR  %@ LIKE '%@'",column,tableName,temStr,conditionColumn,temStr];
    FMResultSet *rs = [_searchDb executeQuery:sql];
    while ([rs next]) {
        Singer *tempSinger = [[Singer alloc] init];
        tempSinger.singer = [rs stringForColumn:column];
        [self.dataList addObject:tempSinger];
    }
}


- (void)initializeTableContent:(NSString*)searchStr {
     NSString *enCodeSearchStr = [Utility encodeBase64:[searchStr uppercaseString]];
    [self.dataList removeAllObjects];
    [self.singerList removeAllObjects];
    if (_searchSelectIndex == searchAll) {
        [self searchSongData:SONGTABLE :@"songpiy" :enCodeSearchStr :@"songname"];
        [self searchSingData:SINGERTABLE :@"pingyin" :enCodeSearchStr :@"singer"];
        
    }else if (_searchSelectIndex == searchSong){
        [self searchSongData:SONGTABLE :@"songpiy" :enCodeSearchStr :@"songname"];
    }else {
        [self searchSingData:SINGERTABLE :@"pingyin" :enCodeSearchStr :@"singer"];
    }
    canSearch = YES;
    [self reloadData];
//    [self.tableView reloadData];
    
//    if (_searchSelectIndex == 0) {
//        [Song async:^id(NSManagedObjectContext *ctx, NSString *className) {
//            NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Song"];
//            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"songname BEGINSWITH %@ OR songpiy BEGINSWITH %@",searchStr,[searchStr uppercaseString]]];
//            fetchRequest.fetchLimit=40;
//            fetchRequest.fetchBatchSize=20;
//            NSError *error;
//            NSArray *tmpArray = [ctx executeFetchRequest:fetchRequest error:&error];
//            canSearch=YES;
//            if (error) {
//                [self.dataList removeAllObjects];
//                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//                return error;
//            }else{
//                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//                return tmpArray;
//            }
//            
//        } result:^(NSArray *result, NSError *error) {
//            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//            [self.dataList addObject:result];
////            [self reloadData];
//            canSearch=YES;
//        }];
//        
//        [Singer async:^id(NSManagedObjectContext *ctx, NSString *className) {
//            NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Singer"];
//            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"singer BEGINSWITH %@ OR pingyin BEGINSWITH %@",searchStr,[searchStr uppercaseString]]];
//            fetchRequest.fetchLimit=40;
//            fetchRequest.fetchBatchSize=20;
//            NSError *error;
//            NSArray *tmpArray = [ctx executeFetchRequest:fetchRequest error:&error];
//            canSearch=YES;
//            if (error) {
////                [self.dataList removeAllObjects];
//                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//                return error;
//            }else{
//                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//                return tmpArray;
//            }
//            
//        } result:^(NSArray *result, NSError *error) {
//            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//            [self.dataList addObject:result];
//            [self reloadData];
//            canSearch=YES;
//        }];
//        
//    }else if (_searchSelectIndex == 1) {
//        [Song async:^id(NSManagedObjectContext *ctx, NSString *className) {
//            NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Song"];
//            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"songname BEGINSWITH %@ OR songpiy BEGINSWITH %@",searchStr,[searchStr uppercaseString]]];
//            fetchRequest.fetchLimit=40;
//            fetchRequest.fetchBatchSize=20;
//            NSError *error;
//            NSArray *tmpArray = [ctx executeFetchRequest:fetchRequest error:&error];
//            canSearch=YES;
//            if (error) {
//                [self.dataList removeAllObjects];
//                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//                return error;
//            }else{
//                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//                return tmpArray;
//            }
//            
//        } result:^(NSArray *result, NSError *error) {
//            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//            self.dataList = [result mutableCopy];
//            [self reloadData];
//            canSearch=YES;
//        }];
//    }else if (_searchSelectIndex == 2) {
//        [Singer async:^id(NSManagedObjectContext *ctx, NSString *className) {
//            NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Singer"];
//            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"singer BEGINSWITH %@ OR pingyin BEGINSWITH %@",searchStr,[searchStr uppercaseString]]];
//            fetchRequest.fetchLimit=40;
//            fetchRequest.fetchBatchSize=20;
//            NSError *error;
//            NSArray *tmpArray = [ctx executeFetchRequest:fetchRequest error:&error];
//            canSearch=YES;
//            if (error) {
//                [self.dataList removeAllObjects];
//                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//                return error;
//            }else{
//                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//                return tmpArray;
//            }
//            
//        } result:^(NSArray *result, NSError *error) {
//            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//            self.dataList = [result mutableCopy];
//            [self reloadData];
//            canSearch=YES;
//        }];
//    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    canSearch=YES;
    //    [self.dataList removeAllObjects];
    //    [self reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"searchBarCancelButtonClicked");
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBarResultsListButtonClicked");
}
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    NSLog(@"currentSlectedIndex:%ld",(long)selectedScope);
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    UIButton *cancelButton;
    UIView *topView = searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        //Set the new title of the cancel button
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.tintColor = [UIColor whiteColor];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    canSearch=YES;
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - SelectViewOnSelectedDelegate
- (void)selectViewOnSelectedIndex:(NSUInteger)index {
    NSLog(@"%lu",(unsigned long)index);
    switch (index) {
        case 0:
            _searchSelectIndex = searchAll;
            break;
        case 1:
            _searchSelectIndex = searchSong;
            break;
        case 2:
            _searchSelectIndex = searchSinger;
            break;
        default:
            break;
    }
}

@end
