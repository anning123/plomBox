//
//  ResetPasswordViewController.h
//  plomboxBlue
//
//  Created by QIAN on 2013-03-29.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *resetPasswordTextField;
- (IBAction)savePassword;

@end
