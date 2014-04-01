//
//  RegisterViewController.m
//  plomboxBlue
//
//  Created by QIAN on 2013-03-12.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>

@interface RegisterViewController () {
    UITapGestureRecognizer *tapRecognizer;
}

@end

@implementation RegisterViewController

@synthesize userTextField;
@synthesize passwordTextField;
@synthesize confirmPasswordTextField;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize birthdayDayTextField;
@synthesize birthdayMonthTextField;
@synthesize birthdayYearTextField;

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
    [userTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [confirmPasswordTextField resignFirstResponder];
    [firstNameTextField resignFirstResponder];
    [lastNameTextField resignFirstResponder];
    [birthdayDayTextField resignFirstResponder];
    [birthdayMonthTextField resignFirstResponder];
    [birthdayYearTextField resignFirstResponder];
}

- (void)registerUser
{
    if ([userTextField.text isEqualToString:@""] || [passwordTextField.text isEqualToString:@""] || [confirmPasswordTextField.text isEqualToString:@""] || [firstNameTextField.text isEqualToString:@""] || [lastNameTextField.text isEqualToString:@""] || [birthdayDayTextField.text isEqualToString:@""] || [birthdayMonthTextField.text isEqualToString:@""] || [birthdayYearTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"register failed"
                                                        message:@"please fill in all the required fields"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else if (![passwordTextField.text isEqualToString:confirmPasswordTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"register failed"
                                                        message:@"passwords do not match"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else if ([self getBirthday] == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"register failed"
                                                        message:@"invalid birthday"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        PFUser *newUser = [PFUser user];
        newUser.username = userTextField.text;
        newUser.password = passwordTextField.text;
        [newUser setValue:firstNameTextField.text forKey:@"firstName"];
        [newUser setValue:lastNameTextField.text forKey:@"lastName"];
        [newUser setValue:[self getBirthday] forKey:@"dateOfBirth"];
        [newUser setValue:userTextField.text forKey:@"email"];
        if ([newUser signUp]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"register failed"
                                                            message:@"register failed"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (NSDate*)getBirthday
{
    NSString *dateString = [[NSString alloc] initWithFormat:@"%@%@%@", birthdayMonthTextField.text, birthdayDayTextField.text, birthdayYearTextField.text];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMddyyyy"];
    NSDate *birthday = [dateFormat dateFromString:dateString];
    
    return birthday;
}

@end
