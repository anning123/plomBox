//
//  StoreNewsViewController.h
//  plomboxBlue
//
//  Created by dong chen on 2013-01-19.
//  Copyright (c) 2013 dong chen. All rights reserved.
//
#import "StoreInforViewController.h"
#import <UIKit/UIKit.h>

@class StoreInforViewController;

@interface StoreNewsViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *newsTable;
@property (nonatomic, strong) PFObject* currentStore;
-(void)initData;

@end
