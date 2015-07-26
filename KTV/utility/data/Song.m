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
    _addtime=[Utility  decodeBase64:addtime];
}

- (void)setBihua:(NSString *)bihua {
    _bihua=[Utility  decodeBase64:bihua];
}

- (void)setChannel:(NSString *)channel {
    _channel=[Utility  decodeBase64:channel];
}

- (void)setLanguage:(NSString *)language {
    _language=[Utility  decodeBase64:language];
}

-(void)setMovie:(NSString *)movie {
    _movie=[Utility  decodeBase64:movie];
}

- (void)setNewsong:(NSString *)newsong {
    _newsong=[Utility  decodeBase64:newsong];
}

- (void)setNumber:(NSString *)number {
    _number=[Utility  decodeBase64:number];
}

- (void)setPathid:(NSString *)pathid {
    _pathid=[Utility  decodeBase64:pathid];
    
}

- (void)setSex:(NSString *)sex {
    _sex=[Utility decodeBase64:sex];
    
}

- (void)setSinger:(NSString *)singer {
    _singer=[Utility  decodeBase64:singer];
    
}

- (void)setSinger1:(NSString *)singer1 {
    _singer1=[Utility  decodeBase64:singer1];
    
}

- (void)setSongname:(NSString *)songname {
    _songname=[Utility  decodeBase64:songname];
    
}

- (void)setSongpiy:(NSString *)songpiy {
    _songpiy=[Utility  decodeBase64:songpiy];
    
}


- (void)setSpath:(NSString *)spath {
    _spath=[Utility  decodeBase64:spath];
    
}

- (void)setStype:(NSString *)stype {
    _stype=[Utility  decodeBase64:stype];
    
}

- (void)setVolume:(NSString *)volume {
    _volume=[Utility  decodeBase64:volume];
    
}

- (void)setWord:(NSString *)word {
    _word=[Utility  decodeBase64:word];
}



- (void)insertSongToCollectionTable {
    __weak __block typeof (self) weakSelf=self;
    NSString *querySqlStr=[NSString stringWithFormat:@"select * from CollectionTable where number='%@'",[Utility encodeBase64:_number]];
    FMResultSet *rs=[[Utility instanceShare].db executeQuery:querySqlStr];
    while ([rs next]) {
        if ([self.delegate respondsToSelector:@selector(addSongToCollection:result:)]) {
            [self.delegate addSongToCollection:weakSelf result:KMessageStyleInfo];
        }
        return;
    }
    NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO CollectionTable (number,songname,singer,singer1,songpiy,word,language,volume,channel,sex,stype,newsong,movie,pathid,bihua,addtime,spath)VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Utility encodeBase64:_number],[Utility encodeBase64:_songname],[Utility encodeBase64:_singer],[Utility encodeBase64:_singer1],[Utility encodeBase64:_songpiy],[Utility encodeBase64:_word],[Utility encodeBase64:_language],[Utility encodeBase64:_volume],[Utility encodeBase64:_channel],[Utility encodeBase64:_sex],[Utility encodeBase64:_stype],[Utility encodeBase64:_newsong],[Utility encodeBase64:_movie],[Utility encodeBase64:_pathid],[Utility encodeBase64:_bihua],[Utility encodeBase64:_addtime],[Utility encodeBase64:_spath]];
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
    NSString *insertSql1= [NSString stringWithFormat:@"delete from CollectionTable where number='%@'",[Utility encodeBase64:_number]];
    __weak __block typeof (self) weakSelf=self;
    if (![[Utility instanceShare].db executeUpdate:insertSql1]) {
        NSLog(@"取消收藏失败");
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
