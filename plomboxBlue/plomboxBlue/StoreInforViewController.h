//
//  StoreInforViewController.h
//  plomboxBlue
//
//  Created by dong chen on 2013-01-19.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreOfferViewController.h"
#import "StoreNewsViewController.h"
#import <Parse/Parse.h>


@interface StoreInforViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *storeAddressTextField;
@property (weak, nonatomic) IBOutlet UITextView *storeBusinessHourTextField;
@property (weak, nonatomic) IBOutlet UIButton *storeLocateButton;
@property (weak, nonatomic) IBOutlet UIButton *storePhoneButton;
@property (weak, nonatomic) IBOutlet UIButton *storeWebsiteButton;

@property (strong, nonatomic) IBOutlet UISegmentedControl *storeInfoOption;
@property (strong, nonatomic) IBOutlet UIScrollView *storeInfoView;
@property (strong, nonatomic) IBOutlet UIView *segmentedControlToggleView;
@property (strong, nonatomic) StoreOfferViewController *storeOfferViewController;
@property (strong, nonatomic) StoreNewsViewController *storeNewsViewController;
@property (strong, nonatomic) PFObject* currentStore;

- (IBAction)storeInfoValue:(id)sender;
- (void)initData;

@end
