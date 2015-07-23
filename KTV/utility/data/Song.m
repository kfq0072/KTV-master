//
//  Song.m
//  KTV
//
//  Created by stevenhu on 15/4/24.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//
#import "Song.h"
#import "CommandControler.h"
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



- (void)insertSongToCollectionTable {
    NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO CollectionTable (number,songname,singer,singer1,songpiy,word,language,volume,channel,sex,stype,newsong,movie,pathid,bihua,addtime,spath)VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",_addtime,_bihua,_channel,_language,_movie,_newsong,_number,_pathid,_sex,_singer,_singer1,_songname,_songpiy,_spath,_stype,_volume,_word];
    __weak __block typeof (self) weakSelf=self;
    if (![[Utility instanceShare].db executeUpdate:insertSql1]) {
        NSLog(@"插入失败1");
        if ([self.delegate respondsToSelector:@selector(addSongToCollection:result:)]) {
            [self.delegate addSongToCollection:weakSelf result:KMessageWarning];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(addSongToCollection:result:)]) {
            [self.delegate addSongToCollection:weakSelf result:KMessageSuccess];
        }
    }
}

- (void)deleteSongFromCollectionTable {
    NSString *insertSql1= [NSString stringWithFormat:@"delete * from CollectionTable where number='%@'",_number];
    __weak __block typeof (self) weakSelf=self;
    if (![[Utility instanceShare].db executeUpdate:insertSql1]) {
        NSLog(@"插入失败1");
        if ([self.delegate respondsToSelector:@selector(deleteCollectionSong:result:)]) {
            [self.delegate deleteCollectionSong:weakSelf result:KMessageWarning];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(deleteCollectionSong:result:)]) {
            [self.delegate deleteCollectionSong:weakSelf result:KMessageSuccess];
        }
    }
}

- (void)cutSong {
    if (_number.length>0) {
        CommandControler *cmd=[[CommandControler alloc]init];
        [cmd sendCmd_switchSong];
        __weak __block typeof (self) weakSelf=self;
        if ([self.delegate respondsToSelector:@selector(cutSongFromCollection:result:)]) {
            [self.delegate cutSongFromCollection:weakSelf result:KMessageSuccess];
        }
    }
}

- (void)prioritySong {
    if (_number.length>0) {
        CommandControler *cmd=[[CommandControler alloc]init];
        [cmd sendCmd_DiangeToTop:_number];
        __weak __block typeof (self) weakSelf=self;
        if ([self.delegate respondsToSelector:@selector(dingGeFromCollection:result:)]) {
            [self.delegate dingGeFromCollection:weakSelf result:KMessageSuccess];
        }
    }
}

@end
