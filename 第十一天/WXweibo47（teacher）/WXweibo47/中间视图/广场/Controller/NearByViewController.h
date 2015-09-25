//
//  NearByViewController.h
//  WXweibo47
//
//  Created by imac on 15/9/24.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import "WeiboModel.h"


@interface NearByViewController : BaseViewController<MKMapViewDelegate,CLLocationManagerDelegate>

{
    MKMapView *_mapView;
    CLLocationManager *_locationManager;

}

@end
