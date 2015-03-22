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
//#import "DYIURLParser.h"
#import "DYSongTableViewCell.h"
#import "DYPlayer.h"

#define INPUT_WEBPATH_SAVE      0
#define INPUT_WEBPATh_CANCEL    1

@interface ViewController ()
@end

@implementation ViewController
{
//    DYIURLParser* parser;
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
        if ([dal isSameDayCompareToLastUpdatedTime]) {
            self.songs = [NSMutableArray arrayWithArray:[dal getAllArticles]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else
        {
            [dal deleteAllArticles];
        }
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

- (IBAction)outputFavirateSongs:(id)sender {
}

- (IBAction)locatePositionOfSong:(id)sender {
    int index = (int)self.slider.value;
    NSLog(@"UISlider Locate at %i" ,index);
    [player play:index];
}

- (IBAction)playSong:(id)sender {
    UIButton* bt = sender;
    if(bt.imageView.tag == 1)
    {
        bt.imageView.tag = 0;
        [bt.imageView setImage: [UIImage imageNamed:@"stop.png"]];
        [player play];
    }else
    {
        bt.imageView.tag = 1;
        [bt.imageView setImage: [UIImage imageNamed:@"play.png"]];
        [player stop];
    }

}

- (IBAction)playPreviousSong:(id)sender {
    if (self.slider.value >= 1) {
        DYArticle* a = self.songs[(int)(self.slider.value -1)];
        [self playArticle:a];
    }
}

- (IBAction)playNextSong:(id)sender {
    if (self.slider.value < self.songs.count - 1) {
        DYArticle* a = self.songs[(int)(self.slider.value + 1)];
        [self playArticle:a];
    }
}

- (void) cell:(DYSongTableViewCell*)cell didFavorOrNot:(BOOL)bFavor {
    
}



- (void) cellDidPlaySong:(DYSongTableViewCell *)cell {
    if (nil != cell) {
        [playingCell stopSong];
    }
    playingCell = cell;
    
    DYArticle * a = [self getArticalByIdentify:playingCell.identifier];
    if(a != nil)
    {
        [self playArticle:a];
    }
}

-(DYArticle*)getArticalByIdentify:(NSString*)indentifier{
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

- (void) cellDidStopSong:(DYSongTableViewCell *)cell {
    playingCell = nil;
    
    /// TODO:Need Play API
   
}

#pragma DYPlayerDelegate

-(void)player:(DYPlayer *)player willPlayNextContent:(NSString *)content{
    NSLog(@"Will play : %@", content);
    self.slider.value = self.slider.value + 1;
}

-(void)playerDidFinishedPlayContent:(DYPlayer *)player{
    
    NSLog(@"Finished read current artical!");
}

#pragma mark Private Methods

- (void)playArticle:(DYArticle *)a {
    NSArray* arr =[a.content componentsSeparatedByString:@"\n"];
    [player setCurrentData:arr];
    self.slider.value = 0.0;
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = arr.count;
    [player play];
}

@end
