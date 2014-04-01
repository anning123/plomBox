//
//  FeedViewController.h
//  plomboxBlue
//
//  Created by dong chen on 2013-01-13.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *feedTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *feedOptionControl;
- (IBAction)feedOptionsChange:(id)sender;
@property(nonatomic) NSMutableArray *share;
@property(nonatomic) NSString *pass;

@end
