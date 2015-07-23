//
//  Utility.m
//  ZZKTV
//
//  Created by stevenhu on 15-3-22.
//  Copyright (c) 2015年 zz. All rights reserved.
//
//fmdb
#import "Utility.h"
#import "CommandControler.h"
#import "BBBadgeBarButtonItem.h"
#import "Reachability.h"
#define tmpDBPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"tmpDB.sqlite"]
#define DBPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"DB.sqlite"]

#define COMM_URLStr @"http://192.168.43.1:8080/puze/?cmd=0x01&filename="
#define DOCUMENTPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
static  int limit=1000;
@interface Utility() {
    NSMutableArray *needImportFilefullPaths;
    NSString* savePath_TxtDir;
    int hasCount;
}
-(void)reachabilityChanged:(NSNotification*)note;
@property (nonatomic, copy)NSString *modelName;
@property (nonatomic, copy)NSString *dbFileName;
@property (nonatomic,readwrite)FMDatabase *db;
@property(strong) Reachability * localWiFiReach;
@end
static Utility *shareInstance=nil;
@implementation Utility
+ (instancetype)instanceShare {
    static  dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareInstance) {
            shareInstance=[[self alloc]init];
            
        }
    });
    return shareInstance;
}

- (id)init {
    if (self=[super init]) {
        needImportFilefullPaths=[NSMutableArray new];
        _db=[[FMDatabase alloc]initWithPath:DBPATH];
        if ([_db open]) {
            NSLog(@"DataBase is open ok");
        } else {
            NSLog(@"DataBase is open faied");
            
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [self checkTableAndCreateAndMonitor];
    return self;
}

- (void)checkTableAndCreateAndMonitor{
    // create a reachability for the local WiFi
    self.localWiFiReach = [Reachability reachabilityForLocalWiFi];
    __weak __block typeof(self) weakself=self;
    // we ONLY want to be reachable on WIFI - cellular is NOT an acceptable connectivity
    self.localWiFiReach.reachableOnWWAN = NO;
    
    self.localWiFiReach.reachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"LocalWIFI Block Says Reachable(%@)", reachability.currentReachabilityString];
        NSLog(@"%@", temp);
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            weakself.localWifiblockLabel.text = temp;
//            weakself.localWifiblockLabel.textColor = [UIColor blackColor];
//        });
    };
    
    self.localWiFiReach.unreachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"LocalWIFI Block Says Unreachable(%@)", reachability.currentReachabilityString];
        
        NSLog(@"%@", temp);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            weakself.localWifiblockLabel.text = temp;
//            weakself.localWifiblockLabel.textColor = [UIColor redColor];
//        });
    };
    
    [self.localWiFiReach startNotifier];
}
// create a Reachability object for www.google.com
//
//self.googleReach = [Reachability reachabilityWithHostname:@"www.google.com"];
//
//self.googleReach.reachableBlock = ^(Reachability * reachability)
//{
//    NSString * temp = [NSString stringWithFormat:@"GOOGLE Block Says Reachable(%@)", reachability.currentReachabilityString];
//    NSLog(@"%@", temp);
//    
//    // to update UI components from a block callback
//    // you need to dipatch this to the main thread
//    // this uses NSOperationQueue mainQueue
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        weakself.blockLabel.text = temp;
//        weakself.blockLabel.textColor = [UIColor blackColor];
//    }];
//};
//
//self.googleReach.unreachableBlock = ^(Reachability * reachability)
//{
//    NSString * temp = [NSString stringWithFormat:@"GOOGLE Block Says Unreachable(%@)", reachability.currentReachabilityString];
//    NSLog(@"%@", temp);
//    
//    // to update UI components from a block callback
//    // you need to dipatch this to the main thread
//    // this one uses dispatch_async they do the same thing (as above)
//    dispatch_async(dispatch_get_main_queue(), ^{
//        weakself.blockLabel.text = temp;
//        weakself.blockLabel.textColor = [UIColor redColor];
//    });
//};
//
//[self.googleReach startNotifier];

+ (iphoneModel)whatIphoneDevice {
    if (IS_IPHONE_4_OR_LESS) {
        NSLog(@"4s");
        return isiPhone4s;
    } else if (IS_IPHONE_5) {
        NSLog(@"iphone5");
        return isiphone5s;
    } else if (IS_IPHONE_6) {
        NSLog(@"iphone6");
        return isiphone6;
    } else if (IS_IPHONE_6P) {
        NSLog(@"iphone6s");
        return isiphone6p;
    }
    
    return unkownPhone;
    
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone  {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance=[super allocWithZone:zone];
        NSLog(@"path is %@",tmpDBPATH);
    });
    return shareInstance;
}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setupEnvModel:(NSString *)model DbFile:(NSString *)filename {
    
}

+ (float)user_iosVersion {
    return [[UIDevice currentDevice].systemVersion floatValue];
}

+ (NSString *)chineseToPinYin:(NSString *)string {
    NSMutableString *muString=[string mutableCopy];
    CFStringTransform((CFMutableStringRef)muString, NULL, kCFStringTransformToLatin, NO);
    CFStringTransform((CFMutableStringRef)muString, NULL, kCFStringTransformStripDiacritics, NO);
    return [muString copy];
}

+ (BOOL)isIncludeChineseInString:(NSString*)str {
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}

+ (NSString*)shouZiFu:(NSString*)string {
    return  [[Utility chineseToPinYin:string]substringToIndex:1];
}

#define DEFAULT_VOID_COLOR [UIColor whiteColor]
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark - coredata operation
- (void)addIntoDataSource:(Completed)completed{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      [self startTodoInitailizationData];
      if (completed) {
          return completed(YES);
      }
  });
}
- (BOOL)startTodoInitailizationData {
    [self initneedDownLoadFilesPathAndDownLoad];
    for (NSString *oneFilePath in needImportFilefullPaths) {
        NSString *fileName=[oneFilePath lastPathComponent];
        if ([fileName isEqualToString:@"songlist.txt"]) {
            [self importDataForSongs:oneFilePath];
        }
        else if([fileName isEqualToString:@"singlist.txt"]) {
            [self importDataForSingers:oneFilePath];
        }else if([fileName isEqualToString:@"typelist.txt"]) {
            [self importDataForType:oneFilePath];
        } else if ([fileName isEqualToString:@"orderdata.txt"]) {
//            [self importDataForOrder:oneFilePath];
        }
    }
    return YES;
}

- (NSError*)importDataForSongs:(NSString*)txtFilePath {
    //check and create Table
    NSString *sqlCreateTable =@"CREATE TABLE IF NOT EXISTS SongTable (number TEXT,songname TEXT,singer TEXT,singer1 TEXT,songpiy TEXT,word TEXT,language TEXT,volume TEXT,channel TEXT,sex TEXT,stype TEXT,newsong TEXT,movie TEXT,pathid TEXT,bihua TEXT,addtime TEXT,spath TEXT)";
    
    BOOL res = [_db executeUpdate:sqlCreateTable];
    if (!res) {
        NSLog(@"error when creating SongTable table");
    } else {
        NSLog(@"success to creating SongTable table");
    }
    NSString *fileName=[txtFilePath lastPathComponent];
    NSString *str=[NSString stringWithContentsOfFile:txtFilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines=[str componentsSeparatedByString:@"\t\r\n"];
    hasCount=(int)lines.count;
    [self insertSongsData:0 toIndex:999 useTransaction:YES dataSource:lines];
    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:fileName];
    str=nil;
    lines=nil;
    return nil;
}

- (void)insertSongsData:(int)fromIndex toIndex:(int)toIndex useTransaction:(BOOL)useTransaction dataSource:(NSArray*)dataSource {
    if (useTransaction) {
        [_db beginTransaction];
        BOOL isRollBack=NO;
        @try {
            for (int i=fromIndex;i<toIndex+1; i++) {
                 hasCount--;
                @autoreleasepool {
                    NSArray *lineArry=[dataSource[i] componentsSeparatedByString:@"\t"];
                    if  (lineArry.count !=17) {
                        toIndex--;
//                        NSLog(@"--line error--%d",i);
                        continue;
                    }
      
                    NSString *insertSql1= [NSString stringWithFormat:@"INSERT INTO SongTable (number,songname,singer,singer1,songpiy,word,language,volume,channel,sex,stype,newsong,movie,pathid,bihua,addtime,spath)VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[self encodeBase64:lineArry[0]],[self encodeBase64:lineArry[1]],[self encodeBase64:lineArry[2]],[self encodeBase64:lineArry[3]],[self encodeBase64:lineArry[4]],[self encodeBase64:lineArry[5]],[self encodeBase64:lineArry[6]],[self encodeBase64:lineArry[7]],[self encodeBase64:lineArry[8]],[self encodeBase64:lineArry[9]],[self encodeBase64:lineArry[10]],[self encodeBase64:lineArry[11]],[self encodeBase64:lineArry[12]],[self encodeBase64:lineArry[13]],[self encodeBase64:lineArry[14]],[self encodeBase64:lineArry[15]],[self encodeBase64:lineArry[16]]];
                    if (![_db executeUpdate:insertSql1]) {
                        NSLog(@"插入失败1");
                    }
                 
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [_db rollback];
        }
        @finally {
            if (!isRollBack) {
                [_db commit];
            }
        }
    } else {
        
    }
    if (hasCount >=limit) {
        fromIndex=toIndex+1;
        toIndex=fromIndex+limit;
        [self insertSongsData:fromIndex toIndex:toIndex useTransaction:YES dataSource:dataSource];
    } else if (hasCount >0 && hasCount < limit) {
        fromIndex=toIndex+1;
        toIndex=fromIndex+hasCount;
      [self insertSongsData:fromIndex toIndex:toIndex useTransaction:YES dataSource:dataSource];
    }
//    NSLog(@"fromeIndex:%d toIndex:%d",fromIndex,toIndex);
}


- (NSError*)importDataForSingers:(NSString*)txtFilePath {
    //check and create Table
    NSString *sqlCreateTable =@"CREATE TABLE IF NOT EXISTS SingerTable (sid TEXT,singer TEXT,pingyin TEXT,s_bi_hua TEXT,area TEXT)";
    
    BOOL res = [_db executeUpdate:sqlCreateTable];
    if (!res) {
        NSLog(@"error when creating SingerTable table");
    } else {
        NSLog(@"success to creating SingerTable table");
    }
    
    NSString *fileName=[txtFilePath lastPathComponent];
    NSString *str=[NSString stringWithContentsOfFile:txtFilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines=[str componentsSeparatedByString:@"\r\n"];
    hasCount=(int)lines.count;
    [self insertSingersData:0 toIndex:999 useTransaction:YES dataSource:lines];
    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:fileName];
    str=nil;
    lines=nil;
    return nil;
}

- (void)insertSingersData:(int)fromIndex toIndex:(int)toIndex useTransaction:(BOOL)useTransaction dataSource:(NSArray*)dataSource {
    if (toIndex>dataSource.count) {
        return;
    }
    if (useTransaction) {
        [_db beginTransaction];
        BOOL isRollBack=NO;
        @try {
            for (int i=fromIndex;i<toIndex+1; i++) {
                hasCount--;
                @autoreleasepool {
                    NSMutableString *lineStr=[dataSource[i] mutableCopy];
                    [lineStr replaceOccurrencesOfString:@"\t\t" withString:@"\t" options:NSLiteralSearch range:NSMakeRange(0, lineStr.length)];
                    NSArray *lineArry=[lineStr componentsSeparatedByString:@"\t"];
                    if  (lineArry.count !=4) {
                        toIndex--;
                        NSLog(@"line error %d",fromIndex);
                        continue;
                    }
                    NSString *insertSql1=[NSString stringWithFormat:@"INSERT INTO SingerTable (singer,pingyin,s_bi_hua,area)VALUES ('%@','%@','%@','%@')",[self encodeBase64:lineArry[0]],[self encodeBase64:lineArry[1]],[self encodeBase64:lineArry[2]],[self encodeBase64:lineArry[3]]];
                    if (![_db executeUpdate:insertSql1]) {
                        NSLog(@"插入失败1");
                    }
                    
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [_db rollback];
        }
        @finally {
            if (!isRollBack) {
                [_db commit];
            }
        }
    } else {
        
    }
    if (hasCount >=limit) {
        fromIndex=toIndex+1;
        toIndex=fromIndex+limit;
        [self insertSingersData:fromIndex toIndex:toIndex useTransaction:YES dataSource:dataSource];
    } else if (hasCount >0 && hasCount < limit) {
        fromIndex=toIndex+1;
        toIndex=fromIndex+hasCount;
        [self insertSingersData:fromIndex toIndex:toIndex useTransaction:YES dataSource:dataSource];
    }
    
}


- (NSError*)importDataForType:(NSString*)txtFilePath {
    //check and create Table
    NSString *sqlCreateTable =@"CREATE TABLE IF NOT EXISTS TypeTable (typeid TEXT,type TEXT,typename TEXT)";
    BOOL res = [_db executeUpdate:sqlCreateTable];
    if (!res) {
        NSLog(@"error when creating TypeTable table");
    } else {
        NSLog(@"success to creating TypeTable table");
    }
    
    NSString *fileName=[txtFilePath lastPathComponent];
    NSString *str=[NSString stringWithContentsOfFile:txtFilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines=[str componentsSeparatedByString:@"\r\n"];
    [self insertTypesData:0 toIndex:999 useTransaction:YES dataSource:lines];
    hasCount=(int)lines.count;
    for (NSMutableString *lineStr in lines) {
        @autoreleasepool {
            NSArray *lineArry=[lineStr componentsSeparatedByString:@"\t"];
            if  (lineArry.count !=3) {
                continue;
            }
            NSString *insertSql= [NSString stringWithFormat:@"INSERT INTO TypeTable (typeid,type,typename)VALUES ('%@','%@','%@')",[self encodeBase64:lineArry[0]],[self encodeBase64:lineArry[1]],[self encodeBase64:lineArry[2]]];
            [_db executeUpdate:insertSql];
            
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:fileName];
    str=nil;
    lines=nil;
    return nil;
}

- (void)insertTypesData:(int)fromIndex toIndex:(int)toIndex useTransaction:(BOOL)useTransaction dataSource:(NSArray*)dataSource {
    if (toIndex>dataSource.count) {
        return;
    }
    if (useTransaction) {
        [_db beginTransaction];
        BOOL isRollBack=NO;
        @try {
            for (int i=fromIndex;i<toIndex+1; i++) {
                hasCount--;
                @autoreleasepool {
                    NSArray *lineArry=[dataSource[i] componentsSeparatedByString:@"\t"];
                    if  (lineArry.count !=3) {
                        continue;
                    }
                    NSString *insertSql= [NSString stringWithFormat:@"INSERT INTO TypeTable (typeid,type,typename)VALUES ('%@','%@','%@')",[self encodeBase64:lineArry[0]],[self encodeBase64:lineArry[1]],[self encodeBase64:lineArry[2]]];
                    [_db executeUpdate:insertSql];
                    NSString *insertSql1=[NSString stringWithFormat:@"INSERT INTO SingerTable (singer,pingyin,s_bi_hua,area)VALUES ('%@','%@','%@','%@')",[self encodeBase64:lineArry[0]],[self encodeBase64:lineArry[1]],[self encodeBase64:lineArry[2]],[self encodeBase64:lineArry[3]]];
                    if (![_db executeUpdate:insertSql1]) {
                        NSLog(@"插入失败1");
                    }
      
                }
            }
        }
        @catch (NSException *exception) {
            isRollBack = YES;
            [_db rollback];
        }
        @finally {
            if (!isRollBack) {
                [_db commit];
            }
        }
    } else {
        
    }
    if (hasCount >=limit) {
        fromIndex=toIndex+1;
        toIndex=fromIndex+limit;
        [self insertSingersData:fromIndex toIndex:toIndex useTransaction:YES dataSource:dataSource];
    } else if (hasCount >0 && hasCount < limit) {
        fromIndex=toIndex+1;
        toIndex=fromIndex+hasCount;
        [self insertSingersData:fromIndex toIndex:toIndex useTransaction:YES dataSource:dataSource];
    }
}


- (NSError*)importDataForOrder:(NSString*)txtFilePath {
    //删除表
    NSString *sqlDeleteRecord =@"DROP TABLE IF EXISTS OrderTable";
    [_db executeUpdate:sqlDeleteRecord];
    //创建表
    NSString *sqlCreateTable =@"CREATE TABLE IF NOT EXISTS OrderTable (number TEXT,rcid TEXT,ordername TEXT)";
    
    BOOL res = [_db executeUpdate:sqlCreateTable];
    if (!res) {
        NSLog(@"error when creating OrderTable table");
    } else {
        NSLog(@"success to creating OrderTable table");
    }

    
    struct orderrec {
        char number[8];
        int rcid;
        int order;
    };
    struct orderrec *orderadd;
    FILE *fn=fopen([txtFilePath UTF8String], "r");
    if (fn==NULL) {
        return nil;
    }
    while (1) {
        orderadd=(struct orderrec*)calloc(1, sizeof(struct orderrec));
        
        if(fread(orderadd,sizeof(struct orderrec),1,fn)!=1)
        {
            break;
        }
        //        char * mynumber=(char *)malloc(8);
        //        strncpy(mynumber,orderadd->number,8);
        char * mynumber=(char *)malloc(9);
        memset(mynumber, 0, sizeof(char)*9);
        strncpy(mynumber,orderadd->number,8*sizeof(char));
        //        printf("\n%s\n%d\n%d\n",mynumber,orderadd->rcid,orderadd->order);
        NSString *number=[NSString stringWithCString:mynumber encoding:NSUTF8StringEncoding];
        NSString *rcid=[NSString stringWithFormat:@"%d",orderadd->rcid];
        NSString *order=[NSString stringWithFormat:@"%d",orderadd->order];
        if (number.length >8) {
            number=[number substringToIndex:7];
        } else if (number.length<8) {
            continue;
        }
        //        NSLog(@"\n%@\n%@\n%@",number,rcid,order);
        NSString *insertSql= [NSString stringWithFormat:@"INSERT INTO OrderTable (number,rcid,ordername)VALUES ('%@','%@','%@')",[self encodeBase64:number],[self encodeBase64:rcid],[self encodeBase64:order]];
        [_db executeUpdate:insertSql];
        free(mynumber);
    }
    [self removeFile:[savePath_TxtDir stringByAppendingPathComponent:@"orderdata.txt"]];
    fclose(fn);
    free(orderadd);
    return nil;
}


- (void)setYidianBadgeWidth:(BBBadgeBarButtonItem *)item  {
    NSString *urlStr=[[@"http://192.168.43.1:8080/puze/?cmd=" stringByAppendingFormat:@"0xbc"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"get yidian List connection error");
            return;
        }
        NSString *strContent=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSMutableArray *arr=[[strContent componentsSeparatedByString:@"\r\n"] mutableCopy];
        [arr removeLastObject];
        dispatch_sync(dispatch_get_main_queue(), ^{
            item.badgeValue=[NSString stringWithFormat:@"%d",(int)arr.count];
        });
    }];
}

-(BOOL)checkTableAndCreate {
    return YES;
}

- (void)initneedDownLoadFilesPathAndDownLoad {
    NSArray *allFiles=@[@"songlist.txt",@"singlist.txt",@"typelist.txt",@"orderdata.txt"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    savePath_TxtDir=[DOCUMENTPATH stringByAppendingPathComponent:@"/downloadDir/txt"];
    if (![fileManager fileExistsAtPath:savePath_TxtDir]) {
        [fileManager createDirectoryAtPath:savePath_TxtDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    for (NSString *str in allFiles) {
        //if 数据表ok 返回
        //if 文件下载ok 导入数据酷
        //if
        if (![[[NSUserDefaults standardUserDefaults]objectForKey:str]boolValue]) {
            //file exist             //file size
            if ([fileManager fileExistsAtPath:[savePath_TxtDir stringByAppendingPathComponent:str]]) {
                if ([[fileManager attributesOfItemAtPath:[savePath_TxtDir stringByAppendingPathComponent:str] error:nil]valueForKey:@"NSFileSize"]>0) {
                    //导入数据
                    if (![[[NSUserDefaults standardUserDefaults]objectForKey:str]boolValue]) {
                        [needImportFilefullPaths addObject:[savePath_TxtDir stringByAppendingPathComponent:str]];
                    }
                } else {
                    //删除文件
                    [fileManager removeItemAtPath:[savePath_TxtDir stringByAppendingPathComponent:str] error:nil];
                    //下载
                    [self downLoadFile:str];
                }
                
            } else {
                //下载
                [self downLoadFile:str];
                
            }
            
        }
    }
}

//typelist.txt  songlist.txt orderdata.txt singlist.txt
- (void)downLoadFile:(NSString*)fileName{
    //need to add check network
    
    NSString *strURL=[COMM_URLStr stringByAppendingString:fileName];
    NSString *fileSavePath=[savePath_TxtDir stringByAppendingPathComponent:fileName];
    NSURL *url=[NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",url);
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data==nil) {
        NSLog(@"network error");
        [NSURLConnection canHandleRequest:request];

        [self removeFile:fileSavePath];
        return;
    }
    if([data writeToFile:fileSavePath atomically:YES]) {
        [needImportFilefullPaths addObject:[savePath_TxtDir stringByAppendingPathComponent:fileName]];
    }
}

- (BOOL)removeFile:(NSString*)filePath {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    return YES;
}

- (void)closeDB {
    [_db close];
    _db=nil;
}


- (NSString*)encodeBase64:(NSString*)decodestr {
   return [[decodestr dataUsingEncoding:NSUTF8StringEncoding]base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString*)decodeBase64:(NSString*)encodeStr {
    NSData *dataFromBase64String=[[NSData alloc]initWithBase64EncodedString:encodeStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc]initWithData:dataFromBase64String encoding:NSUTF8StringEncoding];
}



@end

