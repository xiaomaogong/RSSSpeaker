//
//  DYArticleDAL.h
//  RSS语音助手
//
//  Created by 龚莎 on 3/21/15.
//  Copyright (c) 2015 iosnerds. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MWFeedItem;

@class DYArticle;
@class DYRSS;

@protocol DYRSSDALDelegate
@optional
- (void)articlesDidInsert;
@end

@interface DYRSSDAL : NSObject

@property(nonatomic,assign) id<DYRSSDALDelegate> delegate;

- (void)dislikeArticle:(DYArticle *)article withContext:(NSManagedObjectContext *)context;
- (void)likeArticle:(DYArticle *)article withContext:(NSManagedObjectContext *)context;

- (void)insertArticlesWithFeedItems:(NSArray *)items withFeedUrlStr:(NSString *)feedUrl withContext:(NSManagedObjectContext *)context;
- (void)deleteRSS:(NSString *)feedUrl withContext:(NSManagedObjectContext *)context;

- (void)markAsRead:(DYArticle *)article withContext:(NSManagedObjectContext *)context;


@end
