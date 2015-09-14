//
//  HomeViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "HomeViewController.h"

#import "ThemeManager.h"

#import "UIViewController+MMDrawerController.h"

#import "WeiboModel.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //实现导航栏上的按钮
    [self _initNavigationItem];
    

}


//实现导航栏上的按钮
- (void)_initNavigationItem
{
    //左边的按钮
    ThemeButton *leftThemeBtn = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 90, 35)];
    leftThemeBtn.imgName = @"button_title.png";
    [leftThemeBtn setTitle:@"设置" forState:UIControlStateNormal];
    [leftThemeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    [leftThemeBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftThemeBtn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //右边的按钮
    ThemeButton *rightThemeBtn = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    rightThemeBtn.imgName = @"button_icon_plus.png";
    [rightThemeBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightThemeBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;

    
}


//使用第三方MMD
//左边的按钮
- (void)leftBtnClick:(ThemeButton *)btn
{
    //调用菜单控制器打开左侧视图的方法（如果是打开状态，它执行关闭事件）
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

}

//右边的按钮
- (void)rightBtnClick:(ThemeButton *)btn
{
    //调用菜单控制器打开左侧视图的方法（如果是打开状态，它执行关闭事件）
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];

}


#pragma mark -控制MMD只能在首页可以滑动
//视图已经显示的时候将左右侧滑打开
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
}

//视图将要消失的时候将左右侧滑关闭
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
}

////获取sinaweibo对象(get方法)
//- (SinaWeibo *)sinaweibo
//{
//    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    return delegate.sinaweibo;
//}

- (IBAction)btnClick:(id)sender {
//    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
//                            params:nil
//                        httpMethod:@"GET"
//                          delegate:self];
    

    //自己封装DataService
    [DataService requestWithURL:@"statuses/home_timeline.json"
                         params:nil
                     httpMethod:@"GET"
                 finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
                     
//                     NSLog(@"result is %@", result);
                     
                     NSArray *jsonArr = result[@"statuses"];
                     NSMutableArray *mArr = [NSMutableArray array];
                     for (NSDictionary *dic in jsonArr) {
                         //...
                         WeiboModel *model = [[WeiboModel alloc] initContentWithDic:dic];
                         
                         [mArr addObject:model];
                         
                         NSLog(@"%@", model.text);
                         
                     }
                     
                     NSLog(@"mArr is %@", mArr);
                     
                 } failuerBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"error is %@", error);
                 }];
}

//#pragma mark -SinaWeiboRequestDelegate
////加载错误
//- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
//{
//    NSLog(@"error is %@", error);
//}
//
////加载成功
//- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
//{
//    NSLog(@"result is %@", result);
//}






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
