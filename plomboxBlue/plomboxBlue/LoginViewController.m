//
//  LoginViewController.m
//  plomboxBlue
//
//  Created by QIAN on 2013-03-07.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface LoginViewController () {
    UITapGestureRecognizer *tapRecognizer;
}

@end

@implementation LoginViewController

@synthesize userTextField;
@synthesize passwordTextField;

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
}

- (void)loginUser
{
    PFUser *currentUser = [PFUser logInWithUsername:userTextField.text password:passwordTextField.text];
    if (currentUser == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"login failed"
                                                        message:@"invalid user id or password"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self resetTextFields];
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        delegate.window.rootViewController = delegate.tabBarController;
    }
}

- (void)registerNewUser
{
    [self resetTextFields];
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    registerViewController.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController: registerViewController animated:YES];
}

- (void)resetTextFields
{
    [self.view endEditing:YES];
    userTextField.text = @"";
    passwordTextField.text = @"";
}

@end
