//
//  AboutViewController.m
//  KTV
//
//  Created by stevenhu on 15/6/17.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"关于我们";
    _companyLogView.layer.masksToBounds =YES;
//    _companyLogView.layer.shadowColor=[UIColor yellowColor].CGColor;
//    _companyLogView.layer.shadowOffset=CGSizeMake(-1, -2);
//    _companyLogView.layer.shadowOpacity=3;
    _companyLogView.layer.cornerRadius=_companyLogView.bounds.size.width/2;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
