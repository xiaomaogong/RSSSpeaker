#import "DYRSSFetchOperation.h"
#import <MWFeedParser/MWFeedParser.h>

#ifndef DEBUG
#undef PARSER_LOG
#endif

@interface DYRSSFetchOperation()<MWFeedParserDelegate>

@property (assign, nonatomic) NSTimeInterval timeout;
@property (copy, nonatomic) NSURL *url;
@property (copy, nonatomic) void (^completionHandler)(NSArray *items, NSString *feedInfo, NSError *error);
@property (assign) BOOL isTimeout;
@property (assign) BOOL fetchFinished;
@property (nonatomic, retain)MWFeedParser *feedParser;
@property (nonatomic, retain) NSMutableArray *fetchedFeeds;
@property (nonatomic, retain) NSString *feedInfo;
@property (nonatomic, retain) NSTimer *timer;

@end

@implementation DYRSSFetchOperation

- (id) initWithURL:(NSURL *)url timeout:(NSTimeInterval)timeout completionHandler:(void (^)(NSArray *items, NSString *feedInfo, NSError *error))completionHandler
{
    if(self = [super init]){
        _completionHandler = completionHandler;
        
        _fetchedFeeds = [NSMutableArray array];
        
        _feedParser = [[MWFeedParser alloc]initWithFeedURL:url];
        _feedParser.delegate = self;
        _feedParser.feedParseType = ParseTypeFull;
        _feedParser.connectionType = ConnectionTypeSynchronously;//采用同步方式发送请求
       
        _isTimeout = NO;
        _fetchFinished = NO;
        _url = url;
        _timeout = timeout;
        _timer = [NSTimer timerWithTimeInterval:timeout target:self selector:@selector(parserTimeout) userInfo:nil repeats:NO];
    }
    return self;
}

- (void)dealloc
{
    self.timer = nil;
    self.feedParser = nil;
    self.fetchedFeeds = nil;
    self.completionHandler = nil;
    self.url = nil;
#ifdef PARSER_LOG
    NSLog(@"queue dealloc");
#endif
}

- (void)start{
#ifdef PARSER_LOG
    NSLog(@"queue start");
#endif

    //必须添加到mainRunLoop中，否则不会其作用，因为线程被[_feedParser parse]阻塞（采用同步方式发送请求）
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [super start];
}

- (void)main{
#ifdef PARSER_LOG
    NSLog(@"queue main");
#endif
    
    [_feedParser parse];
}

- (BOOL)isFinished {
    if(_isTimeout||_fetchFinished){
        return YES;
    }
    return NO;
}

- (void)parserTimeout{
    if(_fetchFinished){
        return;
    }
    
    //willChange和didChange必须配合使用
    [self willChangeValueForKey:@"isFinished"];
    
    _isTimeout = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.completionHandler){
            self.completionHandler(self.fetchedFeeds, _feedInfo, nil);
        }
    });
#ifdef PARSER_LOG
    NSLog(@"queue timeout");
#endif
    [self didChangeValueForKey:@"isFinished"];
}

#pragma mark - MWFeedParser Delegate

-(void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    [self willChangeValueForKey:@"isFinished"];
    _fetchFinished = YES;
    _feedInfo = info.title;
    [self didChangeValueForKey:@"isFinished"];
}

-(void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    [self.fetchedFeeds addObject:item];
}

-(void)feedParserDidFinish:(MWFeedParser *)parser {
    if(_isTimeout){
        return;
    }
    
    [self willChangeValueForKey:@"isFinished"];
    _fetchFinished = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.completionHandler){
            self.completionHandler(self.fetchedFeeds, self.feedInfo, nil);
        }
    });
    [self didChangeValueForKey:@"isFinished"];
#ifdef PARSER_LOG
    NSLog(@"queue finish");
#endif
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    if(_isTimeout){
        return;
    }
    
    [self willChangeValueForKey:@"isFinished"];
    _fetchFinished = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.completionHandler){
            self.completionHandler(nil, _feedInfo, error);
        }
    });
    [self didChangeValueForKey:@"isFinished"];
#ifdef PARSER_LOG
    NSLog(@"queue finish");
#endif
}

@end
