//
//  Order.m
//  KTV
//
//  Created by stevenhu on 15/7/4.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "Order.h"
@implementation Order

- (void)setNumber:(NSString *)number {
    _number=[Utility decodeBase64:number];

}

- (void)setRcid:(NSString *)rcid {
    _rcid=[Utility decodeBase64:rcid];

}

-  (void)setOrdername:(NSString *)ordername {
    _ordername=[Utility decodeBase64:ordername];
}

@end
