//
//  SingerTypeCell.m
//  KTV
//
//  Created by stevenhu on 15/4/21.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//
#define COMMANDURLHEADER_PIC @"http://192.168.43.1:8080/puze?cmd=0x02&filename="

#import "SingerAreaTypeCell.h"

@interface SingerAreaTypeCell () {
    NSOperationQueue *queue;
    UIActivityIndicatorView *indicator;
}

@end

@implementation SingerAreaTypeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)downLoadImage:(NSString *)imageName {
    self.headImageV.image=[UIImage imageNamed:@"kge_head"];
    NSFileManager *manager=[NSFileManager defaultManager];
    NSString* savePath_PicDir=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/downloadDir/Images"];
    if (![manager fileExistsAtPath:savePath_PicDir]) {
        [manager createDirectoryAtPath:savePath_PicDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString*  savePath_picFull = [[savePath_PicDir stringByAppendingPathComponent:imageName]stringByAppendingPathExtension:@"png"];
    if ([manager fileExistsAtPath:savePath_picFull]) {
        self.headImageV.image=[UIImage imageWithContentsOfFile:savePath_picFull];
        return;

    }
    
    if (!indicator) {
        indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame=CGRectMake(self.headImageV.bounds.size.width/2-15, self.headImageV.bounds.size.height/2-15, 30,30);
        [self.headImageV addSubview:indicator];

    }
    indicator.hidden=NO;
    [indicator startAnimating];
    if (imageName.length >0) {
        NSString *urlStr=[[COMMANDURLHEADER_PIC stringByAppendingString:imageName]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *downloadURL=[NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
        queue=[[NSOperationQueue alloc]init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if ([data length] > 0 && connectionError == nil) {
                [data writeToFile:savePath_picFull atomically:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.headImageV.image=[UIImage imageWithContentsOfFile:savePath_picFull];
                });
            }else if ([data length] == 0 && connectionError == nil){
                NSLog(@"Nothing was downloaded.");
            }else if (connectionError != nil){
                NSLog(@"Error happened = %@",connectionError);
            }
            [indicator stopAnimating];
            indicator.hidden=YES;
        }];
    }
}
@end
