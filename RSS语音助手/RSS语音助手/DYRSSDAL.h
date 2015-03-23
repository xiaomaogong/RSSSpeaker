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

// 取消收藏文章
- (void)dislikeArticle:(DYArticle *)article withContext:(NSManagedObjectContext *)context;
// 收藏文章
- (void)likeArticle:(DYArticle *)article withContext:(NSManagedObjectContext *)context;
// 标志文章已读
- (void)markAsRead:(DYArticle *)article withContext:(NSManagedObjectContext *)context;
// 插入FeedUrl关联的文章
- (void)insertArticlesWithFeedurl:(NSSet *)articles withFeedUrlStr:(NSString *)feedUrl withContext:(NSManagedObjectContext *)context;
// 插入rss，以及相应的文章
- (void)insertRSS:(DYRSS *)rss withArticles:(NSSet *)articles withContext:(NSManagedObjectContext *)context success:(void (^)(void))success fail:(void (^)(NSString *error))fail;
// 删除rss
- (void)removeRSS:(NSString *)feedUrl withContext:(NSManagedObjectContext *)context;

@end
