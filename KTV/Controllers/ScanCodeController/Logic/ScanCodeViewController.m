//
//  ScanCodeViewController.m
//  zzKTV
//
//  Created by mCloud on 15/3/21.
//  Copyright (c) 2015年 StevenHu. All rights reserved.
//

#import "ScanCodeViewController.h"
#import "RecognitionCodeLogic.h"
@interface ScanCodeViewController ()<RecognitionCodeLogicDelegate>
{
    NSTimer *_scanCodeTimer;
    RecognitionCodeLogic *_recognitionLogic;
}

@property(nonatomic,weak) IBOutlet UIView *cameraPreView;
@property(nonatomic,retain) IBOutlet UIImageView *scanCodeLine;
@property(nonatomic,retain)IBOutlet UIImageView *imageViewBoundBg;
//@property(nonatomic,retain)IBOutlet UILabel *labIntroudction;
@property(nonatomic,weak)IBOutlet UIButton * cancelButton;
@end

@implementation ScanCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"绑定";
//     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image=[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"geshou_area_bg.png" ofType:nil]
]stretchableImageWithLeftCapWidth:60 topCapHeight:60];
    self.view.backgroundColor=[UIColor colorWithPatternImage:image];
//    _labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    
    _scanCodeTimer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(scanCodeLineAnimationUpAndDown) userInfo:nil repeats:YES];
    _recognitionLogic=[[RecognitionCodeLogic alloc]init];
    
//     Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _recognitionLogic=nil;
    [self stopScanCodeTimer:_scanCodeTimer];
}


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.toolbar.hidden=YES;
    BOOL isCameraAvailable = [RecognitionCodeLogic isCameraAvailable];
    if (!isCameraAvailable) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"相机不可用，请在设置-->允许应用访问相机" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
        [_recognitionLogic startRunningRecognition];
        _recognitionLogic.delegate = self;
        [_recognitionLogic embedPreviewInView:self.cameraPreView];
    }
}

#pragma mark - Private Methods

-(void)scanCodeLineAnimationUpAndDown
{
    static NSInteger num = 0;
    static BOOL isUpOrDown = NO;
    if (isUpOrDown == NO) {
        num++;
        _scanCodeLine.frame = CGRectMake(0, 2*num, _scanCodeLine.frame.size.width, 2);
        NSLog(@"1:%f--> _%f",_scanCodeLine.frame.origin.y, _cameraPreView.bounds.size.height);
        if (_scanCodeLine.frame.origin.y >= _cameraPreView.bounds.size.height) {
            isUpOrDown = YES;
        }
    }
    else {
        num--;
        if (num == 0) {
            isUpOrDown = NO;
        } else {
        _scanCodeLine.frame = CGRectMake(0,2*num, _scanCodeLine.frame.size.width, 2);
//        NSLog(@"2:%@",NSStringFromCGRect(_scanCodeLine.frame));
        }

    }
    
}

- (void)stopScanCodeTimer:(NSTimer *)timer{
    if (nil != timer) {
        NSLog(@"%s: stopTimer", __func__);
        [timer invalidate];
        timer = nil;
    }
}
- (void)cancelAction:(id)sender {
    if ( nil != self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if ( nil != self.navigationController ) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self stopScanCodeTimer:_scanCodeTimer];
}

#pragma mark - RecognitionCodeLogicDelegate

- (void)didFinishRecognitionWithString:(NSString *)string {
    [self cancelAction:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(didFinishedScanCode:withString:)] ) {
        [_delegate didFinishedScanCode:nil withString:string];
    }
}

#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self cancelAction:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
