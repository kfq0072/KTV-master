//
//  Song.m
//  KTV
//
//  Created by stevenhu on 15/4/24.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//
#import "Song.h"

@implementation Song

-(void)setAddtime:(NSString *)addtime {
    _addtime=[[Utility instanceShare] decodeBase64:addtime];
}

- (void)setBihua:(NSString *)bihua {
    _bihua=[[Utility instanceShare] decodeBase64:bihua];
}

- (void)setChannel:(NSString *)channel {
    _channel=[[Utility instanceShare] decodeBase64:channel];
}

- (void)setLanguage:(NSString *)language {
    _language=[[Utility instanceShare] decodeBase64:language];
}

-(void)setMovie:(NSString *)movie {
    _movie=[[Utility instanceShare] decodeBase64:movie];
}

- (void)setNewsong:(NSString *)newsong {
    _newsong=[[Utility instanceShare] decodeBase64:newsong];
}

- (void)setNumber:(NSString *)number {
    _number=[[Utility instanceShare] decodeBase64:number];
}

- (void)setPathid:(NSString *)pathid {
    _pathid=[[Utility instanceShare] decodeBase64:pathid];

}

- (void)setSex:(NSString *)sex {
    _sex=[[Utility instanceShare] decodeBase64:sex];

}

- (void)setSinger:(NSString *)singer {
    _singer=[[Utility instanceShare] decodeBase64:singer];

}

- (void)setSinger1:(NSString *)singer1 {
    _singer1=[[Utility instanceShare] decodeBase64:singer1];

}

- (void)setSongname:(NSString *)songname {
    _songname=[[Utility instanceShare] decodeBase64:songname];

}

- (void)setSongpiy:(NSString *)songpiy {
    _songpiy=[[Utility instanceShare] decodeBase64:songpiy];
 
}


- (void)setSpath:(NSString *)spath {
    _spath=[[Utility instanceShare] decodeBase64:spath];

}

- (void)setStype:(NSString *)stype {
    _stype=[[Utility instanceShare] decodeBase64:stype];

}

- (void)setVolume:(NSString *)volume {
    _volume=[[Utility instanceShare] decodeBase64:volume];

}

- (void)setWord:(NSString *)word {
    _word=[[Utility instanceShare] decodeBase64:word];
}
@end
