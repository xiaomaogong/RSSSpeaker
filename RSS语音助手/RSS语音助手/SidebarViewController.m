//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "DYBlurBackground.h"
#import "DYUtil.h"

@interface SidebarViewController ()
@property (nonatomic, strong) NSMutableDictionary *viewControllerCache;
@end

@implementation SidebarViewController {
    NSArray *menuItems;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundImage = [DYBlurBackground DYBackgroundView];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    menuItems = @[@"title", @"主页",@"我的RSS",@"我的收藏", @"设置",@"关于"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheViewControl:) name:@"Notification_cacheViewControl" object:nil];
}

-(void)cacheViewControl:(NSNotification*)notification{
    UIViewController* controller =  [notification object];
    // cache the view controller
    if(self.viewControllerCache == nil) self.viewControllerCache = [NSMutableDictionary dictionary];
    NSString *cacheKey = [@"mainView" stringByAppendingFormat:@":%@", nil];
    [self.viewControllerCache setObject:controller forKey:cacheKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row)
    {
        case 1:
            [self showViewControllerForSegueWithIdentifier:@"mainView" sender:nil];
            break;
        case 2:
            [self showViewControllerForSegueWithIdentifier:@"MyRSSView" sender:nil];
            break;
            
        case 3:
            [self showViewControllerForSegueWithIdentifier:@"myFavorView" sender:nil];
            break;
            
        case 4:
            [self showViewControllerForSegueWithIdentifier:@"SettingView" sender:nil];
            break;
            
        case 5:
            [self showViewControllerForSegueWithIdentifier:@"AboutView" sender:nil];
            break;
            
        default:
            break;
    }
    
}

- (void)showViewControllerForSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSString *cacheKey = [identifier stringByAppendingFormat:@":%@", sender];
    UIViewController *dvc = [self.viewControllerCache objectForKey:cacheKey];
    if(dvc)
    {
        NSLog(@"reusing view controller from cache");
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[dvc] animated: NO ];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
    else
    {
        NSLog(@"creating view controller from segue");
        [self performSegueWithIdentifier:identifier sender:sender];
    }
    
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [menuItems objectAtIndex:indexPath.row];
    
    // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"showSetting"]) {
        /*
         PhotoViewController *photoController = (PhotoViewController*)segue.destinationViewController;
         NSString *photoFilename = [NSString stringWithFormat:@"%@_photo.jpg", [menuItems objectAtIndex:indexPath.row]];
         photoController.photoFilename = photoFilename;
         */
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            // cache the view controller
            if(self.viewControllerCache == nil) self.viewControllerCache = [NSMutableDictionary dictionary];
            NSString *cacheKey = [segue.identifier stringByAppendingFormat:@":%@", sender];
            [self.viewControllerCache setObject:dvc forKey:cacheKey];
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}

#pragma marks private methods



//-(UIViewController*)getCacheUIViewControllerByKey:(NSString*)key{
//    if(self.viewControllerCache == nil)
//        self.viewControllerCache = [NSMutableDictionary dictionary];
//    return [self.viewControllerCache objectForKey:key];
//}
//
//-(void)setCacheUIViewControllers:(NSString*)key withController:(UIViewController*) controller{
//    if(self.viewControllerCache == nil)
//        self.viewControllerCache = [NSMutableDictionary dictionary];
//    
//    [self.viewControllerCache setObject:controller forKey:key];
//}



@end
