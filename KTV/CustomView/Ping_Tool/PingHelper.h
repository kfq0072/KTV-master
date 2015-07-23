//
//  PingHelper.h
//  KTV
//
//  Created by mCloud on 15/7/23.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PingHelper : NSObject
+ (instancetype)instanceShare;
+ (BOOL)pingIP:(NSString*)ipAddress;
@end
