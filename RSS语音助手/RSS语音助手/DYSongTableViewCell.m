//
//  DYSongTableViewCell.m
//  订阅号助手
//
//  Created by 龚莎 on 2/1/15.
//  Copyright (c) 2015 GSClock. All rights reserved.
//

#import "DYSongTableViewCell.h"
#import "DYArticle.h"
#import <UIKit/UIKit.h>

@interface RedCircleView() {
}
@end

@implementation RedCircleView
    
- (void)drawRect:(CGRect)rect {
    /*
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 5.0);
    CGContextSetRGBFillColor(contextRef, 255.0, 0.0, 0.0, 1.0);
    CGContextSetRGBStrokeColor(contextRef, 255.0, 255.0, 255.0, 1.0);
    CGContextFillEllipseInRect(contextRef, rect);
    CGContextStrokeEllipseInRect(contextRef, rect);
     */
}

@end


@interface ClearCircleView() {
}
@end

@implementation ClearCircleView

- (void)drawRect:(CGRect)rect {
    /*
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 5.0);// Set the border width
    CGContextSetRGBFillColor(contextRef, 255.0, 255.0, 255.0, 1.0);
    CGContextSetRGBStrokeColor(contextRef, 255.0, 255.0, 255.0, 1.0);
    CGContextFillEllipseInRect(contextRef, rect);
    CGContextStrokeEllipseInRect(contextRef, rect);
     */
}

@end

@interface DYSongTableViewCell()
{
    id<DYSongTableViewCellDelegate> delegate;
}
@end

@implementation DYSongTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setRedDot {
    /*
    CGRect positionFrame = CGRectMake(10,10,10,10);
    RedCircleView * circleView = [[RedCircleView alloc] initWithFrame:positionFrame];
    [self.contentView addSubview:circleView];
     */
    self.isReaded = NO;
}

- (void)unsetRedDot {
    /*
    CGRect positionFrame = CGRectMake(10,10,10,10);
    ClearCircleView * circleView = [[ClearCircleView alloc] initWithFrame:positionFrame];
    [self.contentView addSubview:circleView];
     */
    [self.titleButton.titleLabel setTextColor:[UIColor grayColor]];
    self.isReaded = YES;
}

- (void)setPlayStatus:(BOOL)playStatus {
    self.songPlayIcon.hidden = !playStatus;
    self.songPlayIcon.tag = playStatus;
}

- (void)setFavorStatus:(BOOL)favorStatus {
    self.favorButton.tag = favorStatus;
    UIImageView *comingImageView = nil
    , *goingImageView = nil;
    
    if (YES == favorStatus) {
        comingImageView = self.likeImageView;
        goingImageView = self.unlikeImageView;
    } else {
        comingImageView = self.unlikeImageView;
        goingImageView = self.likeImageView;
    }
    
    if ([self.favorButton.subviews count] == 0) {
        goingImageView = nil;
    } else {
//        [goingImageView removeFromSuperview];
        [[self.favorButton subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    }
    
    self.favorButton.frame = comingImageView.frame;
    //self.favorButton.center = CGPointMake(10, 10);
    [self.favorButton insertSubview:comingImageView atIndex:0];
}

- (void)changeFavorStatus {
    [self setFavorStatus:!self.favorButton.tag];
}

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)favorSong:(id)sender {
    [self changeFavorStatus];
    [self->delegate cellDidChangeFavorStatus:self];
}

- (IBAction)playSong:(id)sender {
    [self setPlayStatus:YES];
    [self unsetRedDot];
    [self->delegate cellDidChangePlayStatus:self];
}    

- (void)stopSong {
    [self setPlayStatus:NO];
    [self->delegate cellDidChangeStopStatus:self];
}

- (void)setStopStatus {
    [self setPlayStatus:NO];
}

- (void)initImages {
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like_heart.png"]];
    [image setContentStretch:CGRectMake(0.5f, 0.5f, 0.f, 0.f)];
    CGRect frame = image.frame;
    frame.size.width -= 20;
    frame.size.height -= 20;
    image.frame = frame;
    self.likeImageView = image;
    
    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unlike_heart.png"]];
    [image setContentStretch:CGRectMake(0.5f, 0.5f, 0.f, 0.f)];
    frame = image.frame;
    frame.size.width -= 20;
    frame.size.height -= 20;
    image.frame = frame;
    self.unlikeImageView = image;
}

+(instancetype) initWithDYArticle: (DYArticle*) article delegate:(id<DYSongTableViewCellDelegate>) delegate tableView:(UITableView*)tableView {
    static NSString *CellIdentifier = @"songCell";
    DYSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[DYSongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.titleButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    cell->delegate = delegate;
    [cell initImages];
    cell.identifier = article.url;
    [cell.songTitle setTitle:article.title forState:UIControlStateNormal];
    [cell setPlayStatus:NO];
    [cell setFavorStatus:[article.isFavor intValue] > 0 ? YES : NO];
    if (article.isReaded != nil && article.isReaded) {
        [cell unsetRedDot];
    } else {
      [cell setRedDot];
    }
    
    return cell;
}

@end
