//
//  StoreNewsViewController.m
//  plomboxBlue
//
//  Created by dong chen on 2013-01-19.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import "StoreInforViewController.h"
#import "StoreOfferViewController.h"
#import "StoreNewsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAGradientLayer.h>

@interface StoreNewsViewController () {
    NSMutableArray *newsList;
}

@end


@implementation StoreNewsViewController

@synthesize currentStore;

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
    // Do any additional setup after loading the view from its nib.
    
    [[self newsTable]setDelegate:self];
    [[self newsTable]setDataSource:self];
}

- (void)initData
{
    if (currentStore == NULL)
        return;
    // grab and display information for news
    PFQuery *allNews = [PFQuery queryWithClassName:@"News"];
    [allNews whereKey:@"Store" equalTo:currentStore];
    [allNews includeKey:@"Store"];
    [allNews orderByDescending:@"updatedAt"];
    [allNews findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if ([comments count] == 0) {
            return;
        }
        
        newsList = [[NSMutableArray alloc] initWithArray:comments];
        [[self newsTable] reloadData];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        UITextView *newsTitle = [[UITextView alloc] initWithFrame:CGRectMake(98, 18, 200, 30)];
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(105, 43, 195, 1)];
        UITextView *newsDescription = [[UITextView alloc] initWithFrame:CGRectMake(98, 38, 200, 40)];
        
        imgView.tag = 1;
        storeName.tag = 2;
        newsTitle.tag = 3;
        separator.tag = 4;
        newsDescription.tag = 5;
        
        [cell addSubview:storeName];
        [cell addSubview:newsTitle];
        [cell addSubview:separator];
        [cell addSubview:newsDescription];
        [cell addSubview:imgView];
    }
    
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:1];
    UILabel *storeName = (UILabel*)[cell viewWithTag:2];
    UITextView *newsTitle = (UITextView*)[cell viewWithTag:3];
    UIView *separator = (UIView*)[cell viewWithTag:4];
    UITextView *newsDescription = (UITextView*)[cell viewWithTag:5];
    
    PFObject *news = [newsList objectAtIndex:indexPath.row];
    
    PFFile *thumbnail = [currentStore objectForKey:@"thumbNail"];
    imgView.image = [UIImage imageWithData:[thumbnail getData]];
    imgView.backgroundColor = [UIColor whiteColor];
    imgView.layer.masksToBounds = YES;
    imgView.layer.borderColor = [UIColor grayColor].CGColor;
    imgView.layer.borderWidth = 1;
    
    storeName.text = [currentStore objectForKey:@"storeName"];
    storeName.textColor = [[UIColor alloc] initWithRed:0.55 green:0.20 blue:0.55 alpha:1];
    storeName.backgroundColor = [UIColor clearColor];
    
    newsTitle.text = [news objectForKey:@"title"];
    newsTitle.scrollEnabled = false;
    newsTitle.textColor = [UIColor grayColor];
    newsTitle.backgroundColor = [UIColor clearColor];
    newsTitle.font = [newsTitle.font fontWithSize:12];
    newsTitle.editable = false;
    newsTitle.userInteractionEnabled = false;
    
    separator.backgroundColor = [UIColor grayColor];
    
    newsDescription.text = [news objectForKey:@"description"];
    newsDescription.scrollEnabled = false;
    newsDescription.textColor = [UIColor grayColor];
    newsDescription.backgroundColor = [UIColor clearColor];
    newsDescription.font = [newsDescription.font fontWithSize:12];
    newsDescription.editable = false;
    newsDescription.userInteractionEnabled = false;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [newsList count];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
