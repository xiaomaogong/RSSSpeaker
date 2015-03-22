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

- (void)insertArticlesWithFeedItems:(NSSet *)items withFeedUrlStr:(NSString *)feedUrl withContext:(NSManagedObjectContext *)context;
- (void)addRSS:(DYRSS *)rss withArticles:(NSSet *)articles withContext:(NSManagedObjectContext *)context success:(void (^)(void))success fail:(void (^)(NSString *error))fail;
- (void)deleteRSS:(NSString *)feedUrl withContext:(NSManagedObjectContext *)context;

- (void)markAsRead:(DYArticle *)article withContext:(NSManagedObjectContext *)context;

#pragma mark 主页

-(BOOL)isSameDayCompareToLastUpdatedTime;

-(NSArray*)getAllArticles;

-(void)deleteAllArticles;

@end
