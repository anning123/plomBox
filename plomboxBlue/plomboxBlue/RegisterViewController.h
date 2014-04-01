//
//  RegisterViewController.h
//  plomboxBlue
//
//  Created by QIAN on 2013-03-12.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayDayTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayMonthTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayYearTextField;
- (IBAction)registerUser;

@end
