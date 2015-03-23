//
//  DYUtil.m
//  RSS语音助手
//
//  Created by ss on 15/3/22.
//  Copyright (c) 2015年 iosnerds. All rights reserved.
//

#import "DYUtil.h"
#import <Foundation/Foundation.h>
#import "NSManagedObjectContext+PrivateContext.h"

@implementation DYUtil

+ (NSManagedObjectContext*)getPrivateManagedObjectContext {
    //return [[APP_DELEGATE managedObjectContext] generatePrivateContext];
    return [APP_DELEGATE managedObjectContext];
}

+ (NSInteger)compareYMD:(NSDate*)former latter:(NSDate*)later {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:former];
    NSString *anotherDayStr = [dateFormatter stringFromDate:later];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        return 1;
    }
    else if (result == NSOrderedAscending){
        return -1;
    } else {
        return 0;
    }
}

@end
