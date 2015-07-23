//
//  ZZImportData.m
//  KTV
//
//  Created by stevenhu on 15/4/18.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import "ZZImportData.h"
#import "FMDB.h"

#define STOREURL [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"DB.sqlite"]
@interface ZZImportData () {
    FMDatabase *dataBase;
}

@end
static ZZImportData *_instance;
@implementation ZZImportData

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc]init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[super allocWithZone:zone];
    });
    return _instance;
}

- (void)addIntoDataSource:(importDataResult)ZZblock{
    BOOL value=[[NSUserDefaults standardUserDefaults]objectForKey:@"DATAIMPORTED"];
    if (value) {
        ZZblock(YES);
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self importDataForSongs:ZZblock];
            [self importDataForSingers:ZZblock];
            [self importDataForType:ZZblock];
            [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"DATAIMPORTED"];
            ZZblock(YES);
        });
    }
    
    
    
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    //            [self importDataForCollection:ZZblock];
    //            ZZblock(YES);
    //        });
    //
    //
    //    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    //        [self importDataForPaiHangBang:ZZblock];
    //    });
    //
    //    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    //        [self importDataForPaiHangBang:ZZblock];
    //    });
    //
    //    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    //
    //    });
    //
    
    //
    //    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    //        [self importDataForjinYuanJi:ZZblock];
    //    });
    //
    
}
- (void)importDataForSongs:(importDataResult)ZZblock {
    NSLog(@"%@",STOREURL);
    //open database and check table if existed;
    dataBase=[FMDatabase databaseWithPath:STOREURL];
    if([dataBase open]) {
        
        BOOL isSuccess=[dataBase executeUpdate:@"create table IF NOT EXISTS songList (number text,songname text,singer text,singer1 text,songpiy text,word text,language text,volume text,channel text,sex text,stype text,newsong text,movie text,pathid text,bihua text,addtime text,spath text)"];
        //read file
        if (isSuccess) {
            NSString *txtPath=[[NSBundle mainBundle]pathForResource:@"songlist.txt" ofType:nil];
            NSFileHandle *fileHandle=[NSFileHandle fileHandleForReadingAtPath:txtPath];
            NSString *str=[[NSString alloc]initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
            NSArray *lines=[str componentsSeparatedByString:@"\t\r\n"];
            //            NSDate* StartData = [NSDate date];
            [dataBase beginTransaction];
            for (NSString *lineStr in lines) {
                NSArray *lineArry=[lineStr componentsSeparatedByString:@"\t"];
                if  (lineArry.count !=17) continue;
                NSString *sql=@"INSERT INTO songList VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                [dataBase executeUpdate:sql,lineArry[0],lineArry[1],lineArry[2],lineArry[3],lineArry[4],lineArry[5],lineArry[6],lineArry[7],lineArry[8],lineArry[9],lineArry[10],lineArry[11],lineArry[12],lineArry[13],lineArry[14],lineArry[15],lineArry[16]];
                
            }
            [dataBase commit];
        } else {
            NSLog(@"table create error");
            [dataBase close];
        }
    } else {
        [dataBase close];
        NSLog(@"database open error");
    }
}

-(void)importDataForSingers:(importDataResult)ZZblock{
    NSLog(@"%@",STOREURL);
    //open database and check table if existed;
    dataBase=[FMDatabase databaseWithPath:STOREURL];
    if([dataBase open]) {
        
        BOOL isSuccess=[dataBase executeUpdate:@"create table IF NOT EXISTS singerList (singer text,pingyin text,s_bi_hua text,area text)"];
        //read file
        if (isSuccess) {
            NSString *txtPath=[[NSBundle mainBundle]pathForResource:@"singlist.txt" ofType:nil];
            NSFileHandle *fileHandle=[NSFileHandle fileHandleForReadingAtPath:txtPath];
            NSString *str=[[NSString alloc]initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
            NSArray *lines=[str componentsSeparatedByString:@"\r\n"];
            [dataBase beginTransaction];
            for (NSMutableString *tmplineStr in lines) {
                NSMutableString *lineStr=[tmplineStr mutableCopy];
                [lineStr replaceOccurrencesOfString:@"\t\t" withString:@"\t" options:NSLiteralSearch range:NSMakeRange(0, lineStr.length)];
                NSArray *lineArry=[lineStr componentsSeparatedByString:@"\t"];
                if  (lineArry.count !=4) continue;
                NSString *sql=@"INSERT INTO singerList VALUES(?,?,?,?)";
                [dataBase executeUpdate:sql,lineArry[0],lineArry[1],lineArry[2],lineArry[3]];
            }
            [dataBase commit];
        } else {
            NSLog(@"table create error");
            [dataBase close];
        }
    } else {
        [dataBase close];
        NSLog(@"database open error");
    }
    
}

- (void)importDataForPaiHangBang:(importDataResult)ZZblock {
    
}

- (void)importDataForCollection:(importDataResult)ZZblock {
    NSLog(@"%@",STOREURL);
    //open database and check table if existed;
    dataBase=[FMDatabase databaseWithPath:STOREURL];
    if([dataBase open]) {
        
        BOOL isSuccess=[dataBase executeUpdate:@"create table IF NOT EXISTS collectionList (number text,sname text,rcid text)"];
        //read file
        if (isSuccess) {
            NSString *txtPath=[[NSBundle mainBundle]pathForResource:@"collection.txt" ofType:nil];
            NSFileHandle *fileHandle=[NSFileHandle fileHandleForReadingAtPath:txtPath];
            NSData *data=[fileHandle readDataOfLength:5];
            NSLog(@"%@",data);
            //            [fileHandle seekToFileOffset:6];
            NSData *data1=[fileHandle readDataOfLength:5];
            NSLog(@"%@",data1);
            //          [fileHandle seekToFileOffset:12];
            NSData *data2=[fileHandle readDataOfLength:5];
            NSLog(@"%@",data2);
            
            
            NSString *str=[[NSString alloc]initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
            NSArray *lines=[str componentsSeparatedByString:@"\r\n"];
            [dataBase beginTransaction];
            for (NSMutableString *lineStr in lines) {
                NSArray *lineArry=[lineStr componentsSeparatedByString:@"\t"];
                if  (lineArry.count !=3) continue;
                NSString *sql=@"INSERT INTO singerList VALUES(?,?,?)";
                [dataBase executeUpdate:sql,lineArry[0],lineArry[1],lineArry[2]];
            }
            [dataBase commit];
        } else {
            NSLog(@"table create error");
            [dataBase close];
        }
    } else {
        [dataBase close];
        NSLog(@"database open error");
    }
    
}

- (void)importDataForType:(importDataResult)ZZblock{
    NSLog(@"%@",STOREURL);
    //open database and check table if existed;
    dataBase=[FMDatabase databaseWithPath:STOREURL];
    if([dataBase open]) {
        
        BOOL isSuccess=[dataBase executeUpdate:@"create table IF NOT EXISTS typeList (type text,typeid text,typename text)"];
        //read file
        if (isSuccess) {
            NSString *txtPath=[[NSBundle mainBundle]pathForResource:@"typelist.txt" ofType:nil];
            NSFileHandle *fileHandle=[NSFileHandle fileHandleForReadingAtPath:txtPath];
            NSString *str=[[NSString alloc]initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
            NSArray *lines=[str componentsSeparatedByString:@"\r\n"];
            [dataBase beginTransaction];
            for (NSMutableString *lineStr in lines) {
                NSArray *lineArry=[lineStr componentsSeparatedByString:@"\t"];
                if  (lineArry.count !=3) continue;
                NSString *sql=@"INSERT INTO typeList VALUES(?,?,?)";
                [dataBase executeUpdate:sql,lineArry[0],lineArry[1],lineArry[2]];
            }
            [dataBase commit];
        } else {
            NSLog(@"table create error");
            [dataBase close];
        }
    } else {
        [dataBase close];
        NSLog(@"database open error");
    }
}

- (void)importDataForjinYuanJi {
    
}
@end
