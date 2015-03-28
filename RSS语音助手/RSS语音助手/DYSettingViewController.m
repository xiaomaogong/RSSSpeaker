//
//  DYSettingViewController.m
//  订阅号助手
//
//  Created by 龚莎 on 15/1/30.
//  Copyright (c) 2015年 GSClock. All rights reserved.
//

#import "DYSettingViewController.h"
#import "SWRevealViewController.h"
#import "DYPreferences.h"
#import "DYBlurBackground.h"
#import <UIKit/UIKit.h>

@interface DYSettingViewController ()

@end

@implementation DYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.updateIntervalLabel.text = [NSString stringWithFormat:@"%02ld", (NSInteger)([DYPreferences sharedInstance].updateInterval)/60];
    self.speakRateSlider.value = [DYPreferences sharedInstance].voiceRate;
    UIImageView *backgroundImage = [DYBlurBackground DYBackgroundView];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    [self setupSWSegues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma SetUp SW Segues
-(void)setupSWSegues{
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.tableView addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.panGestureRecognizer.delegate = self;
}

- (IBAction)onStepperValueChanged:(id)sender {
    UIStepper *stepper = (UIStepper*)sender;
    [DYPreferences sharedInstance].updateInterval = stepper.value*60;
    self.updateIntervalLabel.text = [NSString stringWithFormat:@"%02ld", (NSInteger)([DYPreferences sharedInstance].updateInterval)/60];
}

- (IBAction)onSpeakRateChanged:(id)sender {
    [DYPreferences sharedInstance].voiceRate = self.speakRateSlider.value;
}

#pragma marks
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass: [UISlider class]] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
