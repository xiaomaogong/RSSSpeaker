#import <Foundation/Foundation.h>
#import <MWFeedParser/MWFeedParser.h>

@interface DYFeedParserWrapper : NSObject<MWFeedParserDelegate>

@property (assign) NSTimeInterval timeoutInterval;//请求超时时间（秒）

//尝试解析rss源，如果成功，返回源信息，否则返回nil
+ (void)parseUrl:(NSURL *)url timeout:(NSTimeInterval)timeout completion:(void (^)(NSArray *items, NSString *feedInfo, NSError *error))completionHandler;

@end
