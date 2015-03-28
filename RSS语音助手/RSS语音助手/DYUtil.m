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
{

}
 static NSMutableDictionary * viewControllerCache;

+ (NSManagedObjectContext*)getPrivateManagedObjectContext {
    //return [[APP_DELEGATE managedObjectContext] generatePrivateContext];
    return [APP_DELEGATE managedObjectContext];
}

+ (NSDate*)convertYMD:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:date];
    NSDate *result = [dateFormatter dateFromString:oneDayStr];
    return result;
}

+ (NSInteger)compareYMD:(NSDate*)former latter:(NSDate*)later {
    NSDate *dateA = [DYUtil convertYMD:former];
    NSDate *dateB = [DYUtil convertYMD:later];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        return 1;
    }
    else if (result == NSOrderedAscending) {
        return -1;
    }
    else {
        return 0;
    }
}


+(UIViewController*)getCacheUIViewControllerByKey:(NSString*)key{
    if(viewControllerCache == nil)
        viewControllerCache = [NSMutableDictionary dictionary];
    return [viewControllerCache objectForKey:key];
}

+(void)setCacheUIViewControllers:(NSString*)key withController:(UIViewController*) controller{
    if(viewControllerCache == nil)
        viewControllerCache = [NSMutableDictionary dictionary];

    [viewControllerCache setObject:controller forKey:key];
}

@end
