//
//  LoginViewController.h
//  plomboxBlue
//
//  Created by QIAN on 2013-03-07.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)loginUser;
- (IBAction)registerNewUser;

@end
