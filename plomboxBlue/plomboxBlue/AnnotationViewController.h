//
//  AnnotationViewController.h
//  plomboxBlue
//
//  Created by dong chen on 2013-01-13.
//  Copyright (c) 2013 dong chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MKAnnotation.h"

@interface AnnotationViewController : UIViewController<MKAnnotation>{
    CLLocationCoordinate2D coordinte;
    NSString *title;
    NSString *subtitle;
    
}

@property (nonatomic, assign) int num;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@end
