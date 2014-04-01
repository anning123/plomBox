//
//  StoreViewController.m
//  plomboxBlue
//
//  Created by dong chen on 2013-01-13.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import "StoreViewController.h"
#import "StoreInforViewController.h"
#import "GlobalData.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAGradientLayer.h>

@implementation StoreViewController

@synthesize currentStore;
@synthesize nullStoreView;
@synthesize storeTable;

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
    [storeTable setDelegate:self];
    [storeTable setDataSource:self];
    
    UIBarButtonItem *search = [[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem *sort = [[UIBarButtonItem alloc]initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.rightBarButtonItem = search;
    self.navigationItem.leftBarButtonItem = sort;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [storeTable reloadData];
    
    if ([[GlobalData getSubscribedStoreList] count] == 0) {
        nullStoreView.hidden = NO;
    } else {
        nullStoreView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goToDiscoveryTab
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.tabBarController.selectedIndex = 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[GlobalData getSubscribedStoreList] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, [self tableView:tableView heightForRowAtIndexPath: indexPath]);
        gradient.colors = [NSArray arrayWithObjects:(id)[[[UIColor alloc] initWithRed:0.98 green:0.98 blue:0.98 alpha:1] CGColor], (id)[[[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor], nil];
        [cell.layer insertSublayer:gradient atIndex:0];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 75, 75)];
        UILabel *storeName = [[UILabel alloc] initWithFrame:CGRectMake(105, 5, 195, 20)];
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(105, 43, 195, 1)];
        UITextView *storeAddress = [[UITextView alloc] initWithFrame:CGRectMake(98, 38, 200, 40)];
        
        imgView.tag = 1;
        storeName.tag = 2;
        separator.tag = 3;
        storeAddress.tag = 4;
        
        [cell addSubview:storeName];
        [cell addSubview:separator];
        [cell addSubview:storeAddress];
        [cell addSubview:imgView];
    }
    
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:1];
    UILabel *storeName = (UILabel*)[cell viewWithTag:2];
    UIView *separator = (UIView*)[cell viewWithTag:3];
    UITextView *storeAddress = (UITextView*)[cell viewWithTag:4];
    
    PFObject *store = [[[GlobalData getSubscribedStoreList] objectAtIndex:indexPath.row] objectForKey:@"Store"];
    PFFile *thumbnail = [store objectForKey:@"thumbNail"];
    if (!thumbnail.isDataAvailable) {
        [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error)
            {
                [storeTable reloadData];
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
    
    storeAddress.text = [store objectForKey:@"address"];
    storeAddress.textColor = [UIColor grayColor];
    storeAddress.backgroundColor = [UIColor clearColor];
    storeAddress.font = [storeAddress.font fontWithSize:12];
    storeAddress.editable = false;
    storeAddress.scrollEnabled = false;
    storeAddress.userInteractionEnabled = false;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreInforViewController * storeInforViewController = [[StoreInforViewController alloc] initWithNibName:@"StoreInforViewController" bundle:nil];
    storeInforViewController.hidesBottomBarWhenPushed = NO;
    storeInforViewController.currentStore = [[[GlobalData getSubscribedStoreList] objectAtIndex:indexPath.row] objectForKey:@"Store"];
    [storeInforViewController initData];
    [self.navigationController pushViewController: storeInforViewController animated:YES];
}


@end
