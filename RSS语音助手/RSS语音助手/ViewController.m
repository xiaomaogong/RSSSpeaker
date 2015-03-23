//
//  ViewController.m
//  订阅号助手
//
//  Created by 龚莎 on 15/1/14.
//  Copyright (c) 2015年 GSClock. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
#import "DYArticle.h"
#import "DYRSSDAL.h"
#import "DYArticle.h"
#import "DYSongTableViewCell.h"
#import "DYPlayer.h"
#import "DYRSSDAL.h"
#import "DYUtil.h"
#import "DYGetFetchedRecordsModel.h"

#define INPUT_WEBPATH_SAVE      0
#define INPUT_WEBPATh_CANCEL    1

#define STOP_FLAG               0
#define PLAY_FLAG               1

@interface ViewController ()
@end

@implementation ViewController
{
    DYPlayer* player;
    DYSongTableViewCell* playingCell;
    DYRSSDAL* dal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    player = [DYPlayer defaultInstance];
    [player setDelegate:self];
    
    self.songs = [NSMutableArray array];
    self->playingCell = nil;
    dal = [DYRSSDAL new];
    [self loadSongs];
}

- (void)loadSongs
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self clearHistoryArticles];
        self.songs = [NSMutableArray arrayWithArray:[self fetchAllArticles]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DYSongTableViewCell *cell = [DYSongTableViewCell initWithDYArticle:self.songs[indexPath.row] delegate:self tableView:tableView];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (IBAction)locatePositionOfSong:(id)sender {
    int index = (int)self.slider.value;
    NSLog(@"UISlider Locate at %i" ,index);
    [player play:index];
}

- (IBAction)playSong:(id)sender {
    UIButton* bt = self.playButton;
    if(bt.imageView.tag == STOP_FLAG)
    {
        bt.imageView.tag = PLAY_FLAG;
        [bt setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
        [self.view reloadInputViews];
        [player resume];
    }else
    {
        bt.imageView.tag = STOP_FLAG;
        //[bt.imageView setImage: [UIImage imageNamed:@"play.png"]];
        [bt setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [player pause];
    }
}

- (IBAction)playPreviousSong:(id)sender {
//    if (playingCell != nil) {
//        [playingCell stopSong];
//    }
    
    NSInteger playingIndex = playingCell ? [self getIndexOfArticleInSongs:[self getArticalByIdentify:playingCell.identifier]]: 0;
    if(playingIndex >= 1)
    {
        NSInteger previousRow = playingIndex - 1;
        DYSongTableViewCell* willPlaingCell = (DYSongTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:previousRow inSection:0]];
        [willPlaingCell playSong:nil];
    }
}

- (IBAction)playNextSong:(id)sender {
    NSInteger playingIndex = playingCell ? [self getIndexOfArticleInSongs:[self getArticalByIdentify:playingCell.identifier]]: 0;
    if(playingIndex < self.songs.count - 1)
    {
        NSInteger nextRow = playingIndex + 1;
        DYSongTableViewCell* willPlaingCell = (DYSongTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nextRow inSection:0]];
        [willPlaingCell playSong:nil];
    }
}

#pragma DYSongTableViewCellDelegate

// 喜爱歌曲状态
- (void) cellDidChangeFavorStatus:(DYSongTableViewCell*)cell {
    DYArticle * aArticle = [self getArticalByIdentify:cell.identifier];
    if(aArticle != nil) {
        DYRSSDAL *rssDal = [[DYRSSDAL alloc] init];
        [rssDal likeArticle:aArticle withContext:[DYUtil getPrivateManagedObjectContext]];
    }
}

// 取消喜爱状态
- (void) cellDidChangeUnfavorStatus:(DYSongTableViewCell *)cell {
    DYArticle * aArticle = [self getArticalByIdentify:playingCell.identifier];
    if(aArticle != nil) {
        DYRSSDAL *rssDal = [[DYRSSDAL alloc] init];
        [rssDal dislikeArticle:aArticle withContext:[DYUtil getPrivateManagedObjectContext]];
    }
}

// 播放状态
- (void) cellDidChangePlayStatus:(DYSongTableViewCell *)cell {
    if (nil != cell) {
        [playingCell stopSong];
    }
    playingCell = cell;
    DYArticle * a = [self getArticalByIdentify:playingCell.identifier];
    if(a != nil)
    {
        if (a.isReaded == 0) {
            DYRSSDAL *rssDal = [[DYRSSDAL alloc] init];
            [rssDal markAsRead:a withContext:[DYUtil getPrivateManagedObjectContext]];
        }
        [self playArticle:a];
    }
}

// 停止状态
- (void) cellDidChangeStopStatus:(DYSongTableViewCell *)cell {
    playingCell = nil;
    [player stop];
    //Sleep for a while
    [NSThread sleepForTimeInterval:0.5];
}

#pragma DYPlayerDelegate

- (void) player:(DYPlayer*)player didCompleteProgress:(double)progress {
    self.slider.value = progress;
    if (progress >= 1.0) {
        [playingCell setStopStatus];
        [self playNextSong:nil];
    }
//    NSLog(@"Play progress:%f", progress);
}

#pragma mark Private Methods

- (void)playArticle:(DYArticle *)a {
    
    NSLog(@"Start to play article %@",a.title);
    
    self.playButton.imageView.tag = PLAY_FLAG;
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
    
    NSArray* arr =[a.content componentsSeparatedByString:@"\n"];
    [player setCurrentData:arr];
    self.slider.value = 0.0;
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = 1.0;
    [player play];
}

- (DYArticle*)getArticalByIdentify:(NSString*)indentifier{
    DYArticle* result = nil;
    if(self.songs != nil){
        NSInteger index =  [self.songs indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if (((DYArticle *)obj).url == indentifier) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        result = self.songs[index];
    }
    return  result;
}

-(NSInteger)getIndexOfArticleInSongs:(DYArticle*)article{
    for (int i = 0; i < self.songs.count; i++) {
        if (self.songs[i] == article) {
            return i;
        }
    }
    
    return -1;
}

- (void)clearHistoryArticles {
    NSDate *today = [NSDate date];
    DYGetFetchedRecordsModel *getModel = [[DYGetFetchedRecordsModel alloc] init];
    getModel.entityName = @"DYArticle";
    getModel.predicate = [NSPredicate predicateWithFormat:@"createdDate<%@",today];
    NSManagedObjectContext *privateContext = [DYUtil getPrivateManagedObjectContext];
    NSArray *fetchedResults = [APP_DELEGATE fetchRecordsWithPrivateContext:getModel privateContext:privateContext];
    for (DYArticle *aArticle in fetchedResults) {
        [privateContext delete:aArticle];
    }
    NSError *error;
    [privateContext save:&error];
}

- (NSArray*)fetchAllArticles {
    DYGetFetchedRecordsModel *getModel = [[DYGetFetchedRecordsModel
                                           alloc] init];
    getModel.entityName = @"DYArticle";
    NSArray* fetchedResults = [APP_DELEGATE fetchRecordsWithPrivateContext:getModel privateContext:[DYUtil getPrivateManagedObjectContext]];
    return fetchedResults;
}
@end
