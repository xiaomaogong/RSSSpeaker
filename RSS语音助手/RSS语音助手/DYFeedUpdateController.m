#import "DYFeedUpdateController.h"
#import "DYFeedParserWrapper.h"
#import "DYGetFetchedRecordsModel.h"
#import "NSManagedObjectContext+PrivateContext.h"
#import "DYRSS.h"
#import "DYRSSDAL.h"
#import "DYUtil.h"

@interface DYFeedUpdateController() <DYRSSDALDelegate>

@property (assign, nonatomic) NSTimeInterval updateCheckTimeInterval;
@property (strong, nonatomic) dispatch_source_t dispatchSource;
@property (strong, nonatomic) dispatch_queue_t dispatchQueue;
@property (copy, nonatomic) NSArray *sourceList;
@property (assign, nonatomic) BOOL stopped;
@property (assign, nonatomic) BOOL started;

@end

@implementation DYFeedUpdateController

static DYFeedUpdateController *sharedInstance;

- (instancetype)init{
    if(self = [super init]){
        //默认每30秒检查一次更新
        _updateCheckTimeInterval = 30;
        
        _dispatchQueue = dispatch_queue_create("SM parser queue", DISPATCH_QUEUE_SERIAL);
        _dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _dispatchQueue);
        dispatch_source_set_timer(_dispatchSource, DISPATCH_TIME_NOW, _updateCheckTimeInterval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_dispatchSource, ^{
            [self doUpdateJob];
        });
        
    }
    return self;
}

- (void)dealloc{
    if(_started && !_stopped){
        dispatch_suspend(_dispatchSource);
    }
    
    self.dispatchSource = nil;
    self.dispatchQueue = nil;
}

- (void)doUpdateJob{
    @synchronized(_sourceList) {
    
        NSManagedObjectContext *privateContext = [DYUtil getPrivateManagedObjectContext];
        
    if(!_sourceList) {
        _sourceList = nil;
        DYGetFetchedRecordsModel *getModel = [[DYGetFetchedRecordsModel alloc] init];
        getModel.entityName = @"DYRSS";
        getModel.sortName = @"total";
        /// TODO2:
        _sourceList = [APP_DELEGATE fetchRecordsWithPrivateContext:getModel privateContext:privateContext];
    }
        
    [_sourceList enumerateObjectsUsingBlock:^(DYRSS *rss, NSUInteger idx, BOOL *stop) {
        /// TODO:
        NSDate *lastUpdateDate = rss.lastUpdateTime;
        //NSNumber *sourceUpdatInterval = subscribe.updateTimeInterval;
        NSNumber *sourceUpdatInterval;
        NSTimeInterval intUpdate = [sourceUpdatInterval doubleValue];
        
        if(-[lastUpdateDate timeIntervalSinceNow]>intUpdate){
            [DYFeedParserWrapper parseUrl:[NSURL URLWithString:rss.sourceUrl] timeout:10 completion:^(NSArray *items) {
                NSManagedObjectContext *pmoc = [DYUtil getPrivateManagedObjectContext];
                DYRSSDAL *rssDal = [[DYRSSDAL alloc] init];
                rssDal.delegate = (id)self;
                [rssDal insertArticlesWithFeedItems:items withFeedUrlStr:rss.sourceUrl withContext:pmoc];
            }];
            
            DYGetFetchedRecordsModel *getModel = [[DYGetFetchedRecordsModel alloc] init];
            getModel.entityName = @"DYRSS";
            getModel.predicate = [NSPredicate predicateWithFormat:@"url=%@",rss.sourceUrl];
            NSArray *fetchedResults = [APP_DELEGATE fetchRecordsWithPrivateContext:getModel privateContext:privateContext];
            if(fetchedResults.count>0){
                DYRSS *aSubscribe = fetchedResults[0];
                aSubscribe.lastUpdateTime = [NSDate date];
            }
        }
    }];
    NSError *error;
    [privateContext save:&error];
    }
}

- (void)setUpdateCheckTimeInterval:(NSTimeInterval)updateCheckTimeInterval{
    if(_updateCheckTimeInterval != updateCheckTimeInterval){
        _updateCheckTimeInterval = updateCheckTimeInterval;
        dispatch_source_set_timer(_dispatchSource, DISPATCH_TIME_NOW, _updateCheckTimeInterval * NSEC_PER_SEC, 0);
    }
}
- (void)invalidateSourceList{
    @synchronized(_sourceList){
    _sourceList = nil;
    }
}

- (void)startUpdate{
    dispatch_resume(_dispatchSource);
    _started = YES;
}

- (void)stopUpdate{
    dispatch_suspend(_dispatchSource);
    _stopped = YES;
}

#pragma mark - class methods
+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

+ (void)start{
    [[[self class] sharedInstance] startUpdate];
}

+ (void)stop{
    [[[self class] sharedInstance] stopUpdate];
}

+ (void)setUpdateCheckTimeInterval:(NSTimeInterval)timeInterval{
    [[self sharedInstance] setUpdateCheckTimeInterval:timeInterval];
}

+ (void)invalidateRSSList{
    [[self sharedInstance] invalidateRSSList];
}

#pragma mark - DYRSSDALDelegate

- (void)articlesDidInsert {
    //通知文章变化事件
    [[NSNotificationCenter defaultCenter] postNotificationName:ARTICLES_CHANGE
                                                        object:nil];
}

@end
