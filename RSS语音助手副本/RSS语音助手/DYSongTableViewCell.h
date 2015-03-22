//
//  DYSongTableViewCell.h
//  订阅号助手
//
//  Created by 龚莎 on 2/1/15.
//  Copyright (c) 2015 GSClock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>

@class DYArticle;
@class DYSongTableViewCell;

@interface RedCircleView : UIView
@end

@interface ClearCircleView : UIView
@end

@protocol DYSongTableViewCellDelegate <NSObject>
- (void) cell:(DYSongTableViewCell*)cell didFavorOrNot:(BOOL)bFavor;
- (void) cellDidPlaySong:(DYSongTableViewCell *)cell;
- (void) cellDidStopSong:(DYSongTableViewCell *)cell;
@end

@interface DYSongTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *songTitle;
@property (weak, nonatomic) IBOutlet UIImageView *songPlayIcon;
@property (weak, nonatomic) IBOutlet UIButton *favorButton;
@property (nonatomic) NSInteger identifier;
@property (nonatomic) BOOL isReaded;
@property (retain, nonatomic) UIImageView *likeImageView, *unlikeImageView;

- (IBAction)playSong:(id)sender;
- (IBAction)favorSong:(id)sender;
- (void)stopSong;

+(instancetype) initWithDYArticle: (DYArticle*) article delegate:(id<DYSongTableViewCellDelegate>) delegate tableView:(UITableView*)tableView;

@end
