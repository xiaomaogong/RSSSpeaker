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

/// 文章状态delegate
@protocol DYSongTableViewCellDelegate <NSObject>
@optional
// 喜爱歌曲状态
- (void) cellDidChangeFavorStatus:(DYSongTableViewCell*)cell;
// 取消喜爱状态
- (void) cellDidChangeUnfavorStatus:(DYSongTableViewCell *)cell;
// 播放状态
- (void) cellDidChangePlayStatus:(DYSongTableViewCell *)cell;
// 停止状态
- (void) cellDidChangeStopStatus:(DYSongTableViewCell *)cell;
@end

@interface DYSongTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *songTitle;
@property (weak, nonatomic) IBOutlet UIImageView *songPlayIcon;
@property (weak, nonatomic) IBOutlet UIButton *favorButton;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (nonatomic) NSString* identifier;
@property (nonatomic) BOOL isReaded;
@property (retain, nonatomic) UIImageView *likeImageView, *unlikeImageView;

- (IBAction)playSong:(id)sender;
- (IBAction)favorSong:(id)sender;
- (void)stopSong;

- (void)setStopStatus;

+(instancetype) initWithDYArticle: (DYArticle*) article delegate:(id<DYSongTableViewCellDelegate>) delegate tableView:(UITableView*)tableView;

@end
