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

@interface HomeViewController ()<LogInDidRefreshDelegate>

{
    WeiboTableView *_tableView;
    
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化数据
    _data = [NSMutableArray array];
    
    
    //实现导航栏上的按钮
    [self _initNavigationItem];
    

    //创建表视图
    [self _createTableView];
    
    //加载微博（请求数据）
    [self logInDidRefreshData];
    
}

//获取sinaweibo对象(get方法)
- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //程序刷新数据的代理给self
    delegate.loginDelegate = self;
    
    return delegate.sinaweibo;
}


//实现导航栏上的按钮，使用ThemeButton，因为会跟者主题的改变而改变样式
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



//- (IBAction)btnClick:(id)sender {
////    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
////                            params:nil
////                        httpMethod:@"GET"
////                          delegate:self];
//    
//
//    //自己封装DataService
//    [DataService requestWithURL:@"statuses/home_timeline.json"
//                         params:nil
//                     httpMethod:@"GET"
//                 finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//                     
////                     NSLog(@"result is %@", result);
//                     
//                     NSArray *jsonArr = result[@"statuses"];
//                     NSMutableArray *mArr = [NSMutableArray array];
//                     for (NSDictionary *dic in jsonArr) {
//                         //...
//                         WeiboModel *model = [[WeiboModel alloc] initContentWithDic:dic];
//                         
//                         [mArr addObject:model];
//                         
//                         NSLog(@"%@", model.text);
//                         
//                     }
//                     
//                     NSLog(@"mArr is %@", mArr);
//                     
//                     _tableView.data = mArr;
//                     
//                     [_tableView reloadData];
//                     
//                     
//                 } failuerBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                     NSLog(@"error is %@", error);
//                 }];
//}

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


#pragma mark -创建表视图
- (void)_createTableView
{
    _tableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    
    [self.view addSubview:_tableView];
    
}


#pragma mark -加载数据，请求微博
- (void)logInDidRefreshData
{
    //添加参数，请求20个数据
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@20 forKey:@"count"];
    
    //请求网络
    AFHTTPRequestOperation *opertion = [DataService requestWithURL:home_timeline
                         params:params
                     httpMethod:@"GET"
                 finishDidBlock:^(AFHTTPRequestOperation *opertion, id result) {

                     NSArray *jsonArr = result[@"statuses"];
                     NSMutableArray *mArr = [NSMutableArray array];
                     for (NSDictionary *dic in jsonArr) {
                         //使用包装的BaseModel封装为model
                         WeiboModel *model = [[WeiboModel alloc] initContentWithDic:dic];
                         //封装成model
                         [mArr addObject:model];
                         
                     }
                     //把数据model给表视图
                     _tableView.data = mArr;
                     //刷新表视图
                     [_tableView reloadData];
                     
                 }
                   failuerBlock:^(AFHTTPRequestOperation *opertion, NSError *error) {
                       NSLog(@"error is %@", error);
                   }];
    
    //如果程序第一次使用，需要登录
    if (opertion == nil) {
        //在上面已经拿到微博对象
        [self.sinaweibo logIn];
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
