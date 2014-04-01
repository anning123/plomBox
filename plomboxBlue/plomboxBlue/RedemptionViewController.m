//
//  RedemptionViewController.m
//  plomboxBlue
//
//  Created by QIAN on 2013-03-15.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import "RedemptionViewController.h"
#import "StoreOfferViewController.h"

@interface RedemptionViewController ()

@end

@implementation RedemptionViewController

@synthesize numberOfItemTextField;
@synthesize passwordOneTextField;
@synthesize passwordTwoTextField;
@synthesize passwordThreeTextField;
@synthesize passwordFourTextField;
@synthesize userLoyaltyCampaign;
@synthesize storeLoyaltyCampaign;
@synthesize storeFirstTimeCampaign;
@synthesize currentStore;
@synthesize useRewardView;
@synthesize congratulationView;
@synthesize congratulationViewGR;
@synthesize parentView;
@synthesize congratulationsLabel;
@synthesize storeDescriptionLabel;
@synthesize congratulationStoreDescriptionLabel;

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
    
    [congratulationViewGR addTarget:self action:@selector(popRedemptionView)];
    
    NSLog(@"%@", storeLoyaltyCampaign);
    NSLog(@"%@", userLoyaltyCampaign);
    
    if (storeLoyaltyCampaign != nil) {
        if (userLoyaltyCampaign != nil) {
            int rewardNum = [[storeLoyaltyCampaign  objectForKey:@"rewardNum"] intValue];
            int stampCount = [[userLoyaltyCampaign  objectForKey:@"stampCount"] intValue];
            if (stampCount == rewardNum) {
                useRewardView.hidden = NO;
            } else {
                [passwordOneTextField becomeFirstResponder];
            }
        }
        
        NSString* congratulationString = [[NSString alloc] initWithFormat:@"%@\n%@\n%@", [storeLoyaltyCampaign objectForKey:@"description"], [currentStore objectForKey:@"storeName"], [currentStore objectForKey:@"address"]];
        
        storeDescriptionLabel.text = congratulationString;
        congratulationStoreDescriptionLabel.text = congratulationString;
    }
    
    if (storeFirstTimeCampaign != nil) {
        useRewardView.hidden = NO;
        
        NSString* congratulationString = [[NSString alloc] initWithFormat:@"%@\n%@\n%@", [storeFirstTimeCampaign objectForKey:@"description"], [currentStore objectForKey:@"storeName"], [currentStore objectForKey:@"address"]];
        
        storeDescriptionLabel.text = congratulationString;
        congratulationStoreDescriptionLabel.text = congratulationString;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)verifyPassword
{
    // check if the number of items field is filled
    if ([numberOfItemTextField.text isEqualToString:@""]) {
        return;
    }
    
    int numberOfItems = [numberOfItemTextField.text intValue];
    // check if the number of items field is valid
    if (numberOfItems == 0) {
        numberOfItemTextField.text = @"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"redemption failed"
                                                        message:@"please enter a valid number of items"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (userLoyaltyCampaign != nil) {
        int rewardNum = [[storeLoyaltyCampaign  objectForKey:@"rewardNum"] intValue];
        int stampCount = [[userLoyaltyCampaign  objectForKey:@"stampCount"] intValue];
        if (stampCount + numberOfItems > rewardNum) {
            numberOfItemTextField.text = @"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"redemption failed"
                                                            message:@"please enter a valid number of items"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    // check if all password fields have been filled
    if ([numberOfItemTextField.text isEqualToString:@""] || [passwordOneTextField.text isEqualToString:@""] || [passwordTwoTextField.text isEqualToString:@""] || [passwordThreeTextField.text isEqualToString:@""] || [passwordFourTextField.text isEqualToString:@""]) {
        [self setFocus];
        return;
    }
    
    NSString *userPassword = [[NSString alloc] initWithFormat:@"%@%@%@%@", passwordOneTextField.text, passwordTwoTextField.text, passwordThreeTextField.text, passwordFourTextField.text];
    NSString *loyaltyPassword = [storeLoyaltyCampaign objectForKey:@"password"];
    
    // check if the password is correct
    if (![loyaltyPassword isEqualToString:userPassword]) {
        passwordOneTextField.text = @"";
        passwordTwoTextField.text = @"";
        passwordThreeTextField.text = @"";
        passwordFourTextField.text = @"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"redemption failed"
                                                        message:@"password incorrect"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self redeem];
}

- (void)setFocus
{
    if (![passwordOneTextField.text isEqualToString:@""]) {
        if (![passwordTwoTextField.text isEqualToString:@""]) {
            if (![passwordThreeTextField.text isEqualToString:@""]) {
                [passwordFourTextField becomeFirstResponder];
                return;
            }
            [passwordThreeTextField becomeFirstResponder];
            return;
        }
        [passwordTwoTextField becomeFirstResponder];
    }
}

- (void)redeem
{
    [self.view endEditing:YES];
    
    int numberOfItems = [numberOfItemTextField.text intValue];
    if (userLoyaltyCampaign == nil) {
        PFObject *newUserCampaignLog = [PFObject objectWithClassName:@"UserCampaignLog"];
        [newUserCampaignLog setValue:currentStore forKey:@"Store"];
        [newUserCampaignLog setValue:[PFUser currentUser] forKey:@"User"];
        [newUserCampaignLog setValue:[storeLoyaltyCampaign objectId] forKey:@"campaignId"];
        [newUserCampaignLog setValue:[[NSNumber alloc] initWithInt:3] forKey:@"campaignType"];
        [newUserCampaignLog setValue:[[NSNumber alloc] initWithInt:0] forKey:@"stampCount"];
        [newUserCampaignLog save];
        
        userLoyaltyCampaign = newUserCampaignLog;
    }
    
    int rewardNum = [[storeLoyaltyCampaign  objectForKey:@"rewardNum"] intValue];
    int stampCount = [[userLoyaltyCampaign  objectForKey:@"stampCount"] intValue];
    if (stampCount + numberOfItems < rewardNum) {
        NSNumber *newStampCount = [[NSNumber alloc] initWithInt:(stampCount + numberOfItems)];
        [userLoyaltyCampaign setValue:newStampCount forKey:@"stampCount"];
        [userLoyaltyCampaign save];
        
        congratulationView.hidden = NO;
        
        congratulationsLabel.text = @"You are now a step closer to unlocking the Loyalty reward.";
    } else if (stampCount + numberOfItems == rewardNum) {
        NSNumber *newStampCount = [[NSNumber alloc] initWithInt:rewardNum];
        [userLoyaltyCampaign setValue:newStampCount forKey:@"stampCount"];
        [userLoyaltyCampaign save];
        
        useRewardView.hidden = NO;
    } else { // stampCount + numberOfItems > rewardNum
        // do not support right now
    }
    
    // create new campaignLog entry
    PFObject *newCampaignLog = [PFObject objectWithClassName:@"CampaignLog"];
    [newCampaignLog setValue:[[NSNumber alloc] initWithInt:3] forKey:@"campaignType"];
    [newCampaignLog setValue:[PFUser currentUser] forKey:@"user"];
    [newCampaignLog setValue:currentStore forKey:@"store"];
    [newCampaignLog save];
}

- (void)useReward
{
    if (storeLoyaltyCampaign != nil) {
        [userLoyaltyCampaign setValue:[[NSNumber alloc] initWithInt:0] forKey:@"stampCount"];
        [userLoyaltyCampaign save];
        
        congratulationView.hidden = NO;
        
        congratulationsLabel.text = @"You just unlocked the loyalty reward. Show this page to store staff to redeem it.";
    }
    
    if (storeFirstTimeCampaign != nil) {
        PFObject *newUserCampaignLog = [PFObject objectWithClassName:@"UserCampaignLog"];
        [newUserCampaignLog setValue:currentStore forKey:@"Store"];
        [newUserCampaignLog setValue:[PFUser currentUser] forKey:@"User"];
        [newUserCampaignLog setValue:[storeFirstTimeCampaign objectId] forKey:@"campaignId"];
        [newUserCampaignLog setValue:[[NSNumber alloc] initWithInt:4] forKey:@"campaignType"];
        [newUserCampaignLog setValue:[[NSNumber alloc] initWithInt:1] forKey:@"stampCount"];
        [newUserCampaignLog save];
        
        // create new campaignLog entry
        PFObject *newCampaignLog = [PFObject objectWithClassName:@"CampaignLog"];
        [newCampaignLog setValue:[[NSNumber alloc] initWithInt:4] forKey:@"campaignType"];
        [newCampaignLog setValue:[PFUser currentUser] forKey:@"user"];
        [newCampaignLog setValue:currentStore forKey:@"store"];
        [newCampaignLog save];
        
        congratulationView.hidden = NO;
        
        congratulationsLabel.text = @"You just unlocked the first time reward. Show this page to store staff to redeem it.";
    }
}

- (void)dontUseReward
{
    [self popRedemptionView];
}

- (void)popRedemptionView
{
    [parentView refreshData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
