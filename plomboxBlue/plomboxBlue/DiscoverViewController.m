//
//  DiscoverViewController.m
//  plomboxBlue
//
//  Created by dong chen on 2013-03-13.
//  Copyright (c) 2013 dong chen. All rights reserved.
//
#import <Parse/Parse.h>
#import "GlobalData.h"
#import "DiscoverViewController.h"
#import "AnnotationViewController.h"
#import "StoreInforViewController.h"
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAGradientLayer.h>

@interface DiscoverViewController ()

@end


@implementation DiscoverViewController{
    UIButton* rightButton;
    NSMutableArray *annotationsArray;
}

@synthesize mapView;
@synthesize descriptionView;
@synthesize firstTimeLabel;
@synthesize loyaltyLabel;
@synthesize happyHourLabel;


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
    
    annotationsArray = [[NSMutableArray alloc] init];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = descriptionView.frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[[UIColor alloc] initWithRed:0.98 green:0.98 blue:0.98 alpha:1] CGColor], (id)[[[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:1] CGColor], nil];
    [descriptionView.layer insertSublayer:gradient atIndex:0];
    
    self.mapView.delegate = self;
    CLLocationManager* locationManager = [[CLLocationManager alloc]init];

    descriptionView.hidden = YES;
    
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [self.mapView setShowsUserLocation:YES];
    
    [self initMap];
}

- (void)initMap
{
    for (int i = 0; i < [[GlobalData getStoreList] count];i ++){
        PFObject *store = [[GlobalData getStoreList] objectAtIndex:i];
        PFGeoPoint *geoPoint = [store objectForKey:@"location"];
        
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
        AnnotationViewController *annotationVC = [[AnnotationViewController alloc]init];
        annotationVC.title = [store objectForKey:@"storeName"];
        
        // num = 0 is taken by current user annotation
        annotationVC.num = i + 1;
        
        [annotationVC setCoordinate:location];
        [self.mapView addAnnotation:annotationVC];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region;
    region.center = self.mapView.userLocation.coordinate;
    region.span = MKCoordinateSpanMake(0.1, 0.1);
    
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
{ 
    AnnotationViewController *annotationVC = (AnnotationViewController*)annotation;
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([self tagToIndex:annotationVC.num] < 0) {
        return nil;
    }
    
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (false)
    {
        return annotationView;
    }
    else
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                         reuseIdentifier:AnnotationIdentifier];
        
        if ([self isStoreSubscribed:[[GlobalData getStoreList] objectAtIndex:[self tagToIndex:annotationVC.num]]]) {
            annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"map_tag_color.png"]];
        } else {
            annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"map_tag_grey.png"]];
        }
        
        rightButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [rightButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        annotationView.tag = annotationVC.num;
        rightButton.tag = annotationView.tag;
        
        [annotationsArray addObject:annotationView];
        
        [rightButton setTitle:@"" forState:UIControlStateNormal];
        annotationView.rightCalloutAccessoryView = rightButton;
        annotationView.canShowCallout = YES;
        annotationView.draggable = NO;
        return annotationView;
    }
    return nil;
}

- (int)tagToIndex: (int)tag
{
    return tag - 1;
}

- (BOOL)isStoreSubscribed: (PFObject*)store
{
    for (int i = 0; i < [[GlobalData getSubscribedStoreList] count]; i++) {
        PFObject* userSubscribe = [[GlobalData getSubscribedStoreList] objectAtIndex:i];
        PFObject* subscribedStore = [userSubscribe objectForKey:@"Store"];
        if ([subscribedStore.objectId isEqualToString:store.objectId]) {
            return true;
        }
    }
    return false;
}

- (IBAction) buttonTouchUpInside: (UIButton*)sender
{
    if ([self tagToIndex:sender.tag] < 0) {
        return;
    }
    
    if([self isStoreSubscribed:[[GlobalData getStoreList] objectAtIndex:[self tagToIndex:sender.tag]]]) {
        return;
    }

    MKAnnotationView* annotationView = [annotationsArray objectAtIndex:[self tagToIndex:sender.tag]];
    annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"map_tag_color.png"]];
    
    PFObject* store = [[GlobalData getStoreList] objectAtIndex:[self tagToIndex:sender.tag]];
    
    PFObject *newUserSubscribedStore = [PFObject objectWithClassName:@"UserSubscribedStore"];
    [newUserSubscribedStore setValue:store forKey:@"Store"];
    [newUserSubscribedStore setValue:[PFUser currentUser] forKey:@"User"];
    
    [[GlobalData getSubscribedStoreList] addObject:newUserSubscribedStore];
    [newUserSubscribedStore save];
    
    for (id<MKAnnotation> annotation in mapView.annotations) {
        AnnotationViewController *annotationVC = (AnnotationViewController*)annotation;
        
        if (annotationVC.num == sender.tag) {
            [mapView removeAnnotation:annotation];
            [mapView addAnnotation:annotation];
            break;
        }
    }
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if ([self tagToIndex:view.tag] < 0) {
        return;
    }

    PFObject* currentStore = [[GlobalData getStoreList] objectAtIndex:[self tagToIndex:view.tag]];
    
    descriptionView.hidden = NO;
    firstTimeLabel.text = @"";
    loyaltyLabel.text = @"";
    happyHourLabel.text = @"";
    
    descriptionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_item.png"]];

    
    for (int i = 0; i < [[GlobalData getFeedList] count]; i++) {
        PFObject* feed = [[GlobalData getFeedList] objectAtIndex:i];
        PFObject* store = [feed objectForKey:@"Store"];
        
        if ([currentStore.objectId isEqualToString:store.objectId]) {
            PFObject* description = [feed objectForKey:@"Description"];
            NSNumber* feedType = [feed objectForKey:@"FeedType"];
            
            if ([feedType intValue] == 2){
                firstTimeLabel.text = [NSString stringWithFormat:@"%@", description];
            }
            else if ([feedType intValue] == 3){
                loyaltyLabel.text = [NSString stringWithFormat:@"%@", description];
            }
            else if ([feedType intValue] == 4){
                happyHourLabel.text = [NSString stringWithFormat:@"%@", description];
            }
        }
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    descriptionView.hidden = YES;
}

@end
