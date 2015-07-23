//
//  Singer.m
//  KTV
//
//  Created by stevenhu on 15/4/24.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "Singer.h"

@implementation Singer
- (void)setArea:(NSString *)area {
    _area=[[Utility instanceShare] decodeBase64:area];
}

- (void)setPingyin:(NSString *)pingyin {
    _pingyin=[[Utility instanceShare] decodeBase64:pingyin];
}

- (void)setS_bi_hua:(NSString *)s_bi_hua {
    _s_bi_hua=[[Utility instanceShare] decodeBase64:s_bi_hua];
}

- (void)setSinger:(NSString *)singer {
    _singer=[[Utility instanceShare] decodeBase64:singer];
}
@end
