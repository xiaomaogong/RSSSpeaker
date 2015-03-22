//
//  DYConverter.h
//  RSS语音助手
//
//  Created by 龚莎 on 3/22/15.
//  Copyright (c) 2015 iosnerds. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DYArticle;
@class MWFeedItem;

@interface DYConverter : NSObject

+ (DYArticle*)convertFromFeedItem:(MWFeedItem *)feedItem context:(NSManagedObjectContext *)context;

@end
