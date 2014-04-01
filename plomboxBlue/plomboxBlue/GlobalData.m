//
//  GlobalData.m
//  plomboxBlue
//
//  Created by dong chen on 2013-03-22.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import "GlobalData.h"
#import <Parse/Parse.h>

@implementation GlobalData

static NSMutableArray* storeList;
static NSMutableArray* feedList;
static NSMutableArray* subscribedStoreList;

+ (NSMutableArray*) getStoreList
{
    if (storeList == nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"Store"];
        storeList = [[NSMutableArray alloc] initWithArray:[query findObjects]];
    }
    return storeList;
}

+ (NSMutableArray*) getFeedList
{
    if (feedList == nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"Feed"];
        [query includeKey:@"Store"];
        [query includeKey:@"firstTimeObject"];
        [query includeKey:@"happyHourObject"];
        [query includeKey:@"loyaltyObject"];
        [query includeKey:@"newsObject"];
        feedList = [[NSMutableArray alloc] initWithArray:[query findObjects]];
    }
    return feedList;
}

+ (NSMutableArray*) getSubscribedStoreList
{
    if (subscribedStoreList == nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"UserSubscribedStore"];
        [query whereKey:@"User" equalTo:[PFUser currentUser]];
        [query includeKey:@"Store"];
        subscribedStoreList = [[NSMutableArray alloc] initWithArray:[query findObjects]];
    }
    return subscribedStoreList;
}


@end
