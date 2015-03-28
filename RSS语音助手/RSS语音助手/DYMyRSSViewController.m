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
#import "DYFeedParserWrapper.h"
#import "DYUtil.h"
#import "DYRSSDAL.h"
#import "DYArticle.h"
#import "DYConverter.h"
#import "DYBlurBackground.h"
#import "DYRSSDAL.h"

@interface DYMyRSSViewController ()

@end

@implementation DYMyRSSViewController

{
    NSMutableArray* rssArr;
    DYRSSDAL* dal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dal = [DYRSSDAL new];
    
    UIImageView *backgroundImage = [DYBlurBackground DYBackgroundView];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [self setupSWSegues];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    rssArr = [NSMutableArray new];
    
    [self loadRSS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadRSS{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        rssArr = [NSMutableArray arrayWithArray:[dal fetchAllRSS]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    });

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
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [dal removeRSS:((DYRSS*)rssArr[indexPath.row]).sourceUrl withContext:[DYUtil getPrivateManagedObjectContext]];
        [self loadRSS];
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
        [DYFeedParserWrapper parseUrl:[NSURL URLWithString:url] timeout:30 completion:^(NSArray *items, NSString *feedInfo, NSError *error) {
            if (error) {
                /// TODO:UI show this error
                NSLog(@"Fail to parse feed.Error:%@.FeedUrl:%@.", error, url);
            } else {
                NSManagedObjectContext *pmoc = [DYUtil getPrivateManagedObjectContext];
                DYRSS *addRSS = [NSEntityDescription insertNewObjectForEntityForName:@"DYRSS" inManagedObjectContext:pmoc];
                addRSS.title = feedInfo ? feedInfo : url;
                addRSS.sourceUrl = url;
                addRSS.lastUpdateTime = [NSDate date];
                
                DYRSSDAL *rssDal = [[DYRSSDAL alloc] init];
                rssDal.delegate = (id)self;
                NSMutableSet *articles = [[NSMutableSet alloc] init];
                for (MWFeedItem *item in items) {
                    if ([DYUtil compareYMD:item.date latter:[DYUtil convertYMD:[NSDate date]]] < 0) {
                        // 过滤掉小于今天的article
                        [articles addObject:[DYConverter convertFromFeedItem:item context:pmoc]];
                    }
                }
                [rssDal insertRSS:addRSS withArticles:articles withContext:pmoc
                       success:^ {
                           [self->rssArr addObject:addRSS];
                           [self.tableView reloadData];
                       }
                       fail:^(NSString *error) {
                           /// TODO:UI show this error
                           NSLog(@"Fail to parse feed.Error:%@.FeedUrl:%@.", error, url);
                       }
                ];
                
            }
        }];
    }
}
@end
