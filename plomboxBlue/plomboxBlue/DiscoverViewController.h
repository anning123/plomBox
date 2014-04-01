//
//  DiscoverViewController.h
//  plomboxBlue
//
//  Created by dong chen on 2013-03-13.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface DiscoverViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,
UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (void)initMap;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UILabel *firstTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *loyaltyLabel;
@property (weak, nonatomic) IBOutlet UILabel *happyHourLabel;


@end
