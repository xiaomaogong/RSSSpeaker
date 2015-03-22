//
//  DYConverter.m
//  RSS语音助手
//
//  Created by 龚莎 on 3/22/15.
//  Copyright (c) 2015 iosnerds. All rights reserved.
//

#import "DYConverter.h"
#import "DYArticle.h"

#import <MWFeedParser/MWFeedParser.h>

@implementation DYConverter

+ (DYArticle *)convertFromFeedItem:(MWFeedItem *)feedItem context:(NSManagedObjectContext *)context {
    DYArticle *aArticle = [NSEntityDescription insertNewObjectForEntityForName:@"DYArticle" inManagedObjectContext:APP_DELEGATE.managedObjectContext];
    aArticle.url = feedItem.link;
    aArticle.title = feedItem.title;
    aArticle.content = feedItem.content ? feedItem.content : (feedItem.summary ? feedItem.summary : @"No Content");
    return aArticle;
}

@end
