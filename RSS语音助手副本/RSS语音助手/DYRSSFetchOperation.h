#import <Foundation/Foundation.h>

@class MWFeedInfo;

@interface DYRSSFetchOperation : NSOperation

- (id) initWithURL:(NSURL *)url timeout:(NSTimeInterval)timeout completionHandler:(void (^)(NSArray *items))completionHandler;

- (id)initWithTryURL:(NSURL *)url timeout:(NSTimeInterval)timeout completionHandler:(void (^)(MWFeedInfo *items))completionHandler;

@end
