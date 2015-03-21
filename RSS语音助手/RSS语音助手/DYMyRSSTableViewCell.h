//
//  DYMyRSSTableViewCell.h
//  RSS语音助手
//
//  Created by ss on 15/3/21.
//  Copyright (c) 2015年 iosnerds. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DYRSS;

@interface DYMyRSSTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;


-(void)setRSS:(DYRSS*)rss;


@end
