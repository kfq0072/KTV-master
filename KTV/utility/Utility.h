//
//  Utility.h
//  ZZKTV
//
//  Created by stevenhu on 15-3-22.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
@class BBBadgeBarButtonItem;
//
#define SCREENSIZE  [UIScreen mainScreen].bounds.size

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


/*
 *  MainViewController

 */
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define HEADVIEW_WH (iPhone5?140:IS_IPHONE_4_OR_LESS?100:160)
#define HEADVIEW_TOPMARGIN (iPhone5?20:IS_IPHONE_4_OR_LESS?20:20)

#define SEARCH_H 44
#define SEARCHMARGIN_LRT (iPhone5?13:IS_IPHONE_4_OR_LESS?12:16)
#define SEARCHMARGIN_TOPMARGIN (iPhone5?HEADVIEW_WH+HEADVIEW_TOPMARGIN+SEARCHMARGIN_LRT:IS_IPHONE_4_OR_LESS?HEADVIEW_WH+HEADVIEW_TOPMARGIN+SEARCHMARGIN_LRT:HEADVIEW_WH+HEADVIEW_TOPMARGIN+SEARCHMARGIN_LRT*2)
#define TOPBGView_TOPMARGIN (SEARCHMARGIN_TOPMARGIN+SEARCHMARGIN_LRT+SEARCH_H)
#define TOPBGView_H (iPhone5?80:IS_IPHONE_4_OR_LESS?80:100)

#define BOTTOMBGView_TOPMARGIN (TOPBGView_TOPMARGIN+SEARCHMARGIN_LRT+TOPBGView_H)
#define BUTTON_WH (iPhone5?60:IS_IPHONE_4_OR_LESS?60:70)

/*
 *  MainViewController
 
 */
#define NOTIFICATION_YIDIAN_INCREASION @"NOTIFICATION_YIDIAN_INCREASION"
//
//
//@protocol yidianDelegate <NSObject>
//@optional
//-(void)yidian_Increase;
//-(void)yidian_Uncrease;
//
//@end

typedef enum {
    unkownPhone,
    isiPhone4s,
    isiphone5s,
    isiphone6,
    isiphone6p
}iphoneModel;

typedef void(^OperationResult)(NSError* error);
typedef void(^Completed)(BOOL Completed);
@interface Utility : NSObject
@property (nonatomic,readonly)FMDatabase *db;
@property (readonly, strong, nonatomic) NSOperationQueue *queue;
@property (readonly ,strong, nonatomic) NSManagedObjectContext *bgObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainObjectContext;
+ (instancetype)instanceShare;
+ (float)user_iosVersion;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (BOOL)isIncludeChineseInString:(NSString*)str;
+ (NSString*)shouZiFu:(NSString*)string;
+ (iphoneModel)whatIphoneDevice;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
//core data
- (void)addIntoDataSource:(Completed)completed;
- (void) setupEnvModel:(NSString *)model DbFile:(NSString*)filename;
- (NSManagedObjectContext*)createPrivateObjectContext;
- (NSError*)save:(OperationResult)handler;
- (void)setYidianBadgeWidth:(BBBadgeBarButtonItem*)item;
- (void)closeDB;
- (NSString*)encodeBase64:(NSString*)decodestr;
- (NSString*)decodeBase64:(NSString*)encodeStr;
@end
