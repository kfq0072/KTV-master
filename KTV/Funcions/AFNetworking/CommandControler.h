//
//  CommandControler.h
//  KTV
//
//  Created by stevenhu on 15/6/3.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CommandControler : NSObject

//- (void)startDownLoadTxtFiles;
- (void)downLoadPictureWithSinger:(NSString*)singer;

- (void)clearCacheData;

- (void)sendCmd_FUWU;//服务
//气氛(1,喝彩 2，倒彩 3，明亮 4，柔和 5 动感 6 开关)
- (void)sendCmd_qiFen:(int)value;
//祝福文字
- (void)sendCmd_zhuFuWithWord:(NSString*)value;
//祝福（图片）(最大512*512)数据流
- (void)sendCmd_zhuFuWithPicture:(UIImage*)image;
//静音/放音
- (void)sendCmd_soundStopPlay;
//音量(-+)
- (void)sendCmd_soundAdjust:(BOOL)increase;
//调音(1麦克风 2 音乐 3 功放 4音调 ) & value
- (void)sendCmd_yingDiaoAdjustToObject:(int)who value:(int)value;
//切歌
- (void)sendCmd_switchSong;
//重唱
- (void)sendCmd_rePlay;
//暂停/播放
- (void)sendCmd_stopPlay;
//原唱/伴唱
- (void)sendCmd_yuanChang_pangChang;
//获取已点歌单
- (NSArray*)sendCmd_get_yiDianList;
//删除已点
- (void)sendCmd_remove_yidian:(NSString*)value;
//已点打乱
- (void)sendCmd_yiDianDaluang;
//已点移到顶
- (void)sendCmd_moveSongToTop:(NSString*)order;
//已点还原
- (void)sendCmd_yiDianResume;
//点歌
- (void)sendCmd_Diange:(NSString*)number;
//点歌(顶)
- (void)sendCmd_DiangeToTop:(NSString*)number;
//推送视频(音频)
- (void)sendCmd_pushVideoAudio:(NSData*)data;
//推送图片
- (void)sendCmd_pushPicture:(UIImage*)image;
// 重开
- (void)sendCmd_restartDevice;
// 关机
- (void)sendCmd_shutdownDevice;

@end
