//
//  StoreInforViewController.m
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

@interface StoreInforViewController ()

@end

@implementation StoreInforViewController


@synthesize storeInfoOption;
@synthesize storeOfferViewController, storeNewsViewController;
@synthesize currentStore;
@synthesize storeInfoView;
@synthesize segmentedControlToggleView;
@synthesize storeLogoImageView;
@synthesize storeNameLabel;
@synthesize storeAddressTextField;
@synthesize storeBusinessHourTextField;
@synthesize storeLocateButton;
@synthesize storePhoneButton;
@synthesize storeWebsiteButton;

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
    
    storeOfferViewController = [[StoreOfferViewController alloc]initWithNibName:@"StoreOfferViewController" bundle:nil];
    storeOfferViewController.view.hidden = YES;
    storeOfferViewController.mainController = self;
    storeOfferViewController.currentStore = currentStore;
    [storeOfferViewController initData];
    [segmentedControlToggleView addSubview:storeOfferViewController.view];
    
    storeNewsViewController = [[StoreNewsViewController alloc]initWithNibName:@"StoreNewsViewController" bundle:nil];
    storeNewsViewController.view.hidden = YES;
    storeNewsViewController.currentStore = currentStore;
    [storeNewsViewController initData];
    [segmentedControlToggleView addSubview:storeNewsViewController.view];
    
    // set up store info view
    
    // store logo
    PFFile *thumbnail = [currentStore objectForKey:@"thumbNail"];
    storeLogoImageView.image = [UIImage imageWithData:[thumbnail getData]];
    storeLogoImageView.backgroundColor = [UIColor whiteColor];
    storeLogoImageView.layer.masksToBounds = YES;
    storeLogoImageView.layer.borderColor = [UIColor grayColor].CGColor;
    storeLogoImageView.layer.borderWidth = 1;
    
    // store name
    storeNameLabel.text = [currentStore objectForKey:@"storeName"];
    
    // store address
    storeAddressTextField.text = [currentStore objectForKey:@"address"];
    
    // business hours table
    NSDictionary *businessHours = [currentStore  objectForKey:@"storeHours"];
    NSArray *daysOfWeek = [[NSArray alloc] initWithObjects: @"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", @"sunday", nil];
    NSArray *nameOfDaysOfWeek = [[NSArray alloc] initWithObjects: @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun", nil];
    for (int i = 0; i < [daysOfWeek count]; i++) {
        if ([[businessHours objectForKey:[daysOfWeek objectAtIndex:i]] count] != 0) {
            NSArray *businessHourOfDay = [businessHours objectForKey:[daysOfWeek objectAtIndex:i]];
            NSString *label = [[NSString alloc] initWithFormat: @"%@: ", [nameOfDaysOfWeek objectAtIndex:i]];
            if ([businessHourOfDay count] == 0) {
                label = [label stringByAppendingString:@"Closed\n"];
            }
            
            for (int j = 0; j < [businessHourOfDay count]; j++) {
                if ( j > 0) {
                    label = [label stringByAppendingString:@"\n       "];
                }
                label = [label stringByAppendingString:[[NSString alloc] initWithFormat:@"%@", [businessHourOfDay objectAtIndex:j]]];
            }
            label = [label stringByAppendingString:@"\n"];
            storeBusinessHourTextField.text = [storeBusinessHourTextField.text stringByAppendingString:label];
        }
    }
    
    CAGradientLayer *businessHourGradient = [CAGradientLayer layer];
    businessHourGradient.frame = CGRectMake(storeBusinessHourTextField.frame.origin.x, storeBusinessHourTextField.frame.origin.y, storeBusinessHourTextField.frame.size.width, storeBusinessHourTextField.frame.size.height);
    businessHourGradient.colors = [NSArray arrayWithObjects:(id)[[[UIColor alloc] initWithRed:0.98 green:0.98 blue:0.98 alpha:1] CGColor], (id)[[[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor], nil];
    [storeBusinessHourTextField.layer insertSublayer:businessHourGradient atIndex:0];
    
    storeBusinessHourTextField.layer.masksToBounds = YES;
    storeBusinessHourTextField.layer.borderColor = [UIColor grayColor].CGColor;
    storeBusinessHourTextField.layer.borderWidth = 1;
    
    // phone button
    if ([currentStore objectForKey:@"phone"] != nil) {
        [storePhoneButton setTitle:[[NSString alloc] initWithFormat:@"%@", [currentStore objectForKey:@"phone"]] forState:UIControlStateNormal];
    } else {
        [storePhoneButton setEnabled:false];
    }
    
    // website button
    if (![[currentStore objectForKey:@"website"] isEqualToString:@""]) {
        [storeWebsiteButton setTitle:[currentStore objectForKey:@"website"] forState:UIControlStateNormal];
    } else {
        NSLog(@"disable");
        [storeWebsiteButton setEnabled:false];
    }

    storeInfoView.hidden = NO;
    
    CAGradientLayer *overlayGradient = [CAGradientLayer layer];
    overlayGradient.frame = CGRectMake(storeInfoView.frame.origin.x, storeInfoView.frame.origin.y, storeInfoView.frame.size.width, storeInfoView.frame.size.height);
    overlayGradient.colors = [NSArray arrayWithObjects:(id)[[[UIColor alloc] initWithRed:0.98 green:0.98 blue:0.98 alpha:1] CGColor], (id)[[[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor], nil];
    [storeInfoView.layer insertSublayer:overlayGradient atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
}

- (IBAction)storeInfoValue:(UISegmentedControl*)sender {
    if (sender.selectedSegmentIndex == 0){
        storeInfoView.hidden = NO;
        storeOfferViewController.view.hidden = YES;
        storeNewsViewController.view.hidden = YES;
    }
    else if (sender.selectedSegmentIndex == 1){
        storeInfoView.hidden = YES;
        storeOfferViewController.view.hidden = NO;
        storeNewsViewController.view.hidden = YES;
    }
    else {
        storeInfoView.hidden = YES;
        storeOfferViewController.view.hidden = YES;
        storeNewsViewController.view.hidden = NO;
    }
}
@end
