//
//  Order.h
//  KTV
//
//  Created by stevenhu on 15/7/4.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Utility.h"

@interface Order : NSObject

@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * rcid;
@property (nonatomic, retain) NSString * ordername;

@end
