//
//  ZZImportData.h
//  KTV
//
//  Created by stevenhu on 15/4/18.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZImportData : NSObject

typedef void(^importDataResult)(BOOL isSuccess);

+ (instancetype)sharedInstance;

//core data
- (void)addIntoDataSource:(importDataResult)ZZblock;

@end
