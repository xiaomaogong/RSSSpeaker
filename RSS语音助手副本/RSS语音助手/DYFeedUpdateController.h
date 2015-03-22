#import <Foundation/Foundation.h>

@interface DYFeedUpdateController : NSObject

+(void)start;

+(void)setUpdateCheckTimeInterval:(NSTimeInterval)timeInterval;

+(void)stop;

+(void)invalidateRSSList;

@end
