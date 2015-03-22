#import <Foundation/Foundation.h>

@class MWFeedInfo;

@interface DYRSSFetchOperation : NSOperation

- (id) initWithURL:(NSURL *)url timeout:(NSTimeInterval)timeout completionHandler:(void (^)(NSArray *items, NSString *feedInfo, NSError *error))completionHandler;

@end
