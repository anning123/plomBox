//
//  GlobalData.h
//  plomboxBlue
//
//  Created by dong chen on 2013-03-22.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalData : NSObject
 
+(NSMutableArray*) getStoreList;
+(NSMutableArray*) getFeedList;
+(NSMutableArray*) getSubscribedStoreList;

@end
