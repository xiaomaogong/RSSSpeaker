//
//  NSManagedObjectContext+PrivateContext.m
//  RSS语音助手
//
//  Created by 龚莎 on 3/21/15.
//  Copyright (c) 2015 iosnerds. All rights reserved.
//

#import "NSManagedObjectContext+PrivateContext.h"

@implementation NSManagedObjectContext (PrivateContext)

+ (NSManagedObjectContext *)generatePrivateContextWithParent:(NSManagedObjectContext *)parentContext {
    NSManagedObjectContext *privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    privateContext.parentContext = parentContext;
    return privateContext;
}

@end
