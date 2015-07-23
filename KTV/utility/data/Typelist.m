//
//  Typelist.m
//  KTV
//
//  Created by stevenhu on 15/4/24.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "Typelist.h"

@implementation Typelist


- (void)setZtype:(NSString *)ztype {
    _ztype=[[Utility instanceShare] decodeBase64:ztype];
}

- (void)setZtypeid:(NSString *)ztypeid {
    _ztypeid=[[Utility instanceShare] decodeBase64:ztypeid];
}

- (void)setZtypename:(NSString *)ztypename {
    _ztypename=[[Utility instanceShare] decodeBase64:ztypename];
}


@end
