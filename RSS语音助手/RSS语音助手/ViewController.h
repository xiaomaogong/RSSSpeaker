//
//  ViewController.h
//  订阅号助手
//
//  Created by 龚莎 on 15/1/14.
//  Copyright (c) 2015年 GSClock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYSongTableViewCell.h"
#import "DYPlayer.h"

@interface ViewController : UIViewController< DYSongTableViewCellDelegate, DYPlayerDelegate ,UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property(nonatomic, strong) NSMutableArray *songs;

@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)addASong:(id)sender;

- (IBAction)outputFavirateSongs:(id)sender;

- (IBAction)locatePositionOfSong:(id)sender;

- (IBAction)playSong:(id)sender;

- (IBAction)playPreviousSong:(id)sender;

- (IBAction)playNextSong:(id)sender;

@end

