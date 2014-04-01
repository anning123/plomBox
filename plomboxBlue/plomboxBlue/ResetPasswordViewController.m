//
//  ResetPasswordViewController.m
//  plomboxBlue
//
//  Created by QIAN on 2013-03-29.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import <Parse/Parse.h>

@interface ResetPasswordViewController () {
    UITapGestureRecognizer *tapRecognizer;
}

@end

@implementation ResetPasswordViewController

@synthesize currentPasswordTextField;
@synthesize confirmPasswordTextField;
@synthesize resetPasswordTextField;

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
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
}

-(void) keyboardWillShow:(NSNotification *) note {
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [currentPasswordTextField resignFirstResponder];
    [resetPasswordTextField resignFirstResponder];
    [confirmPasswordTextField resignFirstResponder];
}

- (void)savePassword
{
    PFUser *user = [PFUser currentUser];
    if ([currentPasswordTextField.text isEqualToString:@""] || [resetPasswordTextField.text isEqualToString:@""] || [confirmPasswordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"save password failed"
                                                        message:@"please fill in all the required fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else if ([PFUser logInWithUsername:user.username password: currentPasswordTextField.text] == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"save password failed"
                                                        message:@"incorrect current password"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else if (![resetPasswordTextField.text isEqualToString:confirmPasswordTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"save password failed"
                                                        message:@"new password and confirmation do not match"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        user.password = resetPasswordTextField.text;
        if ([user save]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"save password failed"
                                                            message:@"save password failed"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

@end
