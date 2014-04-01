//
//  SettingViewController.m
//  plomboxBlue
//
//  Created by dong chen on 2013-01-15.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "UserProfileViewController.h"
#import "TermsAndServicesViewController.h"
#import <QuartzCore/CAGradientLayer.h>
#import <Parse/Parse.h>

@interface SettingViewController (){
    NSMutableArray *settingList;
    NSMutableArray *cellNavIndicatorList;
}

@end

@implementation SettingViewController

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
    [[self settingTable]setDelegate:self];
    [[self settingTable]setDataSource:self];
    
    settingList = [[NSMutableArray alloc]init];
    [settingList addObject:@"Profile"];
    [settingList addObject:@"Push Notifications"];
    [settingList addObject:@"Terms and Services"];
    
    cellNavIndicatorList = [[NSMutableArray alloc]init];
    [cellNavIndicatorList addObject:[[NSNumber alloc] initWithBool:true]];
    [cellNavIndicatorList addObject:[[NSNumber alloc] initWithBool:false]];
    [cellNavIndicatorList addObject:[[NSNumber alloc] initWithBool:true]];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [settingList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if ([[cellNavIndicatorList objectAtIndex:indexPath.row] boolValue]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, [self tableView:tableView heightForRowAtIndexPath: indexPath]);
        gradient.colors = [NSArray arrayWithObjects:(id)[[[UIColor alloc] initWithRed:0.98 green:0.98 blue:0.98 alpha:1] CGColor], (id)[[[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor], nil];
        [cell.layer insertSublayer:gradient atIndex:0];
    }
    cell.textLabel.text = [settingList objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.row == 1) {
        UISwitch *toggleSwitch = [[UISwitch alloc] init];
        cell.accessoryView = [[UIView alloc] initWithFrame:toggleSwitch.frame];
        [cell.accessoryView addSubview:toggleSwitch];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.tabBarController.selectedIndex = 0;
    delegate.window.rootViewController = delegate.loginNC;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UserProfileViewController * userProfileVC = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
        
        [self.navigationController pushViewController: userProfileVC animated:YES];
    } else if (indexPath.row == 2) {
        TermsAndServicesViewController * termsAndServicesVC = [[TermsAndServicesViewController alloc] initWithNibName:@"TermsAndServicesViewController" bundle:nil];
        
        [self.navigationController pushViewController: termsAndServicesVC animated:YES];
    }
}

@end
