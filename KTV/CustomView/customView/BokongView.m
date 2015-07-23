//
//  BokongView.m
//  KTV
//
//  Created by stevenhu on 15/4/27.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#define SCREEN_SIZE  [UIScreen mainScreen].bounds.size
#define WINDOW  [UIApplication sharedApplication].keyWindow
#define BOKONG_WIDTH (SCREEN_SIZE.width-20)
#define BOKONG_HEIGHT 80
#define BOKONG_SPACE 15
#define LABEL_HEIGHT 20
#import "BokongView.h"
#import "CommandControler.h"
@interface BokongView(){
    UIView *chuckView;
    UIImageView *bokong;
    UIButton *exitButton;
    float bokongViewHeight;
    BOOL isShow;
    
    //controller
    CommandControler *cmdController;    
}

@end
static BokongView *shareInstance=nil;
@implementation BokongView

+(instancetype)instanceShare {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareInstance) {
            shareInstance=[[self alloc]init];
        }
    });
    return shareInstance;

}



+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance=[super allocWithZone:zone];
    });
    return shareInstance;
}

- (void)showAtView:(UIView*)view {
    
    if (isShow) {
        [self disMiss];
    } else {
        cmdController=[[CommandControler alloc]init];
        [self createViews];
        [self showView];
       
    }
}

- (void)disMiss {
    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        bokong.alpha=0;
        [bokong setFrame:CGRectMake(BOKONG_SPACE,WINDOW.bounds.size.height+bokongViewHeight,chuckView.bounds.size.width-BOKONG_SPACE*2, bokongViewHeight)];
        if ([self.delegate respondsToSelector:@selector(boKongHadDimssed)]) {
            [self.delegate boKongHadDimssed];
        }
    } completion:^(BOOL finished) {
        isShow=NO;
        [chuckView removeFromSuperview];

    }];
    
}

-(void)showView {
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:0 animations:^{
        [bokong setFrame:CGRectMake(BOKONG_SPACE,chuckView.bounds.size.height-bokongViewHeight-69,chuckView.bounds.size.width-BOKONG_SPACE*2,bokongViewHeight)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            [bokong setFrame:CGRectMake(BOKONG_SPACE, SCREEN_SIZE.height-bokongViewHeight-49,chuckView.bounds.size.width-BOKONG_SPACE*2,bokongViewHeight)];
            isShow=YES;
        }];
    }];
}

- (void)createViews {
    // chuckview
    chuckView=[[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    float oneWidth=(WINDOW.bounds.size.width-BOKONG_SPACE)/4-BOKONG_SPACE*1.5;
    bokongViewHeight=BOKONG_HEIGHT+BOKONG_SPACE+LABEL_HEIGHT;
    bokong=[[UIImageView alloc]initWithFrame:CGRectMake(BOKONG_SPACE, WINDOW.bounds.size.height,chuckView.bounds.size.width-BOKONG_SPACE*2, bokongViewHeight)];
    bokong.userInteractionEnabled=YES;
    [bokong setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"bokong_bg" ofType:@"png"]]];
    bokong.layer.cornerRadius=8;
    
    //buttons
    NSArray *strArray=@[@"原/伴",@"切歌",@"播停", @"重唱"];
    NSMutableArray *btnArray=[[NSMutableArray alloc]init];
    for (int i=0;i<4;i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(BOKONG_SPACE*(i+1)+i*oneWidth,BOKONG_SPACE,oneWidth,oneWidth);
        button.tag=i;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bokong%d",i]] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(bokongBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [bokong addSubview:button];
        
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame),button.bounds.size.width,(LABEL_HEIGHT))];
        lable.text=strArray[i];
        lable.font=[UIFont systemFontOfSize:14];
        lable.textAlignment=NSTextAlignmentCenter;
        lable.textColor=[UIColor whiteColor];
        [bokong addSubview:lable];
        [btnArray addObject:lable];
    
    }
    exitButton=[[UIButton alloc]initWithFrame:CGRectMake(bokong.bounds.size.width-20, -10, 30, 30)];
    [exitButton setBackgroundImage:[UIImage imageNamed:@"close_1"] forState:UIControlStateNormal];
    [exitButton setBackgroundImage:[UIImage imageNamed:@"close_2"] forState:UIControlStateHighlighted];
    [exitButton addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    [bokong addSubview:exitButton];
    
    [chuckView addSubview:bokong];
    [[UIApplication sharedApplication].keyWindow addSubview:chuckView];
}


- (void)bokongBtn_clicked:(id)sender {
    UIButton *btn=(UIButton*)sender;
    switch (btn.tag) {
        case 0: {
            [cmdController sendCmd_yuanChang_pangChang];
            break;
        }
        case 1: {
            [cmdController sendCmd_switchSong];
            break;
        }
        case 2: {
            [cmdController sendCmd_rePlay];
            break;
        }
        case 3: {
            [cmdController sendCmd_stopPlay];
            break;
        }
        default:
            break;
    }
}



@end
