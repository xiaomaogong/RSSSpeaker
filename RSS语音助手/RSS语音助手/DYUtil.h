//
//  DYUtil.h
//  RSS语音助手
//
//  Created by ss on 15/3/22.
//  Copyright (c) 2015年 iosnerds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYUtil : NSObject
+ (NSManagedObjectContext*)getPrivateManagedObjectContext;

+ (NSDate*)convertYMD:(NSDate*)date;

// 比较日期
/*
    return(NSInteger):  
       -1：后者比前者大
        0：相等
        1:前者比后者大
 */
+ (NSInteger)compareYMD:(NSDate*)former latter:(NSDate*)later;
@end
