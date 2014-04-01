//
//  AppDelegate.m
//  plomboxBlue
//
//  Created by dong chen on 2013-01-13.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import "AppDelegate.h"
#import "FeedViewController.h"
#import "StoreViewController.h"
#import "DiscoverViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>

@implementation AppDelegate

@synthesize tabBarController;
@synthesize loginNC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"T5ZYAa3K36CgAlvNnoy1rFS6bkMa4GLnUlT4GfWP"
                  clientKey:@"Gk8SUR6jMVkSzW4x3OWGiYSgQEj5tUxywB0BawHd"];
    
    LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    loginNC = [[UINavigationController alloc]initWithRootViewController:loginVC];
    loginVC.title = @"Login";
    
    DiscoverViewController* discoverVC = [[DiscoverViewController alloc]initWithNibName:@"DiscoverViewController" bundle:nil];
    UINavigationController *discoverNC = [[UINavigationController alloc]initWithRootViewController:discoverVC];
    discoverVC.title = @"Discover";
    
    FeedViewController *feedVC = [[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
    UINavigationController *feedNC = [[UINavigationController alloc]initWithRootViewController:feedVC];
    feedVC.title = @"Feed";
    
    StoreViewController *storeVC = [[StoreViewController alloc]initWithNibName:@"StoreViewController" bundle:nil];
    UINavigationController *storeNC = [[UINavigationController alloc]initWithRootViewController:storeVC];
    storeVC.title = @"Store";
    
    SettingViewController *settingVC = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    UINavigationController *settingNC = [[UINavigationController alloc]initWithRootViewController:settingVC];
    settingVC.title = @"Setting";
    
    tabBarController = [[UITabBarController alloc]init];
    tabBarController.viewControllers = [NSArray arrayWithObjects: discoverNC, feedNC, storeNC, settingNC, nil, nil, nil, nil];
    
    NSArray* items = [self.tabBarController.tabBar items];
    [[items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"discover.png"]] withFinishedUnselectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"discover.png"]]];
    [[items objectAtIndex:1] setFinishedSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"Feed.png"]] withFinishedUnselectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"Feed.png"]]];
    [[items objectAtIndex:2] setFinishedSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"store.png"]] withFinishedUnselectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"store.png"]]];
    [[items objectAtIndex:3] setFinishedSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"setting.png"]] withFinishedUnselectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"setting.png"]]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if ([PFUser currentUser]) {
        self.window.rootViewController = tabBarController;
    } else {
        self.window.rootViewController = loginNC;
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
