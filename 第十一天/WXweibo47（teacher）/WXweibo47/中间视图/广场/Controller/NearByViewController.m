//
//  NearByViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/24.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "NearByViewController.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"

@interface NearByViewController ()

@end

@implementation NearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //创建地图
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    //获取当前位置信息
    [self myLocationManager];

}
//定位
- (void)myLocationManager
{
    //初始化
    _locationManager = [[CLLocationManager alloc] init];
    
    //设置应用允许定位
    [_locationManager requestAlwaysAuthorization];
    
    //设置定位的精确度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //设置代理
    _locationManager.delegate = self;
    //开始定位
    [_locationManager startUpdatingLocation];
    
}

#pragma mark -CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    //显示当前用户位置
    _mapView.showsUserLocation = YES;
    
    //停止定位
    [_locationManager stopUpdatingLocation];
    
    //获取地理信息
    CLLocation *location = [locations lastObject];
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    //设置地图显示区域
    MKCoordinateSpan span = {0.1, 0.1};
    
    MKCoordinateRegion region = {coordinate, span};
    
    [_mapView setRegion:region animated:YES];
    
    //请求网络
    [self loadNearByWeiboWithlong:[NSString stringWithFormat:@"%f", coordinate.longitude] lat:[NSString stringWithFormat:@"%f", coordinate.latitude]];
    
    
    
}
//请求网络
- (void)loadNearByWeiboWithlong:(NSString *)lon lat:(NSString *)lat
{
    //请求网络
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@20 forKey:@"count"];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    
    
    [DataService requestWithURL:nearby_timeline
                         params:params
                     httpMethod:@"GET"
                 finishDidBlock:^(AFHTTPRequestOperation *opertion, id result) {
                     //请求成功
                     NSLog(@"请求成功");

                     
                     NSArray *array = [result objectForKey:@"statuses"];
                     for (NSDictionary *dic in array) {
                         //...
                         WeiboModel *weiboModel = [[WeiboModel alloc] initContentWithDic:dic];
                         WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
                         annotation.weiboModel = weiboModel;
                         
                         
                         //第三步
                         [_mapView addAnnotation:annotation];

                     }
                     
                     
                 } failuerBlock:^(AFHTTPRequestOperation *opertion, NSError *error) {
                     NSLog(@"nearBy error");
                 }];
}

#pragma mark -MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    //如果是自己的位置，则不做处理
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identier = @"annotationView";
    WeiboAnnotationView *annotationView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identier];
    if (annotationView == nil) {
        annotationView = [[WeiboAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:identier];
        //设置大头针的颜色
//        annotationView.pinColor = MKPinAnnotationColorGreen;
        //从天而降的动画
//        annotationView.animatesDrop = YES;
    }
    
    //防止复用
    annotationView.annotation = annotation;
    
    return annotationView;

    
}


//标记视图已经添加到地图上显示的时候调用此方法
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
    int timer = 0;
    //实现动画
    for (UIView *annotationView in views) {
        //当前视图缩小为原来的0.5倍
        annotationView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        annotationView.alpha = 0;
        //动画放大
        [UIView animateWithDuration:0.3
                         animations:^{
                             [UIView setAnimationDelay:timer * 0.1];
                             annotationView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                             annotationView.alpha = 1;
                             
                         } completion:^(BOOL finished) {
                             //动画结束后还原
                             [UIView animateWithDuration:0.3 animations:^{
                                 //还原
                                 annotationView.transform = CGAffineTransformIdentity;
                                 
                             }];
                         }];

        timer ++;
        
    }
}














- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
