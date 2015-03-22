#import "DYFeedParserWrapper.h"
#import "DYRSSFetchOperation.h"

#define MAX_NUM_OF_QUEUES 5

@interface DYFeedParserWrapper()

@property (copy, nonatomic) void (^completionHandler)(NSArray *);
@property (strong, nonatomic) NSMutableArray *feedItemArr;
@property (strong, nonatomic) dispatch_source_t timer;
@property (strong, nonatomic) dispatch_queue_t timerQueue;
@property (assign, nonatomic) BOOL isTimeout;
@property (strong, nonatomic) NSMutableArray *queueArr;//队列池

@end

static DYFeedParserWrapper *sharedInstance;

@implementation DYFeedParserWrapper

- (instancetype)init{
    if(self = [super init]){
        _feedItemArr = [NSMutableArray new];
        _timeoutInterval = 10.0;//默认超时时间10秒
        _isTimeout = NO;
        
        _queueArr = [[NSMutableArray alloc] initWithCapacity:MAX_NUM_OF_QUEUES];
        for(int i=0;i<MAX_NUM_OF_QUEUES;++i){
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [_queueArr addObject:queue];
        }
    }
    return self;
}

+ (void)parseUrl:(NSURL *)url timeout:(NSTimeInterval)timeout completion:(void (^)(NSArray *items, NSString *feedInfo, NSError *error))completionHandler
{
    DYRSSFetchOperation *operation = [[DYRSSFetchOperation alloc] initWithURL:url timeout:timeout completionHandler:completionHandler];
    NSOperationQueue *queue = [[[self sharedInstance] queueArr] objectAtIndex:rand()%MAX_NUM_OF_QUEUES];
    [queue addOperation:operation];
}

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DYFeedParserWrapper alloc] init];
    });
    return sharedInstance;
}
@end
