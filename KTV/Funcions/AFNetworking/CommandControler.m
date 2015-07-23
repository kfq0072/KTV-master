//
//  CommandControler.m
//  KTV
//
//  Created by stevenhu on 15/6/3.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "CommandControler.h"
#define COMMANDURLHEADER @"http://192.168.43.1:8080/puze/?cmd="

#define COMMANDURLHEADER_PIC @"http://192.168.43.1:8080/puze?cmd=0x02&filename="

#define DOCUMENTPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
@interface CommandControler()<NSURLConnectionDataDelegate> {
    NSOperationQueue *queue;
    int yingLiang;
    NSMutableData *_data;//响应数据
    long long _totalLength;
    NSURLConnection *connection;
    NSUserDefaults *accountDefaults;
}

@end
@implementation CommandControler


- (instancetype)init {
    if (self=[super init]) {
        queue=[[NSOperationQueue alloc]init];
        accountDefaults=[NSUserDefaults standardUserDefaults];
    }
    return self;
}


- (void)downLoadPictureWithSinger:(NSString*)singer {
    NSString *urlStr=[[COMMANDURLHEADER_PIC stringByAppendingString:singer]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *downloadURL=[NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    connection=[[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    [connection  start];

}

- (void)clearCacheData {
    NSFileManager *manager=[NSFileManager defaultManager];
    NSString *removeDir=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/downloadDir"];
    [manager removeItemAtPath:removeDir error:nil];
}

#pragma mark - 连接代理方法
#pragma mark 开始响应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"receive response.");
    _data=[[NSMutableData alloc]init];
    //    _progressView.progress=0;
    //通过响应头中的Content-Length取得整个响应的总长度
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
    _totalLength = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
    
}

#pragma mark 接收响应数据（根据响应内容的大小此方法会被重复调用）
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"receive data.");
    //连续接收数据
    [_data appendData:data];
    //更新进度
    //    [self updateProgress];
}

#pragma mark 数据接收完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"loading finish.");
    //数据接收完保存文件(注意苹果官方要求：下载数据只能保存在缓存目录)
//    NSString *savePath_picFull = [savePath_PicDir stringByAppendingPathComponent:@"1.jpg"];
//    [_data writeToFile:savePath_picFull atomically:YES];
//    NSLog(@"path:%@",savePath_picFull);
}

#pragma mark 请求失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //如果连接超时或者连接地址错误可能就会报错
    NSLog(@"connection error,error detail is:%@",error.localizedDescription);
}


- (NSURLSession *)backgroundSession {
    //    static NSURLSession *session = nil;
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //
    //        //这个sessionConfiguration 很重要， com.zyprosoft.xxx  这里，这个com.company.这个一定要和 bundle identifier 里面的一致，否则ApplicationDelegate 不会调用handleEventsForBackgroundURLSession代理方法
    //        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.zyprosoft.backgroundsession"];
    //        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    //    });
    //    return session;
    return nil;
}

//服务
- (void)sendCmd_FUWU {
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xb1"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//气氛(1,喝彩 2，倒彩 3，明亮 4，柔和 5 动感 6 开关)
- (void)sendCmd_qiFen:(int)value {
    if (value<=0 || value>6)  return;
    //  http://192.168.43.1:8080/puze?cmd=0xb2&ID= (1,喝彩 2，倒彩 3，明亮 4，柔和 5 动感 6 开关)
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xb2&ID=%d",value]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//祝福文字
- (void)sendCmd_zhuFuWithWord:(NSString*)value {
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xb3&label=%@",value]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//祝福（图片）(最大512*512)数据流
- (void)sendCmd_zhuFuWithPicture:(UIImage*)image {
    if (image.size.width>512 || image.size.height>512) return;
    //    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xb4=%@",data]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xb4"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPBody=UIImagePNGRepresentation(image);
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//静音/放音
- (void)sendCmd_soundStopPlay {
    //    http://192.168.43.1:8080/puze?cmd=0xb6&ID=(1静音 2=放音)
    int value=0;
    if ([accountDefaults boolForKey:@"UNMUTE"]) {
        [accountDefaults setBool:NO forKey:@"UNMUTE"];
        value=1;
    } else {
        [accountDefaults setBool:YES forKey:@"UNMUTE"];
        value=2;
    }
    [accountDefaults synchronize];
    
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xb6&ID=%d",value]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//音量(-+) ::TODO
- (void)sendCmd_soundAdjust:(BOOL)increase {
    //http://192.168.43.1:8080/puze?cmd=0xb7&vol=音量
    
    int value=[accountDefaults integerForKey:@"soundAdjust"];
    if (value < 0 || value >15) {
        return;
    } else {
        
    }
    if (increase) {
        value=value >=15?0:++value;
    } else {
        value=value <=0?15:--value;
    }
    
    [accountDefaults setInteger:value forKey:@"soundAdjust"];
    [accountDefaults synchronize];
    
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xb7&vol=%d",value]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//调音(1麦克风 2 音乐 3 功放 4音调 ) & value
- (void)sendCmd_yingDiaoAdjustToObject:(int)who value:(int)value {
    //    http://192.168.43.1:8080/puze?cmd=0xb5&ID=(1麦克风 2 音乐 3 功放 4音调 ) &vol=音量
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xb5&ID=%d&vol=%d",who,value]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//切歌
- (void)sendCmd_switchSong {
    //http://192.168.43.1:8080/puze?cmd=0xb8
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xb8"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//重唱
- (void)sendCmd_rePlay {
    //    http://192.168.43.1:8080/puze?cmd=0xb9
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xb9"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//暂停/播放
- (void)sendCmd_stopPlay {
    int value=0;
    if ([accountDefaults boolForKey:@"PLAYING"]) {
        [accountDefaults setBool:NO forKey:@"PLAYING"];
        value=1;
    } else {
        [accountDefaults setBool:YES forKey:@"PLAYING"];
        value=2;
    }
    [accountDefaults synchronize];
    //    http://192.168.43.1:8080/puze?cmd=0xba&ID=(1暂停 2 播放)
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xba&ID=%d",value]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//原唱/伴唱
- (void)sendCmd_yuanChang_pangChang {
    //http://192.168.43.1:8080/puze?cmd=0xbb&ID=(1原唱2伴唱)
    int value=0;
    if ([accountDefaults boolForKey:@"YUANCHANG"]) {
        [accountDefaults setBool:NO forKey:@"YUANCHANG"];
        value=2;
    } else {
        [accountDefaults setBool:YES forKey:@"YUANCHANG"];
        value=1;
    }
    [accountDefaults synchronize];

    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xbb&ID=%d",value]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//获取已点歌单
- (NSArray*)sendCmd_get_yiDianList{
    
    //http://192.168.43.1:8080/puze?cmd=0xbc
    //    返回（编号
    //    编号
    //    .
    //    .
    //    .
    //    )
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xbc"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *strContent=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableArray *arr=[[strContent componentsSeparatedByString:@"\r\n"] mutableCopy];
    [arr removeLastObject];
//    NSLog(@"%@",arr);
    return arr;
}
//删除已点
- (void)sendCmd_remove_yidian:(NSString*)value {
    //    http://192.168.43.1:8080/puze?cmd=0xbd&orderid=序号
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xbd&orderid=%@",value]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//已点打乱
- (void)sendCmd_yiDianDaluang {
    //    http://192.168.43.1:8080/puze?cmd=0xbf
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xbf"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//已点移到顶
- (void)sendCmd_moveSongToTop:(NSString*)order{
    //   http://192.168.43.1:8080/puze?cmd=0xbe&orderid=序号
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xbe&orderid=%@",order]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//已点还原
- (void)sendCmd_yiDianResume {
    //    http://192.168.43.1:8080/puze?cmd=0xc0
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xc0"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//点歌
- (void)sendCmd_Diange:(NSString*)number {
    //    http://192.168.43.1:8080/puze?cmd=0xc1&number=编号
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xc1&number=%@",number]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//点歌(顶)
- (void)sendCmd_DiangeToTop:(NSString*)number {
    //http://192.168.43.1:8080/puze?cmd=0xc2&number=编号
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xc2&number=%@",number]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//推送视频(音频)
- (void)sendCmd_pushVideoAudio:(NSData*)data {
    //http://192.168.43.1:8080/puze?cmd=0xe1（数据流）
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xe1"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPBody=data;
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
//推送图片
- (void)sendCmd_pushPicture:(UIImage*)image {
    //http://192.168.43.1:8080/puze?cmd=0xe2    (数据流）
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xe2"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPBody=UIImagePNGRepresentation(image);
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
// 重开
- (void)sendCmd_restartDevice {
    //    http://192.168.43.1:8080/puze?cmd=0xd1
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xd1"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}
// 关机
- (void)sendCmd_shutdownDevice {
    //    http://192.168.43.1:8080/puze?cmd=0xd2
    NSString *urlStr=[[COMMANDURLHEADER stringByAppendingFormat:@"0xd2"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    }];
}

@end
