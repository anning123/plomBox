//
//  StoreOfferViewController.m
//  plomboxBlue
//
//  Created by dong chen on 2013-01-18.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import "StoreInforViewController.h"
#import "StoreOfferViewController.h"
#import "StoreNewsViewController.h"
#import "StoreViewController.h"
#import "RedemptionViewController.h"
#import "GlobalData.h"
#import <Parse/Parse.h>
#import <QuartzCore/CAGradientLayer.h>

@interface StoreOfferViewController () {
    NSMutableArray *userFeedList;
    PFObject* feedLoyaltyCampaign;
    PFObject* userLoyaltyCampgain;
    PFObject* feedFirstTimeCampaign;
}

@end

@implementation StoreOfferViewController

@synthesize currentStore;
@synthesize mainController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self offerTable] setDelegate:self];
    [[self offerTable] setDataSource:self];
}

- (void)refreshData
{
    [[self offerTable] reloadData];
}

- (void)initData
{
    
    if (currentStore == NULL)
        return;
    
    userFeedList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[GlobalData getFeedList] count]; i++) {
        PFObject* feed = [[GlobalData getFeedList] objectAtIndex:i];
        PFObject* store = [feed objectForKey:@"Store"];
        if ([[feed objectForKey:@"FeedType"] intValue] == 4 && [store.objectId isEqualToString:currentStore.objectId]) {
            [userFeedList addObject:[[GlobalData getFeedList] objectAtIndex:i]];
            i = [[GlobalData getFeedList] count];
        }
    }
    
    for (int i = 0; i < [[GlobalData getFeedList] count]; i++) {
        PFObject* feed = [[GlobalData getFeedList] objectAtIndex:i];
        PFObject* store = [feed objectForKey:@"Store"];
        if ([[feed objectForKey:@"FeedType"] intValue] == 3 && [store.objectId isEqualToString:currentStore.objectId]) {
            [userFeedList addObject:[[GlobalData getFeedList] objectAtIndex:i]];
            i = [[GlobalData getFeedList] count];
        }
    }
    
    for (int i = 0; i < [[GlobalData getFeedList] count]; i++) {
        PFObject* feed = [[GlobalData getFeedList] objectAtIndex:i];
        PFObject* store = [feed objectForKey:@"Store"];
        if ([[feed objectForKey:@"FeedType"] intValue] == 2 && [store.objectId isEqualToString:currentStore.objectId]) {
            [userFeedList addObject:[[GlobalData getFeedList] objectAtIndex:i]];
            i = [[GlobalData getFeedList] count];
        }
    }
    
    [[self offerTable] reloadData];
}

- (IBAction)redeemLoyalty {
     // if user slide to the most right side, stop the operation
    if (loyaltySlider.value ==1.0) {
        loyaltySlider.value = 0.0;
        RedemptionViewController *redemptionViewController = [[RedemptionViewController alloc] initWithNibName:@"RedemptionViewController" bundle:nil];
        redemptionViewController.hidesBottomBarWhenPushed = YES;
        redemptionViewController.userLoyaltyCampaign = userLoyaltyCampgain;
        redemptionViewController.storeLoyaltyCampaign = feedLoyaltyCampaign;
        redemptionViewController.currentStore = currentStore;
        redemptionViewController.parentView = self;
        [mainController.navigationController pushViewController: redemptionViewController animated:NO];
    } else {
        [UIView beginAnimations: @"SlideCanceled" context: nil];
        [UIView setAnimationDelegate: self];
        [UIView setAnimationDuration: 0.35];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
        loyaltySlider.value = 0.0;
        [UIView commitAnimations];
    }
}

- (IBAction)redeemFirstTime {
    // if user slide to the most right side, stop the operation
    if (firstTimeSlider.value ==1.0) {
        firstTimeSlider.value = 0.0;
        RedemptionViewController *redemptionViewController = [[RedemptionViewController alloc] initWithNibName:@"RedemptionViewController" bundle:nil];
        redemptionViewController.hidesBottomBarWhenPushed = YES;
        redemptionViewController.storeFirstTimeCampaign = feedFirstTimeCampaign;
        redemptionViewController.currentStore = currentStore;
        redemptionViewController.parentView = self;
        [mainController.navigationController pushViewController: redemptionViewController animated:NO];
    } else {
        [UIView beginAnimations: @"SlideCanceled" context: nil];
        [UIView setAnimationDelegate: self];
        [UIView setAnimationDuration: 0.35];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
        firstTimeSlider.value = 0.0;
        [UIView commitAnimations];
    }
}

- (PFObject*)userCampaignForFeedType:(int) feedType withCampaignId:(NSString*) campaignId
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserCampaignLog"];
    [query includeKey:@"Store"];
    [query whereKey:@"User" equalTo:[PFUser currentUser]];
    [query whereKey:@"Store" equalTo:currentStore];
    [query whereKey:@"campaignType" equalTo:[[NSNumber alloc] initWithInt:feedType]];
    [query orderByDescending:@"updatedAt"];
    NSMutableArray* campaignList = [[NSMutableArray alloc] initWithArray:[query findObjects]];
    for (int i = 0; i < [campaignList count]; i ++) {
        PFObject* campaign = [campaignList objectAtIndex:i];
        if ([[campaign objectForKey:@"campaignId"] isEqualToString:campaignId]) {
            return campaign;
        }
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [userFeedList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject* feed = [userFeedList objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, [self tableView:tableView heightForRowAtIndexPath: indexPath]);
        gradient.colors = [NSArray arrayWithObjects:(id)[[[UIColor alloc] initWithRed:0.98 green:0.98 blue:0.98 alpha:1] CGColor], (id)[[[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor], nil];
        [cell.layer insertSublayer:gradient atIndex:0];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 240, 20)];
        UITextView *description = [[UITextView alloc] initWithFrame:CGRectMake(8, 38, 240, 40)];
        
        title.tag = 1;
        description.tag = 2;
        
        [cell addSubview:title];
        [cell addSubview:description];
        
        if ([[feed objectForKey:@"FeedType"] intValue] == 4) {
            UISlider *progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(15, 75, 280, 24)];
            firstTimeSlider = [[UISlider alloc] initWithFrame:CGRectMake(15, 75, 280, 24)];
            UITextView *progressTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 72, 280, 20)];
            
            progressSlider.tag = 3;
            firstTimeSlider.tag = 4;
            progressTextView.tag = 5;
            
            [cell addSubview:progressSlider];
            [cell addSubview:firstTimeSlider];
            [cell addSubview:progressTextView];
        }
        
        if ([[feed objectForKey:@"FeedType"] intValue] == 3) {
            UISlider *progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(15, 75, 280, 24)];
            loyaltySlider = [[UISlider alloc] initWithFrame:CGRectMake(15, 75, 280, 24)];
            UITextView *progressTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 72, 280, 20)];
            
            progressSlider.tag = 6;
            loyaltySlider.tag = 7;
            progressTextView.tag = 8;
            
            [cell addSubview:progressSlider];
            [cell addSubview:loyaltySlider];
            [cell addSubview:progressTextView];
        }
        
        if ([[feed objectForKey:@"FeedType"] intValue] == 2) {
            UITextView *happyHoursTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 58, 240, 140)];
            
            happyHoursTextView.tag = 9;
            
            [cell addSubview:happyHoursTextView];
        }
    }
    
    // set up general items
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    title.textColor = [[UIColor alloc] initWithRed:0.55 green:0.20 blue:0.55 alpha:1];
    title.backgroundColor = [UIColor clearColor];
    
    UITextView *description = (UITextView*)[cell viewWithTag:2];
    description.textColor = [UIColor grayColor];
    description.backgroundColor = [UIColor clearColor];
    description.font = [description.font fontWithSize:12];
    description.editable = false;
    description.scrollEnabled = false;
    description.userInteractionEnabled = false;
    description.text = [feed objectForKey:@"Description"];
    
    [cell addSubview:title];
    [cell addSubview:description];
    
    if ([[feed objectForKey:@"FeedType"] intValue] == 4) {
        PFObject* firstTimeCampaign = [[userFeedList objectAtIndex:indexPath.row] objectForKey:@"firstTimeObject"];
        PFObject* userCampaign = [self userCampaignForFeedType:4 withCampaignId:firstTimeCampaign.objectId];
        
        feedFirstTimeCampaign = firstTimeCampaign;
        
        title.text = @"First Time";
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 24), NO, 0.0);
        UIImage *blankMaxTrackImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 20), NO, 0.0);
        UIImage *blankThumbImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UISlider *progressSlider = (UISlider*)[cell viewWithTag:3];
        
        double rewardNum = 1;
        double stampCount = 0;
        
        firstTimeSlider = (UISlider*)[cell viewWithTag:4];
        [firstTimeSlider setThumbImage: [UIImage imageNamed:@"Slider2.png"] forState:UIControlStateNormal];
        [firstTimeSlider setMaximumTrackImage:blankMaxTrackImage forState:UIControlStateNormal];
        firstTimeSlider.minimumTrackTintColor = [UIColor lightGrayColor];
        [firstTimeSlider addTarget:self action:@selector(redeemFirstTime) forControlEvents:UIControlEventTouchUpInside];
        
        UITextView *progressTextView = (UITextView*)[cell viewWithTag:5];
        progressTextView.text = @"Slide to unlock";
        progressTextView.textColor = [UIColor whiteColor];
        progressTextView.textAlignment = NSTextAlignmentCenter;
        progressTextView.backgroundColor = [UIColor clearColor];
        progressTextView.font = [description.font fontWithSize:12];
        progressTextView.editable = false;
        progressTextView.scrollEnabled = false;
        progressTextView.userInteractionEnabled = false;
        
        if (userCampaign != nil) {
            stampCount = 1;
            firstTimeSlider.value = 1;
            firstTimeSlider.userInteractionEnabled = false;
            progressTextView.text = @"Already claimed";
        }
        
        progressSlider.value = stampCount / rewardNum;
        [progressSlider setThumbImage:blankThumbImage forState:UIControlStateNormal];
        [progressSlider setMaximumTrackImage:[UIImage imageNamed:[NSString stringWithFormat:@"slider.png"]] forState:UIControlStateNormal];
        progressSlider.minimumTrackTintColor = [[UIColor alloc] initWithRed:0.0 green:0.85 blue:0.9 alpha:1];
        progressSlider.userInteractionEnabled = false;
    }
    
    // set up loyalty campaign items
    if ([[feed objectForKey:@"FeedType"] intValue] == 3) {
        PFObject* loyaltyCampaign = [[userFeedList objectAtIndex:indexPath.row] objectForKey:@"loyaltyObject"];
        PFObject* userCampaign = [self userCampaignForFeedType:3 withCampaignId:loyaltyCampaign.objectId];
        
        feedLoyaltyCampaign = loyaltyCampaign;
        userLoyaltyCampgain = userCampaign;
        
        title.text = @"Loyalty";
        
        UISlider *progressSlider = (UISlider*)[cell viewWithTag:6];
        
        double rewardNum = [[loyaltyCampaign objectForKey:@"rewardNum"] intValue];
        double stampCount = 0;
        
        if (userCampaign != nil) {
            stampCount = [[userCampaign objectForKey:@"stampCount"] intValue];
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 24), NO, 0.0);
        UIImage *blankMaxTrackImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 20), NO, 0.0);
        UIImage *blankThumbImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        progressSlider.value = stampCount / rewardNum;
        [progressSlider setThumbImage:blankThumbImage forState:UIControlStateNormal];
        [progressSlider setMaximumTrackImage:[UIImage imageNamed:[NSString stringWithFormat:@"slider.png"]] forState:UIControlStateNormal];
        progressSlider.minimumTrackTintColor = [[UIColor alloc] initWithRed:0.0 green:0.85 blue:0.9 alpha:1];
        progressSlider.userInteractionEnabled = false;
        
        loyaltySlider = (UISlider*)[cell viewWithTag:7];
        loyaltySlider.value = 0;
        [loyaltySlider setThumbImage: [UIImage imageNamed:@"Slider2.png"] forState:UIControlStateNormal];
        [loyaltySlider setMaximumTrackImage:blankMaxTrackImage forState:UIControlStateNormal];
        loyaltySlider.minimumTrackTintColor = [UIColor lightGrayColor];
        
        [loyaltySlider addTarget:self action:@selector(redeemLoyalty) forControlEvents:UIControlEventTouchUpInside];
        
        UITextView *progressTextView = (UITextView*)[cell viewWithTag:8];
        progressTextView.text = [[NSString alloc] initWithFormat: @"%d / %d visits", (int)stampCount, (int)rewardNum];
        progressTextView.textColor = [UIColor whiteColor];
        progressTextView.textAlignment = NSTextAlignmentCenter;
        progressTextView.backgroundColor = [UIColor clearColor];
        progressTextView.font = [description.font fontWithSize:12];
        progressTextView.editable = false;
        progressTextView.scrollEnabled = false;
        progressTextView.userInteractionEnabled = false;
    }
    
    // display happy hour campaign
    if ([[feed objectForKey:@"FeedType"] intValue] == 2) {
        PFObject* happyHourCampaign = [feed objectForKey:@"happyHourObject"];
        
        title.text = @"Happy Hour";
        
        UITextView *happyHoursTextView = (UITextView*)[cell viewWithTag:9];
        happyHoursTextView.text = @"";
        happyHoursTextView.textColor = [UIColor grayColor];
        happyHoursTextView.backgroundColor = [UIColor clearColor];
        happyHoursTextView.font = [description.font fontWithSize:12];
        happyHoursTextView.editable = false;
        happyHoursTextView.scrollEnabled = false;
        happyHoursTextView.userInteractionEnabled = false;
        NSDictionary *happyHours = [happyHourCampaign  objectForKey:@"happyHours"];
        
        NSArray *daysOfWeek = [[NSArray alloc] initWithObjects: @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
        
        for (int i = 0; i < [daysOfWeek count]; i++) {
            if ([[happyHours objectForKey:[daysOfWeek objectAtIndex:i]] count] != 0) {
                NSDictionary *happyHourOfDay = [[happyHours objectForKey:[daysOfWeek objectAtIndex:i]] objectAtIndex:0];
                NSString *begin_hour = [happyHourOfDay objectForKey:@"begin_hour"];
                NSString *begin_min = [happyHourOfDay objectForKey:@"begin_min"];
                NSString *end_hour = [happyHourOfDay objectForKey:@"end_hour"];
                NSString *end_min = [happyHourOfDay objectForKey:@"end_min"];
                NSString *label = [[NSString alloc] initWithFormat: @"%@: %@:%@ - %@:%@\n", [daysOfWeek objectAtIndex:i], begin_hour, begin_min, end_hour, end_min];
                happyHoursTextView.text = [happyHoursTextView.text stringByAppendingString:label];
            }
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject* feed = [userFeedList objectAtIndex:indexPath.row];
    int height = 0;
    
    if ([[feed objectForKey:@"FeedType"] intValue] == 4) {
        height = 130;
    }
    
    if ([[feed objectForKey:@"FeedType"] intValue] == 3) {
        height = 130;
    }
    
    if ([[feed objectForKey:@"FeedType"] intValue] == 2) {
        height = 180;
    }
    return height;
}

 
//}
@end
