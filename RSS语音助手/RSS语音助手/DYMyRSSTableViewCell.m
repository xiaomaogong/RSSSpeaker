//
//  DYMyRSSTableViewCell.m
//  RSS语音助手
//
//  Created by ss on 15/3/21.
//  Copyright (c) 2015年 iosnerds. All rights reserved.
//

#import "DYMyRSSTableViewCell.h"
#import "DYRSS.h"

@implementation DYMyRSSTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRSS:(DYRSS*)rss{
    if (rss) {
        self.lbTitle.text = rss.title;
    }
}

@end
