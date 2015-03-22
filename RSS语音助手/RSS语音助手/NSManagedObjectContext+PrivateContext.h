//
//  NSManagedObjectContext+PrivateContext.h
//  RSS语音助手
//
//  Created by 龚莎 on 3/21/15.
//  Copyright (c) 2015 iosnerds. All rights reserved.
//

#import <CoreData/NSManagedObjectContext.h>

@interface NSManagedObjectContext (PrivateContext)

+ (NSManagedObjectContext *)generatePrivateContextWithParent:(NSManagedObjectContext *)parentContext;

@end
