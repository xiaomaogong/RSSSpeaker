//
//  AppDelegate.h
//  RSS语音助手
//
//  Created by 龚莎 on 15/3/19.
//  Copyright (c) 2015年 iosnerds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DYGetFetchedRecordsModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSArray *)fetchRecordsWithPrivateContext:(DYGetFetchedRecordsModel *)getModel privateContext:(NSManagedObjectContext *)privateContext;

@end

