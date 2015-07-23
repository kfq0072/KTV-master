//
//  ViewController.m
//  KTV
//
//  Created by stevenhu on 15/4/17.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "MainViewController.h"
#import "huSearchBar.h"
#import "SettingViewController.h"
#import "SearchSongListViewController.h"
#import "ScanCodeViewController.h"
#import "SingerAreaViewController.h"
#import "jinxuanViewController.h"
#import "paiHangViewController.h"
#import "newSongViewController.h"
#import "YiDianViewController.h"
#import "CollectionViewController.h"
#import "SoundViewController.h"
#import "Utility.h"
#import "BokongView.h"
#import "BBBadgeBarButtonItem.h"
#import "MBProgressHUD.h"
#import "HuToast.h"
static BOOL showToast=YES;

@interface MainViewController ()<UISearchBarDelegate,ScanCodeDelegate> {
    UIButton *geshouBtn;
    UIButton *paihangBtn;
    UIButton *jinxuanBtn;
    UIButton *newSongBtn;
    UIButton *shoucanBtn;
    UIButton *conHostBtn;
    UIBarButtonItem *kege;
    UIBarButtonItem *bokong;
    MBProgressHUD *HUD;
    HuToast *myToast;
    NSURLConnection *connection;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"K歌";
    [self initNavigationItem];
    myToast=[[HuToast alloc]init];
    self.automaticallyAdjustsScrollViewInsets=YES;
    [self createContextUI];
    [Utility whatIphoneDevice];
//    [self copyFile];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"初始化数据";
    HUD.detailsLabelText = @"请您耐心等待......";
    HUD.square = YES;
    HUD.dimBackground=YES;
    HUD.detailsLabelColor=[UIColor greenColor];
    [HUD show:YES];
    [[Utility instanceShare]addIntoDataSource:^(BOOL Completed) {
        [HUD removeFromSuperview];
    }];
}

- (void)copyFile {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *sourcePath=[[NSBundle mainBundle]pathForResource:@"KTV-master.zip" ofType:nil];
    NSString *distancePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"KTV_Master.zip"];
    [fileManager copyItemAtPath:sourcePath toPath:distancePath error:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clicked_setting:(id)sender {
    SettingViewController *setVC=[[SettingViewController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
}

-(void)click_geshou:(id)sender {
    SingerAreaViewController *vc=[[SingerAreaViewController alloc]init];
//    UINavigationController *naVC=[[UINavigationController alloc]initWithRootViewController:vc];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clicked_paihangBtn:(id)sender {
    paiHangViewController *vc=[[paiHangViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)click_jinxuanBtn:(id)sender {
    jinxuanViewController *vc=[[jinxuanViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)click_newSong:(id)sender {
    newSongViewController *vc=[[newSongViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)click_shoucang:(id)sender {
    CollectionViewController *vc=[[CollectionViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)connect_Host:(id)sender {
    ScanCodeViewController *scanVC=[[ScanCodeViewController alloc]init];
    [self presentViewController:scanVC animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    SearchSongListViewController *vc=[[SearchSongListViewController alloc]initWithStyle:UITableViewStylePlain];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController: vc animated:YES completion: nil];
    return YES;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canResignFirstResponder {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    __weak __typeof(BBBadgeBarButtonItem*)weakBarButton=barButton;
    [[Utility instanceShare]setYidianBadgeWidth:weakBarButton];}

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


// Fake adding element
- (IBAction)addItemToListButtonPressed {
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItem;
    barButton.badgeValue = [NSString stringWithFormat:@"%d", [barButton.badgeValue intValue] + 1];
}

- (void)createContextUI{
    //main view
    //bg
    UIImageView *bgImageView;
//    if (self.navigationController!=nil) {
//        CGRect rect=self.view.frame;
//        rect.size.height-=self.navigationController.navigationBar.bounds.size.height;
//        bgImageView=[[UIImageView alloc]initWithFrame:rect];
//    } else {
        bgImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
//    }
    bgImageView.image=[UIImage imageNamed:@"mainVC_bg"];
    self.view =bgImageView;
    bgImageView.center=self.view.center;
    bgImageView.userInteractionEnabled=YES;
    //heard
    
    UIImageView *headView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENSIZE.width/2-HEADVIEW_WH/2, HEADVIEW_TOPMARGIN, HEADVIEW_WH, HEADVIEW_WH)];
    
    [headView setImage:[UIImage imageNamed:@"touxiang"]];
    [bgImageView addSubview:headView];
    //searchbar
    huSearchBar *searchBar=[[huSearchBar alloc]initWithFrame:CGRectMake(SEARCHMARGIN_LRT,SEARCHMARGIN_TOPMARGIN,SCREENSIZE.width-(SEARCHMARGIN_LRT*2), SEARCH_H)];
    searchBar.placeholder=@"输入歌星或歌名";
    searchBar.delegate=self;
    [self.view addSubview:searchBar];
    
    /**
     *  /
     *
     *  topBGView
     */
    
    UIView *topBGView=[[UIView alloc]initWithFrame:CGRectMake(searchBar.frame.origin.x, TOPBGView_TOPMARGIN, searchBar.bounds.size.width, TOPBGView_H)];
    [self.view addSubview:topBGView];
    //    topBGView.backgroundColor=[UIColor whiteColor];
    //geshouBtn
    geshouBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    geshouBtn.frame=CGRectMake(searchBar.frame.origin.x+SEARCHMARGIN_LRT, 0, BUTTON_WH, BUTTON_WH);
    [geshouBtn setImage:[UIImage imageNamed:@"geshou"] forState:UIControlStateNormal];
    [geshouBtn addTarget:self action:@selector(click_geshou:) forControlEvents:UIControlEventTouchUpInside];
    [topBGView addSubview:geshouBtn];
    
    UILabel *geshouLabel=[[UILabel alloc]initWithFrame:CGRectMake(geshouBtn.frame.origin.x, CGRectGetMaxY(geshouBtn.frame)+2, geshouBtn.bounds.size.width, 22)];
    geshouLabel.text=@"歌手";
    geshouLabel.textAlignment=NSTextAlignmentCenter;
    geshouLabel.font=[UIFont systemFontOfSize:14.0f];
    [geshouLabel setTextColor:[UIColor groupTableViewBackgroundColor]];
    [topBGView addSubview:geshouLabel];
    
    //paihangBtn
    paihangBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    paihangBtn.frame=CGRectMake(CGRectGetMaxX(geshouBtn.frame)+SEARCHMARGIN_LRT*2, 0, BUTTON_WH, BUTTON_WH);
    [paihangBtn setImage:[UIImage imageNamed:@"paihangbang"] forState:UIControlStateNormal];
    [paihangBtn addTarget:self action:@selector(clicked_paihangBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topBGView addSubview:paihangBtn];
    
    UILabel *paihangLabel=[[UILabel alloc]initWithFrame:CGRectMake(paihangBtn.frame.origin.x,geshouLabel.frame.origin.y, geshouBtn.bounds.size.width, 22)];
    paihangLabel.text=@"排行榜";
    paihangLabel.textAlignment=NSTextAlignmentCenter;
    paihangLabel.font=[UIFont systemFontOfSize:14.0f];
    [paihangLabel setTextColor:[UIColor groupTableViewBackgroundColor]];
    [topBGView addSubview:paihangLabel];
    
    //jinxuanBtn
    jinxuanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    jinxuanBtn.frame=CGRectMake(CGRectGetMaxX(paihangBtn.frame)+SEARCHMARGIN_LRT*2, 0, BUTTON_WH, BUTTON_WH);
    [jinxuanBtn setImage:[UIImage imageNamed:@"jinxuanji"] forState:UIControlStateNormal];
    [jinxuanBtn addTarget:self action:@selector(click_jinxuanBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topBGView addSubview:jinxuanBtn];
    
    UILabel *jinxuanLabel=[[UILabel alloc]initWithFrame:CGRectMake(jinxuanBtn.frame.origin.x,geshouLabel.frame.origin.y, geshouBtn.bounds.size.width, 22)];
    jinxuanLabel.text=@"精选集";
    jinxuanLabel.textAlignment=NSTextAlignmentCenter;
    jinxuanLabel.font=[UIFont systemFontOfSize:14.0f];
    [jinxuanLabel setTextColor:[UIColor groupTableViewBackgroundColor]];
    [topBGView addSubview:jinxuanLabel];
    
    /**
     *  /
     *
     *  bottomBGView
     */
    
    
    UIView *bottomBGView=[[UIView alloc]initWithFrame:CGRectMake(SEARCHMARGIN_LRT, BOTTOMBGView_TOPMARGIN, searchBar.bounds.size.width, topBGView.bounds.size.height)];
    [self.view addSubview:bottomBGView];
    //    bottomBGView.backgroundColor=[UIColor whiteColor];
    
    //changchanBtn
    newSongBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    newSongBtn.frame=CGRectMake(searchBar.frame.origin.x+SEARCHMARGIN_LRT, 0, BUTTON_WH, BUTTON_WH);
    [newSongBtn setImage:[UIImage imageNamed:@"changchan"] forState:UIControlStateNormal];
    [newSongBtn addTarget:self action:@selector(click_newSong:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBGView addSubview:newSongBtn];
    
    UILabel *newSongLabel=[[UILabel alloc]initWithFrame:CGRectMake(newSongBtn.frame.origin.x, CGRectGetMaxY(newSongBtn.frame)+2, newSongBtn.bounds.size.width, 22)];
    newSongLabel.text=@"新歌";
    newSongLabel.textAlignment=NSTextAlignmentCenter;
    newSongLabel.font=[UIFont systemFontOfSize:14.0f];
    [newSongLabel setTextColor:[UIColor groupTableViewBackgroundColor]];
    [bottomBGView addSubview:newSongLabel];
    
    //shoucanBtn
    shoucanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shoucanBtn.frame=CGRectMake(CGRectGetMaxX(newSongBtn.frame)+SEARCHMARGIN_LRT*2, 0, BUTTON_WH, BUTTON_WH);
    [shoucanBtn setImage:[UIImage imageNamed:@"shoucan"] forState:UIControlStateNormal];
    [shoucanBtn addTarget:self action:@selector(click_shoucang:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBGView addSubview:shoucanBtn];
    
    UILabel *shoucanLabel=[[UILabel alloc]initWithFrame:CGRectMake(shoucanBtn.frame.origin.x,CGRectGetMaxY(shoucanBtn.frame)+2, shoucanBtn.bounds.size.width, 22)];
    shoucanLabel.text=@"收藏的歌";
    shoucanLabel.textAlignment=NSTextAlignmentCenter;
    shoucanLabel.font=[UIFont systemFontOfSize:14.0f];
    [shoucanLabel setTextColor:[UIColor groupTableViewBackgroundColor]];
    [bottomBGView addSubview:shoucanLabel];
    
    //conHostBtn
    conHostBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    conHostBtn.frame=CGRectMake(CGRectGetMaxX(shoucanBtn.frame)+SEARCHMARGIN_LRT*2, 0, BUTTON_WH, BUTTON_WH);
    [conHostBtn setImage:[UIImage imageNamed:@"conhost"] forState:UIControlStateNormal];
    [bottomBGView addSubview:conHostBtn];
    
    UILabel *conHostLabel=[[UILabel alloc]initWithFrame:CGRectMake(conHostBtn.frame.origin.x,CGRectGetMaxY(conHostBtn.frame)+2, jinxuanBtn.bounds.size.width, 22)];
    conHostLabel.text=@"连接包厢";
    conHostLabel.textAlignment=NSTextAlignmentCenter;
    conHostLabel.font=[UIFont systemFontOfSize:14.0f];
    [conHostLabel setTextColor:[UIColor groupTableViewBackgroundColor]];
    [conHostBtn addTarget:self action:@selector(connect_Host:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBGView addSubview:conHostLabel];
}

#pragma mark- ScanCodeDelegate
- (void)didFinishedScanCode:(NSError *)error withString:(NSString *)string {
    [myToast setToastWithMessage:string WithTimeDismiss:@"2" messageType:KMessageStyleInfo];
}
@end
