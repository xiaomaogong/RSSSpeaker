//
//  DYMyRSSViewController.h
//  RSS语音助手
//
//  Created by ss on 15/3/21.
//  Copyright (c) 2015年 iosnerds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYMyRSSViewController : UITableViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
- (IBAction)addNewRss:(id)sender;

@end
