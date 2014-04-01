//
//  StoreViewController.h
//  plomboxBlue
//
//  Created by dong chen on 2013-01-13.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StoreViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *storeTable;
@property (strong, nonatomic) PFObject *currentStore;
@property (strong, nonatomic) IBOutlet UIView *nullStoreView;

- (IBAction)goToDiscoveryTab;

@end
