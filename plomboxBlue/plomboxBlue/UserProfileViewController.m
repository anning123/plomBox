//
//  UserProfileViewController.m
//  plomboxBlue
//
//  Created by QIAN on 2013-03-29.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import "UserProfileViewController.h"
#import "ResetPasswordViewController.h"
#import <QuartzCore/CAGradientLayer.h>
#import <Parse/Parse.h>

@interface UserProfileViewController () {
    NSMutableArray *userProfileList;
    NSMutableArray *cellNavIndicatorList;
    NSMutableArray *cellHeightList;
}

@end

@implementation UserProfileViewController

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
    
    [[self profileTable]setDelegate:self];
    [[self profileTable]setDataSource:self];
    
    userProfileList = [[NSMutableArray alloc]init];
    [userProfileList addObject:@""];
    [userProfileList addObject:@"Change Password"];
    
    cellNavIndicatorList = [[NSMutableArray alloc]init];
    [cellNavIndicatorList addObject:[[NSNumber alloc] initWithBool:false]];
    [cellNavIndicatorList addObject:[[NSNumber alloc] initWithBool:true]];
    
    cellHeightList = [[NSMutableArray alloc]init];
    [cellHeightList addObject:[[NSNumber alloc] initWithInt:200]];
    [cellHeightList addObject:[[NSNumber alloc] initWithInt:80]];
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
    return [userProfileList count];
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
        
        if (indexPath.row == 0) {
            UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(17, 10, 200, 30)];
            UITextView *userInfo = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 200, 150)];
            
            userName.tag = 1;
            userInfo.tag = 2;
            
            [cell addSubview:userName];
            [cell addSubview:userInfo];
        }
    }
    
    cell.textLabel.text = [userProfileList objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        UILabel *userName = (UILabel*)[cell viewWithTag:1];
        UITextView *userInfo = (UITextView*)[cell viewWithTag:2];
        
        PFUser *user = [PFUser currentUser];
        
        userName.text = [[NSString alloc] initWithFormat:@"%@ %@", [user objectForKey:@"firstName"], [user objectForKey:@"lastName"]];
        userName.textColor = [UIColor darkTextColor];
        userName.font = [userName.font fontWithSize:20];
        userName.backgroundColor = [UIColor clearColor];
        
        NSString *userInfoText = @"";
        
        if ([user objectForKey:@"email"] != nil) {
            userInfoText = [userInfoText stringByAppendingFormat:@"%@\n\n", [user objectForKey:@"email"]];
        }
        
        if ([user objectForKey:@"dateOfBirth"] != nil) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM, dd, yyyy"];
            userInfoText = [userInfoText stringByAppendingFormat:@"%@\n\n", [dateFormat stringFromDate:[user objectForKey:@"dateOfBirth"]]];
            
        }
        
        if ([user objectForKey:@"gender"]) {
            userInfoText = [userInfoText stringByAppendingFormat:@"%@", [user objectForKey:@"gender"]];
        }
        
        userInfo.text = [[NSString alloc] initWithFormat:@"%@", userInfoText];
        userInfo.textColor = [UIColor grayColor];
        userInfo.backgroundColor = [UIColor clearColor];
        userInfo.font = [userInfo.font fontWithSize:14];
        userInfo.editable = false;
        userInfo.scrollEnabled = false;
        userInfo.userInteractionEnabled = false;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[cellHeightList objectAtIndex:indexPath.row] intValue];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        ResetPasswordViewController * resetPasswordViewController = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
        
        [self.navigationController pushViewController: resetPasswordViewController animated:YES];
    }
}

@end
