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
#import "DYUtil.h"
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

- (void)insertArticlesWithFeedItems:(NSSet *)items withFeedUrlStr:(NSString *)feedUrl withContext:(NSManagedObjectContext *)context {
    DYGetFetchedRecordsModel *getModel = [[DYGetFetchedRecordsModel alloc] init];
    getModel.entityName = @"DYRSS";
    getModel.predicate = [NSPredicate predicateWithFormat:@"sourceUrl=%@", feedUrl];
    NSArray * fetchedRSSRecorders = [NSArray array];
    fetchedRSSRecorders = [APP_DELEGATE fetchRecordsWithPrivateContext:getModel privateContext:context];
    
    NSMutableSet *articles = [NSMutableSet setWithSet:items];
    
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

- (void)addRSS:(DYRSS *)rss withArticles:(NSSet *)articles withContext:(NSManagedObjectContext *)context success:(void (^)(void))success fail:(void (^)(NSString *error))fail {
    DYGetFetchedRecordsModel *getModel = [[DYGetFetchedRecordsModel alloc] init];
    getModel.entityName = @"DYRSS";
    getModel.predicate = [NSPredicate predicateWithFormat:@"sourceUrl=%@", rss.sourceUrl];
    NSArray * fetchedRSSRecorders = [NSArray array];
    fetchedRSSRecorders = [APP_DELEGATE fetchRecordsWithPrivateContext:getModel privateContext:context];
    /*
     if (fetchedRSSRecorders.count) {
        NSString *error = @"SourceUrl already exist.";
        fail(error);
        return ;
    }
    */
    [rss addArticles:articles];
    NSError *error;
    [context save:&error];
    success();
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

-(BOOL)isSameDayCompareToLastUpdatedTime{
    return YES;
}

-(NSArray*)getAllArticles{
    NSManagedObjectContext * context = [DYUtil getPrivateManagedObjectContext];
    DYArticle* a = [NSEntityDescription insertNewObjectForEntityForName:@"DYArticle" inManagedObjectContext:context];
    a.title = @"My Text Article";
    a.content = @"With a determined, \n solemn look, the girl walks onto a crowded beach in Australia and dons a blindfold. At her feet she places a sign: \n I trust you. Do you trust me? Let's hug. It takes some time, but soon strangers start embracing her. \nThe resulting footage has been viewed more than 300,000 times on Facebook.";
    a.url = @"https://www.google.com";
    
    DYArticle* b = [NSEntityDescription insertNewObjectForEntityForName:@"DYArticle" inManagedObjectContext:context];
    b.title = @"My Text Article2";
    b.content = @"Sharp says the video's success wasn't guaranteed - and that he had a crew standing by to watch over the young subject, \n Jasirah Bin Hatim, and start the hugging off if needed. But we waited to see what the true reaction would be, \n he says, and after five long minutes the hugging started \n spontaneously.";
    b.url = @"https://www.google.com2";
    
    NSError* err;
    [context save:&err];
    
    return @[a,b];
}

-(void)deleteAllArticles{
    
}

#pragma mark Private Methods


@end
