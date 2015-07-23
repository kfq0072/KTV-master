//
//  PingHelper.m
//  KTV
//
//  Created by mCloud on 15/7/23.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "PingHelper.h"
#import <CFNetwork/CFNetwork.h>
#import <stdlib.h>
@implementation PingHelper
static PingHelper *shareInstance=nil;
+ (instancetype)instanceShare {
       static  dispatch_once_t onceToken;
       dispatch_once(&onceToken, ^{
           if (!shareInstance) {
            shareInstance=[[self alloc]init];
               
           }
       });
       return shareInstance;
   }

+ (BOOL)pingIP:(NSString*)ipAddress {
//    NSArray* paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* pt = [paths objectAtIndex:0];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        NSString* filePath = [NSString stringWithFormat:@"%@/%@.txt",pt,ipAddress];
//        
//        NSString* cmd = [NSString stringWithFormat:@"ping -c 1 %@ > '%@'",ipAddress,filePath];
//        system([cmd UTF8String]);
//        NSString * content = [[NSString  alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//        if ([content rangeOfString:@"time"].location != NSNotFound)
//        {
//            // fill[i] = YES;
//            
////            NSLog(@"The %d is found",i);
//        }
//        
//    });
    return YES;
}
@end