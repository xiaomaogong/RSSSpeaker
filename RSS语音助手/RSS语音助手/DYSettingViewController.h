//
//  DYSettingViewController.h
//  订阅号助手
//
//  Created by 龚莎 on 15/1/30.
//  Copyright (c) 2015年 GSClock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYSettingViewController : UITableViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *updateIntervalLabel;
@property (weak, nonatomic) IBOutlet UISlider *speakRateSlider;

- (IBAction)onStepperValueChanged:(id)sender;
- (IBAction)onSpeakRateChanged:(id)sender;

@end
