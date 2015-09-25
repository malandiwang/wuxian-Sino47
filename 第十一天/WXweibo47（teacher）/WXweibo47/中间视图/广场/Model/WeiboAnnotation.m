//
//  WeiboAnnotation.m
//  WXweibo47
//
//  Created by imac on 15/9/24.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation

- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        //第二步
        NSArray *coordinates = weiboModel.geo[@"coordinates"];
        
        double lat = [coordinates[0] doubleValue];
        double lon = [coordinates[1] doubleValue];
        
        //把经纬度给_coordinate
        _coordinate = CLLocationCoordinate2DMake(lat, lon);
        
    }
}

@end
