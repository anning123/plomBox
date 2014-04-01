//
//  SettingViewController.h
//  plomboxBlue
//
//  Created by dong chen on 2013-01-15.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *settingTable;
- (IBAction)logout:(id)sender;


@end
