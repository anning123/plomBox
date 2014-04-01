//
//  RedemptionViewController.h
//  plomboxBlue
//
//  Created by QIAN on 2013-03-15.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class StoreOfferViewController;

@interface RedemptionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *numberOfItemTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTwoTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordThreeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordFourTextField;
@property (weak, nonatomic) IBOutlet UIView *useRewardView;
@property (weak, nonatomic) IBOutlet UIView *congratulationView;
@property (weak, nonatomic) IBOutlet UIGestureRecognizer *congratulationViewGR;
@property (weak, nonatomic) IBOutlet UILabel *congratulationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *congratulationStoreDescriptionLabel;


@property (nonatomic, strong) PFObject* userLoyaltyCampaign;
@property (nonatomic, strong) PFObject* storeLoyaltyCampaign;
@property (nonatomic, strong) PFObject* storeFirstTimeCampaign;
@property (nonatomic, strong) PFObject* currentStore;
@property (nonatomic, strong) StoreOfferViewController* parentView;

- (IBAction)verifyPassword;
- (IBAction)useReward;
- (IBAction)dontUseReward;

@end
