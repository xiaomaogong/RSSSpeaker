//
//  DYArticleDAL.m
//  RSS语音助手
//
//  Created by 龚莎 on 3/21/15.
//  Copyright (c) 2015 iosnerds. All rights reserved.
//

#import "DYRSSDAL.h"
#import "DYGetFetchedRecordsModel.h"
#import "DYRSS.h"
#import "DYArticle.h"

#import "MWFeedParser.h"

@implementation DYRSSDAL

- (void)dislikeArticle:(DYArticle *)article  withContext:(NSManagedObjectContext *)context {
    [self markWithFavorFlag:article withContext:context witchFavorFlag:NO];
}

- (void)likeArticle:(DYArticle *)article  withContext:(NSManagedObjectContext *)context {
    [self markWithFavorFlag:article withContext:context witchFavorFlag:YES];
}

- (void)markWithFavorFlag:(DYArticle *)article withContext:(NSManagedObjectContext *)context witchFavorFlag:(BOOL) isFavor {
    DYGetFetchedRecordsModel * getModel = [[DYGetFetchedRecordsModel alloc] init];
    getModel.entityName = @"DYArticle";
    getModel.predicate = [NSPredicate predicateWithFormat:@"url=%@",article.url];
    NSArray *fetchedRecorders =
    [NSArray array];
    fetchedRecorders = [APP_DELEGATE fetchRecordsWithPrivateContext:getModel privateContext:context];
    if (fetchedRecorders && [fetchedRecorders count]) {
        for (DYArticle *aArticle in fetchedRecorders) {
            aArticle.isFavor = isFavor ? @1 : @0;
        }
    }
    NSError *error;
    [context save:&error];
}

- (void)markAsRead:(DYArticle *)article withContext:(NSManagedObjectContext *)context {
    DYGetFetchedRecordsModel * getModel = [[DYGetFetchedRecordsModel alloc] init];
    getModel.entityName = @"DYArticle";
    getModel.predicate = [NSPredicate predicateWithFormat:@"url=%@",article.url];
    NSArray *fetchedRecorders =
    [NSArray array];
    fetchedRecorders = [APP_DELEGATE fetchRecordsWithPrivateContext:getModel privateContext:context];
    if (fetchedRecorders && [fetchedRecorders count]) {
        for (DYArticle *aArticle in fetchedRecorders) {
            aArticle.isReaded = @1;
        }
    }
    NSError *error;
    [context save:&error];
}

- (void)insertArticlesWithFeedItems:(NSArray *)items withFeedUrlStr:(NSString *)feedUrl withContext:(NSManagedObjectContext *)context {
    DYGetFetchedRecordsModel *getModel = [[DYGetFetchedRecordsModel alloc] init];
    getModel.entityName = @"DYRSS";
    getModel.predicate = [NSPredicate predicateWithFormat:@"sourceUrl=%@", feedUrl];
    NSArray * fetchedRSSRecorders = [NSArray array];
    fetchedRSSRecorders = [APP_DELEGATE fetchRecordsWithPrivateContext:getModel privateContext:context];
    
    NSMutableSet *articles = [NSMutableSet init];
    for (MWFeedItem *item in items) {
        DYArticle *aArticle = [[DYArticle alloc] init];
        aArticle.createdDate = item.date;
        aArticle.title = item.title;
        aArticle.url = item.link;
        aArticle.content = item.content;
        aArticle.isFavor = @0;
        aArticle.isReaded = @0;
        [articles addObject:aArticle];
    }
    
    if (fetchedRSSRecorders && [fetchedRSSRecorders count]) {
        for (DYRSS * aRSS in fetchedRSSRecorders) {
            NSMutableSet *insertedItems = [NSMutableSet setWithArray:[articles allObjects]];
            [insertedItems minusSet:aRSS.articles];
            [aRSS addArticles:insertedItems];
        }
    }
    NSError *error;
    [context save:&error];
    
    if([(NSObject *)_delegate respondsToSelector:@selector(articlesDidInsert)]){
        [_delegate articlesDidInsert];
    }
}

- (void)deleteRSS:(NSString *)feedUrl withContext:(NSManagedObjectContext *)context {
    DYGetFetchedRecordsModel *getModel = [[DYGetFetchedRecordsModel alloc] init];
    getModel.entityName = @"DYRSS";
    getModel.predicate = [NSPredicate predicateWithFormat:@"sourceUrl=%@", feedUrl];
    NSArray * fetchedRSSRecorders = [NSArray array];
    fetchedRSSRecorders = [APP_DELEGATE fetchRecordsWithPrivateContext:getModel privateContext:context];
    
    if (fetchedRSSRecorders && [fetchedRSSRecorders count]) {
        for (DYRSS *aRSS in fetchedRSSRecorders) {
            for (DYArticle *aArticle in fetchedRSSRecorders) {
                [aRSS removeArticlesObject:aArticle];
            }
        }
    }
    NSError *error;
    [context save:&error];
}

@end
