//
//  DYSettingViewController.m
//  订阅号助手
//
//  Created by 龚莎 on 15/1/30.
//  Copyright (c) 2015年 GSClock. All rights reserved.
//

#import "DYSettingViewController.h"
#import "SWRevealViewController.h"

@interface DYSettingViewController ()

@end

@implementation DYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
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
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

@end
