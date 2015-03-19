//
//  DYSongTableViewCell.m
//  订阅号助手
//
//  Created by 龚莎 on 2/1/15.
//  Copyright (c) 2015 GSClock. All rights reserved.
//

#import "DYSongTableViewCell.h"
#import "DYArticle.h"

@interface RedCircleView() {
}
@end

@implementation RedCircleView
    
- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 5.0);
    CGContextSetRGBFillColor(contextRef, 255.0, 0.0, 0.0, 1.0);
    CGContextSetRGBStrokeColor(contextRef, 255.0, 255.0, 255.0, 1.0);
    CGContextFillEllipseInRect(contextRef, rect);
    CGContextStrokeEllipseInRect(contextRef, rect);
}

@end


@interface ClearCircleView() {
}
@end

@implementation ClearCircleView

- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 5.0);// Set the border width
    CGContextSetRGBFillColor(contextRef, 255.0, 255.0, 255.0, 1.0);
    CGContextSetRGBStrokeColor(contextRef, 255.0, 255.0, 255.0, 1.0);
    CGContextFillEllipseInRect(contextRef, rect);
    CGContextStrokeEllipseInRect(contextRef, rect);
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
    CGRect positionFrame = CGRectMake(10,10,10,10);
    RedCircleView * circleView = [[RedCircleView alloc] initWithFrame:positionFrame];
    [self.contentView addSubview:circleView];
    self.isReaded = NO;
}

- (void)unsetRedDot {
    CGRect positionFrame = CGRectMake(10,10,10,10);
    ClearCircleView * circleView = [[ClearCircleView alloc] initWithFrame:positionFrame];
    [self.contentView addSubview:circleView];
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
        [goingImageView removeFromSuperview];
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
    [self->delegate cell:self didFavorOrNot:self.favorButton.tag];
}

- (IBAction)playSong:(id)sender {
    [self setPlayStatus:YES];
    [self unsetRedDot];
    [self->delegate cellDidPlaySong:self];
}

- (void)initImages {
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like_heart.png"]];
    [image setContentStretch:CGRectMake(0.5f, 0.5f, 0.f, 0.f)];
    CGRect frame = image.frame;
    frame.size.width -= 30;
    frame.size.height -= 20;
    image.frame = frame;
    self.likeImageView = image;
    
    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unlike_heart.png"]];
    [image setContentStretch:CGRectMake(0.5f, 0.5f, 0.f, 0.f)];
    frame = image.frame;
    frame.size.width -= 30;
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
    cell->delegate = delegate;
    [cell initImages];
    cell.identifier = article.identifier;
    [cell.songTitle setTitle:article.title forState:UIControlStateNormal];
    [cell setPlayStatus:NO];
    [cell setFavorStatus:[article.addToFavor intValue] > 0 ? YES : NO];
    if (NO == article.isReaded) {
        [cell setRedDot];
    } else {
        [cell unsetRedDot];
    }
    
    return cell;
}

- (void)stopSong {
    [self setPlayStatus:NO];
    [self->delegate cellDidStopSong:self];
}

@end
