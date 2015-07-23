//
//  ClearCache.m
//  ZZKTV
//
//  Created by stevenhu on 15-3-21.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import "ClearCache.h"

@implementation ClearCache


+ (float)fileSizeAtPath:(NSString*)path {
    NSFileManager * fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024/1024;
    }
    return 0;
}

+ (float)folderSizeAtPath:(NSString*)path {
     NSFileManager * fileManager=[NSFileManager defaultManager];
    float folderSize;
     if ([fileManager fileExistsAtPath:path]) {
         NSArray *childFiles=[fileManager subpathsAtPath:path];
         for (NSString *fileName in childFiles) {
             NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
             folderSize+=[ClearCache fileSizeAtPath:absolutePath];
         }
        // NSArray *childFiles=[fileManager subpathsOfDirectoryAtPath:path error:nil];
     }
    return folderSize;
}
+ (void)clearCache:(NSString*)path {
    NSFileManager * fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}
@end
