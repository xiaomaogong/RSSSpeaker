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
+(NSManagedObjectContext*)getPrivateManagedObjectContext{
    return [[APP_DELEGATE managedObjectContext] generatePrivateContext];
}
@end
