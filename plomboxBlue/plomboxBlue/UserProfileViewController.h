//
//  UserProfileViewController.h
//  plomboxBlue
//
//  Created by QIAN on 2013-03-29.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *profileTable;

@end
