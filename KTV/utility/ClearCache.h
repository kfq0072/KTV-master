//
//  ClearCache.h
//  ZZKTV
//
//  Created by stevenhu on 15-3-21.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClearCache : NSObject
+ (float)fileSizeAtPath:(NSString*)path;

+ (float)folderSizeAtPath:(NSString*)path;

+ (void)clearCache:(NSString*)path;
@end
