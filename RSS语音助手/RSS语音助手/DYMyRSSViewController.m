//
//  DYMyRSSViewController.m
//  RSS语音助手
//
//  Created by ss on 15/3/21.
//  Copyright (c) 2015年 iosnerds. All rights reserved.
//

#import "DYMyRSSViewController.h"
#import "SWRevealViewController.h"
#import "DYMyRSSTableViewCell.h"
#import "AppDelegate.h"
#import "DYRSS.h"

@interface DYMyRSSViewController ()

@end

@implementation DYMyRSSViewController

{
    NSMutableArray* rssArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSWSegues];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    rssArr = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [rssArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"rssCellIdentifier";
    DYMyRSSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[DYMyRSSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setRSS:rssArr[indexPath.row]];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark SetUp SW Segues
-(void)setupSWSegues{
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (IBAction)addNewRss:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"添加RSS" message:@"请输入RSS源地址：" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString* url = [alertView textFieldAtIndex:0].text;
    
    if ([url length] != 0 && buttonIndex == [alertView firstOtherButtonIndex]) {
        NSManagedObjectContext* context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        
        DYRSS* rss = [NSEntityDescription insertNewObjectForEntityForName:@"DYRSS" inManagedObjectContext:context];
        rss.title = url;
        NSError * err;
        [context save:&err];
        if (!err) {
            [rssArr addObject:rss];
            [self.tableView reloadData];
        }else{
            NSLog(@"Fail to insert RSS with error %@",err.description);
        }
    }
}
@end
