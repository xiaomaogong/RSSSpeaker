//
//  DYArticle.h
//  RSS语音助手
//
//  Created by ss on 15/3/20.
//  Copyright (c) 2015年 iosnerds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DYArticle : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * isFavor;
@property (nonatomic, retain) NSNumber * isReaded;

@end
