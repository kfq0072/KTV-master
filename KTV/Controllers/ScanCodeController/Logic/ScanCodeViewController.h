//
//  ScanCodeViewController.h
//  zzKTV
//
//  Created by mCloud on 15/3/21.
//  Copyright (c) 2015年 StevenHu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScanCodeDelegate <NSObject>
@required
- (void)didFinishedScanCode:(NSError*)error withString:(NSString*)string;
@end


@interface ScanCodeViewController : UIViewController
@property (nonatomic,weak) id<ScanCodeDelegate> delegate;
@end
