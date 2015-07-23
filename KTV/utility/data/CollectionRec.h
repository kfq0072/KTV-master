//
//  CollectionRec.h
//  KTV
//
//  Created by stevenhu on 15/5/9.
//  Copyright (c) 2015年 stevenhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CollectionRec : NSManagedObject

@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * sname;
@property (nonatomic, retain) NSNumber * rcid;

@end
