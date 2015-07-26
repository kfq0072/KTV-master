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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_searchSelectIndex) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_searchSelectIndex && ([self.dataList count] || [self.singerList count])) {
        return [self.dataList count] +[self.singerList count];
    }
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
            if ([self.dataList count]>0) {
        
                SearchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPCELLIDENTIFY forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //                cell.oneSong=self.dataList[indexPath.row];
                cell.songName.text = self.dataList[indexPath.row];
                cell.backgroundColor=[UIColor clearColor];
                if (cell.opened) {
                    cell.sanjiaoxing.hidden=NO;
                } else {
                    cell.sanjiaoxing.hidden=YES;
                }
                return cell;
            }else if ([self.singerList count]>0) {
                SingsTableViewCell *singerCell = [tableView dequeueReusableCellWithIdentifier:SINGERCELLIDENTIFY];
                if (!singerCell) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:SINGERCELLIDENTIFY owner:self options:nil];
                    singerCell = [nib objectAtIndex:0];
                    singerCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"song_bt_bg"]];
                    //                    singerCell.singer = self.dataList[indexPath.row];
                    singerCell.SingerLabel.text = self.singerList[indexPath.row];
                    return singerCell;
                }
            }
            
//            NSArray *array = self.dataList[indexPath.section];
//            if ([array[0] isKindOfClass:[Song class]]) {
//                SearchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPCELLIDENTIFY forIndexPath:indexPath];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
////                cell.oneSong=array[indexPath.row];
//                 cell.songName.text = self.dataList[indexPath.row];
//                cell.backgroundColor=[UIColor clearColor];
//                if (cell.opened) {
//                    cell.sanjiaoxing.hidden=NO;
//                } else {
//                    cell.sanjiaoxing.hidden=YES;
//                }
//                return cell;
//     
//            }else if ([array[0] isKindOfClass:[Singer class]]) {
//                SingsTableViewCell *singerCell = [tableView dequeueReusableCellWithIdentifier:SINGERCELLIDENTIFY];
//                if (!singerCell) {
//                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:SINGERCELLIDENTIFY owner:self options:nil];
//                    singerCell = [nib objectAtIndex:0];
//                    singerCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"song_bt_bg"]];
////                    singerCell.singer = array[indexPath.row];
//                    singerCell.SingerLabel.text = self.singerList[indexPath.row];
//                    return singerCell;
//                }
//            }
        }else if(_searchSelectIndex == searchSong) {//查询单个
                SearchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPCELLIDENTIFY forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                cell.oneSong=self.dataList[indexPath.row];
            cell.songName.text = self.dataList[indexPath.row];
                cell.backgroundColor=[UIColor clearColor];
                if (cell.opened) {
                    cell.sanjiaoxing.hidden=NO;
                } else {
                    cell.sanjiaoxing.hidden=YES;
                }
                return cell;
        
            
        }else {
                SingsTableViewCell *singerCell = [tableView dequeueReusableCellWithIdentifier:SINGERCELLIDENTIFY];
                if (!singerCell) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:SINGERCELLIDENTIFY owner:self options:nil];
                    singerCell = [nib objectAtIndex:0];
                    singerCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"song_bt_bg"]];
//                    singerCell.singer = self.dataList[indexPath.row];
                    singerCell.SingerLabel.text = self.dataList[indexPath.row];
                    return singerCell;
                }
        }
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
            //            NSLog(@"fff");
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
- (void)searchData:(NSString*)tableName :(NSString*)conditionColumn :(NSString*)searchStr :(NSString*)column {
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@='%@'",column,tableName,conditionColumn,searchStr];
    FMResultSet *rs = [_searchDb executeQuery:sql];
    if (_searchSelectIndex == searchAll) {
        if ([tableName isEqualToString:SONGTABLE]) {
            while ([rs next]) {
                NSString *data= [Utility  decodeBase64:[rs stringForColumn:column]];
                [self.dataList addObject:data];
            }
        }else {
            while ([rs next]) {
                NSString *data= [Utility  decodeBase64:[rs stringForColumn:column]];
                [self.singerList addObject:data];
            }
        }
    }else {
        while ([rs next]) {
            NSString *data= [Utility  decodeBase64:[rs stringForColumn:column]];
            [self.dataList addObject:data];
        }
    }
}


- (void)initializeTableContent:(NSString*)searchStr {
     NSString *enCodeSearchStr = [Utility encodeBase64:searchStr];
    [self.dataList removeAllObjects];
    [self.singerList removeAllObjects];
    if (_searchSelectIndex == searchAll) {
        [self searchData:SONGTABLE :@"songpiy" :enCodeSearchStr :@"songname"];
        [self searchData:SINGERTABLE :@"pingyin" :enCodeSearchStr :@"singer"];
        
    }else if (_searchSelectIndex == searchSong){
        [self searchData:SONGTABLE :@"songpiy" :enCodeSearchStr :@"songname"];
    }else {
        [self searchData:SINGERTABLE :@"pingyin" :enCodeSearchStr :@"singer"];
    }
     NSLog(@"---: %@",self.dataList);
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
//    
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
