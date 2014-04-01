//
//  StoreOfferViewController.h
//  plomboxBlue
//
//  Created by dong chen on 2013-01-18.
//  Copyright (c) 2013 dong chen. All rights reserved.
//
#import "StoreInforViewController.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class StoreInforViewController;

@interface StoreOfferViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate> {
    IBOutlet UISlider* firstTimeSlider;
    IBOutlet UISlider* loyaltySlider;
}

@property(nonatomic, strong) StoreInforViewController* mainController;
@property (weak, nonatomic) IBOutlet UITableView *offerTable;
@property (nonatomic, strong) PFObject* currentStore;
- (IBAction)redeem;
- (void)initData;
- (void)refreshData;
@end
