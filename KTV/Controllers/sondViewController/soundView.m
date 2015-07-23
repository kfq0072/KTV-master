//
//  soundView.m
//  KTV
//
//  Created by stevenhu on 15/5/2.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "soundView.h"
#import "Utility.h"
#import "UIImage+Resize.h"
#define WINDOW  [UIApplication sharedApplication].keyWindow
#define BOKONG_SPACE 15
#define LABEL_HEIGHT 20
#import "CommandControler.h"
@interface soundView () {

    //three chuckview
    CGSize totoalSize;
    
    
    UIView *topChunckView;
    UIView *centerChunckView;
    UIView *bottomChunckbView;
    
    
    UIButton *switchBtn;
    UIButton *sendBtn;
    //controller
    CommandControler *cmdController;
    //top
    UIStepper *micSteper;
    UIStepper *musicSteper;

//    jiajian
    UIImageView *playStopImageV;
    UIButton *playBtn;
    UIButton *stopbtn;
    iphoneModel myModel;
    
    
    //center
    UIButton *heCaiBtn;
    UIButton *daoCaiBtn;
    UIButton *mingLingBtn;
    UIButton *rouHeBtn;
    UIButton *dongGanBtn;
    UIButton *kaiGuangBtn;
    UIButton *serviceBtn;
    
    //bottm
//    UITextField *sendInput;
    
}

@end

@implementation soundView


- (id)initWithFrame:(CGRect)frame   {
    if (self=[super initWithFrame:frame]) {
        myModel=[Utility whatIphoneDevice];
        self.backgroundColor=[UIColor groupTableViewBackgroundColor];
        totoalSize=self.bounds.size;
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"songsList_bg"]];
        [self createChunckViews];
        cmdController=[[CommandControler alloc]init];
    }
    return self;
}

//create chunck
- (void)createChunckViews {
    CGFloat centerY = 0.0;
    CGFloat centerYChunk = 0.0;
    CGFloat bottomX = 0.0;
    if (IS_IPHONE_4_OR_LESS) {
        centerY = 30.0;
        centerYChunk = 25.0;
        bottomX = 27.0;
    }
    //topChunkView
    topChunckView=[[UIView alloc]initWithFrame:CGRectMake(0,0,totoalSize.width,120)];
    [self addSubview:topChunckView];
    
    //centerchunck
    centerChunckView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(topChunckView.frame)-centerY,totoalSize.width, totoalSize.height/3)];
//        centerChunckView.backgroundColor=[UIColor redColor];
    [self addSubview:centerChunckView];

    //bottomChunkView
    bottomChunckbView=[[UIView alloc]initWithFrame:CGRectMake(0+bottomX,CGRectGetMaxY(centerChunckView.frame)+centerY-centerYChunk+15, totoalSize.width,centerChunckView.bounds.size.height-44)];
    
//    bottomChunckbView.backgroundColor=[UIColor blueColor];
    [self addSubview:bottomChunckbView];
    
    [self createViewsForAllChuncks];
    
}

//create up

- (void)createViewsForAllChuncks {

    micSteper=[[UIStepper alloc]init];
    musicSteper=[[UIStepper alloc]init];
    playStopImageV=[[UIImageView alloc]init];
    playBtn=[[UIButton alloc]init];
    stopbtn=[[UIButton alloc]init];
    CGSize topChuckSize=centerChunckView.bounds.size;
    CGSize centerChuckSize=bottomChunckbView.bounds.size;
    
    heCaiBtn=[[UIButton alloc]init];
    daoCaiBtn=[[UIButton alloc]init];
    mingLingBtn=[[UIButton alloc]init];
    rouHeBtn=[[UIButton alloc]init];
    dongGanBtn=[[UIButton alloc]init];
    kaiGuangBtn=[[UIButton alloc]init];
    serviceBtn=[[UIButton alloc]init];
    

    //====topChunck SubViews
    float oneWidth=(WINDOW.bounds.size.width-BOKONG_SPACE)/4-BOKONG_SPACE*1.5;
    //buttons
    NSArray *strArray=@[@"原/伴",@"切歌",@"播停", @"重唱"];
    NSMutableArray *btnArray=[[NSMutableArray alloc]init];
    for (int i=0;i<4;i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(BOKONG_SPACE*(i+1)+i*oneWidth+15,BOKONG_SPACE+10,oneWidth,oneWidth);
        button.tag=i;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bokong%d",i]] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(bokongBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [topChunckView addSubview:button];
        
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame),button.bounds.size.width,(LABEL_HEIGHT))];
        lable.text=strArray[i];
        lable.font=[UIFont systemFontOfSize:14];
        lable.textAlignment=NSTextAlignmentCenter;
        lable.textColor=[UIColor whiteColor];
        [topChunckView addSubview:lable];
        [btnArray addObject:lable];
        
    }
    
    micSteper.frame=CGRectMake((topChuckSize.width/3-94)/2, topChuckSize.height/2-20,0, 0);
    micSteper.tintColor=[UIColor whiteColor];
    
    
    //将图层的边框设置为圆脚
    micSteper.layer.cornerRadius = 8;
    micSteper.layer.masksToBounds = YES;
    //给图层添加一个有色边
    micSteper.layer.borderWidth = 2;
    micSteper.layer.borderColor = [[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1] CGColor];
    [micSteper setMinimumValue:0];
    [micSteper setMaximumValue:100];
    [micSteper setWraps:YES];
     micSteper.continuous=YES;
    micSteper.stepValue=5;
    micSteper.autorepeat = YES;
    
      //imageview
    float ImageViewmaxWidth=MIN(topChuckSize.height, topChuckSize.width/3);
    
    playStopImageV.frame=CGRectMake(topChuckSize.width/3+(topChuckSize.width/3-(ImageViewmaxWidth-15))/2, topChuckSize.height/2-ImageViewmaxWidth/2, ImageViewmaxWidth-15,ImageViewmaxWidth-15);
    playStopImageV.image=[UIImage imageNamed:@"stopstart"];
    
    //静音／正常
    playBtn.frame = CGRectMake(topChuckSize.width/3+(topChuckSize.width/3-(ImageViewmaxWidth-15))/2, topChuckSize.height/2-ImageViewmaxWidth/2, CGRectGetWidth(playStopImageV.frame)/2-5,CGRectGetHeight(playStopImageV.frame));
    [playBtn addTarget:self action:@selector(mute_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    stopbtn.frame = CGRectMake(CGRectGetMaxX(playBtn.frame)+15, topChuckSize.height/2-ImageViewmaxWidth/2, CGRectGetWidth(playStopImageV.frame)/2-10,CGRectGetHeight(playStopImageV.frame));
    [stopbtn addTarget:self action:@selector(unmute_clicked:) forControlEvents:UIControlEventTouchUpInside];
   
    
    
    musicSteper.frame=CGRectMake(topChuckSize.width/3*2+(topChuckSize.width/3-94)/2, topChuckSize.height/2-20, 0,0);
    musicSteper.tintColor=[UIColor whiteColor];
    
    //将图层的边框设置为圆脚
    musicSteper.layer.cornerRadius = 8;
    musicSteper.layer.masksToBounds = YES;
    //给图层添加一个有色边
    musicSteper.layer.borderWidth = 2;
    musicSteper.layer.borderColor = [[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1] CGColor];
    [musicSteper setMinimumValue:0];
    [musicSteper setMaximumValue:100];
    [musicSteper setWraps:YES];
    musicSteper.continuous=YES;
    musicSteper.stepValue=5;
    musicSteper.autorepeat = YES;
    
    UILabel *micLabel=[[UILabel alloc]initWithFrame:CGRectMake(micSteper.frame.origin.x, CGRectGetMaxY(playStopImageV.frame), micSteper.bounds.size.width, micSteper.bounds.size.height)];
    micLabel.text=@"麦克风";
    micLabel.textAlignment=NSTextAlignmentCenter;
    micLabel.textColor=[UIColor groupTableViewBackgroundColor];
    
    UILabel *muteLabel=[[UILabel alloc]initWithFrame:CGRectMake(playStopImageV.frame.origin.x, CGRectGetMaxY(playStopImageV.frame), playStopImageV.bounds.size.width, micSteper.bounds.size.height)];
    muteLabel.text=@"静音/正常";
    muteLabel.textAlignment=NSTextAlignmentCenter;
    muteLabel.textColor=[UIColor groupTableViewBackgroundColor];
    
    UILabel *musicLabel=[[UILabel alloc]initWithFrame:CGRectMake(musicSteper.frame.origin.x, CGRectGetMaxY(playStopImageV.frame), musicSteper.bounds.size.width, musicSteper.bounds.size.height)];
    musicLabel.text=@"音乐";
    musicLabel.textAlignment=NSTextAlignmentCenter;
    musicLabel.textColor=[UIColor groupTableViewBackgroundColor];
    
    [centerChunckView addSubview:micLabel];
    [centerChunckView addSubview:muteLabel];
    [centerChunckView addSubview:musicLabel];
    
    //center
    float btnMaxWidth=MIN(centerChuckSize.height/2, centerChuckSize.width/4-15);
    NSLog(@"%f",btnMaxWidth);
    heCaiBtn.frame=CGRectMake(16, 10, btnMaxWidth, btnMaxWidth);
    [heCaiBtn setImage:[UIImage imageNamed:@"hecai"] forState:UIControlStateNormal];
    [bottomChunckbView addSubview:heCaiBtn];
    
    daoCaiBtn.frame=CGRectMake(CGRectGetMaxX(heCaiBtn.frame)+10, CGRectGetMinY(heCaiBtn.frame), btnMaxWidth, btnMaxWidth);
    [daoCaiBtn setImage:[UIImage imageNamed:@"daocai"] forState:UIControlStateNormal];
    [bottomChunckbView addSubview:daoCaiBtn];
    
    rouHeBtn.frame=CGRectMake(CGRectGetMaxX(daoCaiBtn.frame)+10, CGRectGetMinY(heCaiBtn.frame), btnMaxWidth, btnMaxWidth);
    [rouHeBtn setImage:[UIImage imageNamed:@"rouhe"] forState:UIControlStateNormal];
    [bottomChunckbView addSubview:rouHeBtn];
    
    mingLingBtn.frame=CGRectMake(CGRectGetMaxX(rouHeBtn.frame)+10, CGRectGetMinY(heCaiBtn.frame), btnMaxWidth, btnMaxWidth);
    [mingLingBtn setImage:[UIImage imageNamed:@"mingliang"] forState:UIControlStateNormal];
    [bottomChunckbView addSubview:mingLingBtn];
    
    dongGanBtn.frame=CGRectMake(CGRectGetMinX(heCaiBtn.frame), CGRectGetMaxY(heCaiBtn.frame)+10, btnMaxWidth, btnMaxWidth);
    [dongGanBtn setImage:[UIImage imageNamed:@"donggang"] forState:UIControlStateNormal];
    [bottomChunckbView addSubview:dongGanBtn];
    
    kaiGuangBtn.frame=CGRectMake(CGRectGetMaxX(dongGanBtn.frame)+10, CGRectGetMinY(dongGanBtn.frame), btnMaxWidth, btnMaxWidth);
    [kaiGuangBtn setImage:[UIImage imageNamed:@"gaiguang"] forState:UIControlStateNormal];
    [bottomChunckbView addSubview:kaiGuangBtn];
    
    serviceBtn.frame=CGRectMake(CGRectGetMaxX(kaiGuangBtn.frame)+40, CGRectGetMinY(dongGanBtn.frame), btnMaxWidth*1.5, btnMaxWidth);
    [serviceBtn setImage:[UIImage imageNamed:@"fuwu"] forState:UIControlStateNormal];
    [bottomChunckbView addSubview:serviceBtn];
    

    [centerChunckView addSubview:micSteper];
    [centerChunckView addSubview:musicSteper];

    [centerChunckView addSubview:playStopImageV];
    [centerChunckView addSubview:playBtn];
    [centerChunckView addSubview:stopbtn];
    [bottomChunckbView addSubview:heCaiBtn];
    [bottomChunckbView addSubview:daoCaiBtn];
    [bottomChunckbView addSubview:rouHeBtn];
    [bottomChunckbView addSubview:mingLingBtn];
    [bottomChunckbView addSubview:dongGanBtn];
    [bottomChunckbView addSubview:kaiGuangBtn];
    [bottomChunckbView addSubview:serviceBtn];
    
    //add event
    [micSteper addTarget:self action:@selector(mic_clicked:) forControlEvents:UIControlEventValueChanged];
     [musicSteper addTarget:self action:@selector(mic_clicked:) forControlEvents:UIControlEventValueChanged];
    
    [heCaiBtn addTarget:self action:@selector(hecai_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [daoCaiBtn addTarget:self action:@selector(daocai_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [rouHeBtn addTarget:self action:@selector(rouhe_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [mingLingBtn addTarget:self action:@selector(mingliang_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [dongGanBtn addTarget:self action:@selector(donggang_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [kaiGuangBtn addTarget:self action:@selector(kaiguang_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [serviceBtn addTarget:self action:@selector(fuwu_clicked:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - Events

- (void)mic_clicked:(id)sender {
//    调音(1麦克风 2 音乐 3 功放 4音调 ) & value
    [cmdController sendCmd_yingDiaoAdjustToObject:1 value:20];
    NSLog(@"%s",__FUNCTION__);

}

- (void)music_clicked:(id)sender {
    [cmdController sendCmd_yingDiaoAdjustToObject:2 value:20];
    NSLog(@"%s",__FUNCTION__);

}
//(1静音 2=放音)
- (void)mute_clicked:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    [cmdController sendCmd_soundStopPlay];

}

- (void)unmute_clicked:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    [cmdController sendCmd_soundStopPlay];

}

- (void)hecai_clicked:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    //气氛(1,喝彩 2，倒彩 3，明亮 4，柔和 5 动感 6 开关)
    [cmdController sendCmd_qiFen:1];

}

- (void)daocai_clicked:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    [cmdController sendCmd_qiFen:2];


}

- (void)rouhe_clicked:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    [cmdController sendCmd_qiFen:4];


}

- (void)mingliang_clicked:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    [cmdController sendCmd_qiFen:3];


}

- (void)donggang_clicked:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    [cmdController sendCmd_qiFen:5];


}

- (void)kaiguang_clicked:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    [cmdController sendCmd_qiFen:6];


}

- (void)fuwu_clicked:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    [cmdController sendCmd_FUWU];


}

- (void)bokongBtn_clicked:(id)sender {
    UIButton *btn=(UIButton*)sender;
    switch (btn.tag) {
        case 0: {
            NSLog(@"点击原音");
            [cmdController sendCmd_yuanChang_pangChang];
            break;
        }
        case 1: {
            NSLog(@"点击切歌");
            [cmdController sendCmd_switchSong];
            break;
        }
        case 2: {
            NSLog(@"点击播放");
            [cmdController sendCmd_stopPlay];
            break;
        }
        case 3: {
            [cmdController sendCmd_rePlay];
            NSLog(@"点击重播播放");

            break;
        }
        default:
            break;
    }
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)exitShenKong:(id)sender {
    if ([self.delegate respondsToSelector:@selector(exitShengKongView)]) {
        [self.delegate exitShengKongView];
    }
}



@end
