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
    UITableView* tv;
    DYSongTableViewCell* playingCell;
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
    
//    parser = [DYIURLParser defaultInstance];
    player = [DYPlayer defaultInstance];
    [player setDelegate:self];
    
    self.songs = [NSMutableArray array];
    self->playingCell = nil;
    [self loadSongs];
}

- (void)loadSongs
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 1;
    if (tv == nil) {
        tv = tableView;
    }
    return [self.songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#if 1
    DYSongTableViewCell *cell = [DYSongTableViewCell initWithDYArticle:self.songs[indexPath.row] delegate:self tableView:tableView];
#endif
    
#if 0
    DYSongTableViewCell *cell = [DYSongTableViewCell initWithDYArticle:nil delegate:self tableView:tableView];
#endif
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.songs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (IBAction)addASong:(id)sender {
}

- (IBAction)outputFavirateSongs:(id)sender {
}

- (IBAction)locatePositionOfSong:(id)sender {
    int index = (int)self.slider.value;
    NSLog(@"UISlider Locate at %i" ,index);
    [player play:index];
}

- (IBAction)playSong:(id)sender {
    [player play];
}

- (IBAction)playPreviousSong:(id)sender {
    [player playPrevious];
}

- (IBAction)playNextSong:(id)sender {
    [player playNext];
}

- (IBAction)lauchDialog:(id)sender {
    // Here we need to pass a full frame
//    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
//    [alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters
//    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Save", @"Cancel", nil]];
//    [alertView setDelegate:self];
    
    
//    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
//    [alertView show];
}


- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    NSInteger titleHeight = 30;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 270, titleHeight)];
    [title setText:@"输入WEB地址"];
    title.textAlignment = UITextAlignmentCenter;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10+titleHeight, 270, 170)];
    [demoView addSubview:title];
    [demoView addSubview:textView];
    
    return demoView;
}

- (void) cell:(DYSongTableViewCell*)cell didFavorOrNot:(BOOL)bFavor {
    
}

- (void) cellDidPlaySong:(DYSongTableViewCell *)cell {
    if (nil != cell) {
        [playingCell stopSong];
    }
    playingCell = cell;
    
    /// TODO:Need Play API
    DYArticle * a = [self getArticalByIdentify:playingCell.identifier];
    if(a != nil)
    {
//        [player setCurrentData:a.arrcontent];
        self.slider.minimumValue = 0.0;
//        self.slider.maximumValue = a.count;
        [player play];
    }
}

-(DYArticle*)getArticalByIdentify:(long)indentifier{
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
}

-(void)playerDidFinishedPlayContent:(DYPlayer *)player{
    
    NSLog(@"Finished read current artical!");
}

@end
