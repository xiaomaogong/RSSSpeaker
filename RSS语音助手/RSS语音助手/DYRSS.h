//
//  DYRSS.h
//  RSS语音助手
//
//  Created by ss on 15/3/20.
//  Copyright (c) 2015年 iosnerds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DYArticle;

@interface DYRSS : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * sourceUrl;
@property (nonatomic, retain) NSDate * lastUpdateTime;
@property (nonatomic, retain) NSSet *articles;
@end

@interface DYRSS (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(DYArticle *)value;
- (void)removeArticlesObject:(DYArticle *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

@end
