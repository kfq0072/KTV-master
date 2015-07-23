//
//  SoundViewController.m
//  KTV
//
//  Created by stevenhu on 15/5/2.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "SoundViewController.h"
#import "CoreEmotionView.h"
#import "NSArray+SubArray.h"
#import "NSString+EmotionExtend.h"
#import "BBBadgeBarButtonItem.h"
#import "YiDianViewController.h"
#import "Utility.h"
@interface SoundViewController ()<UITextFieldDelegate>{
    UITextField *sendInput;
    soundView *mySoundView;
    
}
@property(nonatomic,strong)CoreEmotionView *emotionView;
@property (nonatomic,assign) NSUInteger curve;
@property (nonatomic,assign) CGFloat time;
@end

@implementation SoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"播控";
    [self initNavigationItem];
    if ( nil != self.navigationController ) {
        CGRect rect=self.view.frame;
        rect.size.height-=self.navigationController.navigationBar.bounds.size.height;
        mySoundView=[[soundView alloc]initWithFrame:rect];
    } else {
        mySoundView=[[soundView alloc]initWithFrame:self.view.frame];

    }
    mySoundView.delegate=self;
    [self.view addSubview:mySoundView];
        
//    // keyboard
//    sendInput=[[UITextField alloc]init];
//    CGRect sendRect=CGRectMake(0, 0, 200, 40);
//    sendRect.origin.x=4;
//    sendRect.origin.y=3;
//    sendRect.size.width-=8;
//    sendRect.size.height-=6;
//    sendInput.frame=sendRect;
//    sendInput.layer.borderWidth=1;
//    sendInput.backgroundColor=[UIColor whiteColor];
//    sendInput.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
//    sendInput.placeholder=@"发送内容";
//    sendInput.tintColor=[UIColor whiteColor];
//    sendInput.layer.cornerRadius=8;
//    UIBarButtonItem *sendInputItem=[[UIBarButtonItem alloc]initWithCustomView:sendInput];
//    UIBarButtonItem *flex0=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
//    
//    switchBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    switchBtn.frame=CGRectMake(0, 0, 40, 40);
//    [switchBtn setTitle:@"切换" forState:UIControlStateNormal];
//    [switchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    UIBarButtonItem *switchItem=[[UIBarButtonItem alloc]initWithCustomView:switchBtn];
//    
//    sendBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    sendBtn.frame=CGRectMake(0, 0, 40, 40);
//    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
//    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    UIBarButtonItem *sendItem=[[UIBarButtonItem alloc]initWithCustomView:sendBtn];
//    self.toolbarItems=@[flex0,sendInputItem,flex0,switchItem,flex0,sendItem];
//    
//    
}



- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    __weak __typeof(BBBadgeBarButtonItem*)weakBarButton=barButton;
    [[Utility instanceShare]setYidianBadgeWidth:weakBarButton];
    [barButton registNofification];
}

- (void)viewDidDisappear:(BOOL)animated  {
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    [barButton registNofification];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exitShengKongView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//navigationbar

- (void)initNavigationItem {
    //navigation item
    UIButton *rightbtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightbtn.frame=CGRectMake(0, 0, 25, 25);
    [rightbtn.titleLabel sizeToFit];
    [rightbtn setImage:[UIImage imageNamed:@"yidian"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(clicked_yidian:) forControlEvents:UIControlEventTouchUpInside];
    BBBadgeBarButtonItem *barButton=[[BBBadgeBarButtonItem alloc] initWithCustomUIButton:rightbtn];
//    barButton.badgeValue =[Utility instanceShare].yidianBadge;
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



@end
