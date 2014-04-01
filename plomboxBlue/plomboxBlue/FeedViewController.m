//
//  FeedViewController.m
//  plomboxBlue
//
//  Created by dong chen on 2013-01-13.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import "FeedViewController.h"
#import "StoreInforViewController.h"
#import "GlobalData.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "SVPullToRefresh.h"
#import "UIScrollView+SVPullToRefresh.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAGradientLayer.h>

@interface FeedViewController (){
    NSMutableArray *feedList;
    NSMutableArray *feedOfferList;
    NSMutableArray *feedNewsList;
    NSMutableArray *feedResult;
    NSMutableArray *thumbs;
}

@end

@implementation FeedViewController


@synthesize feedOptionControl;
@synthesize feedTable;
@synthesize pass;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        feedOfferList = [GlobalData getFeedList];
        feedResult = feedOfferList;
        [feedTable reloadData];
        [feedTable.pullToRefreshView stopAnimating];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    thumbs = [NSMutableArray alloc];
    UIBarButtonItem *search = [[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem *sort = [[UIBarButtonItem alloc]initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.rightBarButtonItem = search;
    self.navigationItem.leftBarButtonItem = sort;
    
    [self getrefresh:YES];

    [[self feedTable]setDelegate:self];
    [[self feedTable]setDataSource:self];
    
}

-(void)getrefresh:(BOOL) reset
{
    if (feedOptionControl.selectedSegmentIndex == 0){
        if(reset || feedList == nil) {
            feedList = [[NSMutableArray alloc] init];
            PFQuery *allFeed = [PFQuery queryWithClassName:@"Feed"];
            [allFeed includeKey:@"Store"];
            [allFeed includeKey:@"firstTimeObject"];
            [allFeed includeKey:@"happyHourObject"];
            [allFeed includeKey:@"loyaltyObject"];
            [allFeed includeKey:@"newsObject"];
            [allFeed findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
                [feedList addObjectsFromArray:comments];
                feedResult = feedList;
                [feedTable reloadData];
                [feedTable.pullToRefreshView stopAnimating];
            }];
        } else {
            feedResult = feedList;
            [feedTable reloadData];
        }
    } else if (feedOptionControl.selectedSegmentIndex == 1){
        if (reset ||  feedOfferList == nil) {
            feedOfferList = [[NSMutableArray alloc]init];
            PFQuery *allOffers = [PFQuery queryWithClassName:@"Feed"];
            [allOffers whereKey:@"FeedType" greaterThan:[NSNumber numberWithInt:1]];
            [allOffers includeKey:@"Store"];
            [allOffers includeKey:@"firstTimeObject"];
            [allOffers includeKey:@"happyHourObject"];
            [allOffers includeKey:@"loyaltyObject"];
            [allOffers findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *  error) {
                [feedOfferList addObjectsFromArray:comments];
                feedResult = feedOfferList;
                [feedTable reloadData];
                [feedTable.pullToRefreshView stopAnimating];
            }];
        } else {
            feedResult = feedOfferList;
            [feedTable reloadData];
        }
    } else {
        if (reset ||  feedNewsList == nil) {
            feedNewsList = [[NSMutableArray alloc]init];
            PFQuery *allNews = [PFQuery queryWithClassName:@"Feed"];
            [allNews whereKey:@"FeedType" equalTo:[NSNumber numberWithInt:1]];
            [allNews includeKey:@"Store"];
            [allNews includeKey:@"newsObject"];
            [allNews findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
                [feedNewsList addObjectsFromArray:comments];
                feedResult = feedNewsList;
                [feedTable reloadData];
                [feedTable.pullToRefreshView stopAnimating];
            }];
        } else {
            feedResult = feedNewsList;
            [feedTable reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedAll:(id)sender {

}

- (IBAction)feedOptionsChange:(UISegmentedControl*)sender {
    [self getrefresh:NO];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [feedResult count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, [self tableView:tableView heightForRowAtIndexPath: indexPath]);
        gradient.colors = [NSArray arrayWithObjects:(id)[[[UIColor alloc] initWithRed:0.98 green:0.98 blue:0.98 alpha:1] CGColor], (id)[[[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor], nil];
        [cell.layer insertSublayer:gradient atIndex:0];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 75, 75)];
        UILabel *storeName = [[UILabel alloc] initWithFrame:CGRectMake(105, 5, 195, 20)];
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(105, 43, 195, 1)];
        UITextView *storeFeedDescription = [[UITextView alloc] initWithFrame:CGRectMake(98, 38, 200, 40)];
        
        imgView.tag = 1;
        storeName.tag = 2;
        separator.tag = 3;
        storeFeedDescription.tag = 4;
        
        [cell addSubview:storeName];
        [cell addSubview:separator];
        [cell addSubview:storeFeedDescription];
        [cell addSubview:imgView];
    }
    
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:1];
    UILabel *storeName = (UILabel*)[cell viewWithTag:2];
    UIView *separator = (UIView*)[cell viewWithTag:3];
    UITextView *storeFeedDescription = (UITextView*)[cell viewWithTag:4];
    
    PFObject *store = [[feedResult objectAtIndex:indexPath.row] objectForKey:@"Store"];
    NSNumber *feedType = [[NSNumber alloc] initWithInt:[[[feedResult objectAtIndex:indexPath.row] objectForKey:@"FeedType"] integerValue]];
    NSArray *feedObjectType = [[NSArray alloc] initWithObjects: @"", @"newsObject", @"happyHourObject", @"loyaltyObject", @"firstTimeObject", nil];
    PFObject *feedObject = [[feedResult objectAtIndex:indexPath.row] objectForKey:[feedObjectType objectAtIndex:[feedType intValue]]];
    
    PFFile *thumbnail = [store objectForKey:@"thumbNail"];
    if (!thumbnail.isDataAvailable)
    {
        [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error)
            {
                [feedTable reloadData];
            }
        }];
    } else {
        imgView.image = [UIImage imageWithData:[thumbnail getData]];
    }
    
    imgView.backgroundColor = [UIColor whiteColor];
    imgView.layer.masksToBounds = YES;
    imgView.layer.borderColor = [UIColor grayColor].CGColor;
    imgView.layer.borderWidth = 1;
    
    
    storeName.text = [store objectForKey:@"storeName"];
    storeName.textColor = [[UIColor alloc] initWithRed:0.55 green:0.20 blue:0.55 alpha:1];
    storeName.backgroundColor = [UIColor clearColor];
    
    separator.backgroundColor = [UIColor grayColor];
    
    storeFeedDescription.text = [feedObject objectForKey:@"description"];
    storeFeedDescription.scrollEnabled = false;
    storeFeedDescription.textColor = [UIColor grayColor];
    storeFeedDescription.backgroundColor = [UIColor clearColor];
    storeFeedDescription.font = [storeFeedDescription.font fontWithSize:12];
    storeFeedDescription.editable = false;
    storeFeedDescription.userInteractionEnabled = false;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreInforViewController * storeInforViewController = [[StoreInforViewController alloc] initWithNibName:@"StoreInforViewController" bundle:nil];
    storeInforViewController.hidesBottomBarWhenPushed = NO;
    storeInforViewController.currentStore = [[feedResult objectAtIndex:indexPath.row] objectForKey:@"Store"];
    [storeInforViewController initData];
    [self.navigationController pushViewController: storeInforViewController animated:YES];
}

@end
