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

#import "UIScrollView+MJRefresh.h"

#import <AudioToolbox/AudioToolbox.h>

#import "MainTabBarController.h"

@interface HomeViewController ()<LogInDidRefreshDelegate>

{
    //显示新微博的控件
    UIView *barView;
    //显示新微博的背景
    ThemeImageView *barItem;
    //显示新微博的条数
    ThemeLabel *barLabel;
    
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
    
    //显示加载视图(自定义)
//    [self showLoading:YES];
    //使用第三方文件
    [self showHUD:@"正在拼命加载..."];
    
    
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
    
    
    //添加下拉刷新控件
    [_tableView addHeaderWithTarget:self action:@selector(loadDataDown)];
    
    //添加上拉刷新控件
    [_tableView addFooterWithTarget:self action:@selector(loadDataUp)];
    
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
                     //把数据给控制器的data，用于以后刷新拼接使用
                     self.data = mArr;
                     
                     //把数据model给表视图
                     _tableView.data = mArr;
                     //刷新表视图
                     [_tableView reloadData];
                     
                     //隐藏加载视图（自定义）
//                     [self showLoading:NO];
                     //使用第三方文件隐藏视图
//                     [self hiddenHUD];
                     //加载完成后提示信息
                     [self completeHUD:@"客官，加载完成"];
                     
                     
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


#pragma mark -下拉刷新
- (void)loadDataDown
{
    //构建参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@20 forKey:@"count"];
    if (self.data.count > 0) {
        WeiboModel *weiboMd = self.data[0];
        //拿到第一个微博的ID
        NSString *topID = weiboMd.weiboId;
        //此参数since_id表示比当前微博晚的微博
        [params setObject:topID forKey:@"since_id"];
        
    }
    
    //请求网络
    [DataService requestWithURL:home_timeline
                         params:params
                     httpMethod:@"GET"
                 finishDidBlock:^(AFHTTPRequestOperation *opertion, id result) {
                     //请求成功
                     NSArray *array = result[@"statuses"];
                     
                     NSMutableArray *mArr = [NSMutableArray array];
                     for (NSDictionary *dic in array) {
                         //....
                         WeiboModel *weiboModel = [[WeiboModel alloc] initContentWithDic:dic];
                         [mArr addObject:weiboModel];
                     }
                     
                     if (mArr.count > 0) {
                         
                         //有新数据,插入到前面
                         NSRange range = {0, mArr.count};
                         NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
                         [self.data insertObjects:mArr atIndexes:indexSet];
                         //把插入新数据后的data给表视图的数据源
                         _tableView.data = self.data;
                         //刷新表视图
                         [_tableView reloadData];
                         
                         //显示新微博数量（把请求到的新微博的数量传过去）
                         [self showNewWeiboCount:mArr.count];
                         
                     }
                     
                     //刷新结束,下拉视图隐藏
                     [_tableView headerEndRefreshing];
                     
                 }
                   failuerBlock:^(AFHTTPRequestOperation *opertion, NSError *error) {
                       //请求失败
                       NSLog(@"请求失败");
                       //停止刷新
                       [_tableView headerEndRefreshing];
                       
                   }];
}


#pragma mark -显示新微博数量，提示视图
- (void)showNewWeiboCount:(NSInteger)count
{
    //懒加载方法，只在第一次进来时创建
    if (barView == nil) {
        //初始化显示视图
        barView = [[UIView alloc] initWithFrame:CGRectMake(0, - 40, kScreenWidth, 40)];
        //barView视图会自动向下64个像素，开始的位置是在导航栏下面
        [self.view addSubview:barView];
        //背景视图
        barItem = [[ThemeImageView alloc] initWithFrame:barView.bounds];
        [barView addSubview:barItem];
        //显示文本
        barLabel = [[ThemeLabel alloc] initWithFrame:barView.bounds];
        barLabel.textAlignment = NSTextAlignmentCenter;
        [barView addSubview:barLabel];
        
        //清空一下背景颜色
        barView.backgroundColor = [UIColor clearColor];
        barLabel.backgroundColor = [UIColor clearColor];
        barItem.backgroundColor = [UIColor clearColor];
        
        //给iamgeView和Label 赋值主题图片和字体颜色
        barItem.imgName = @"timeline_notify.png";
        barLabel.colorName = @"Timeline_Notice_color";
    }
    
    barLabel.text = [NSString stringWithFormat:@"%ld条新微博", count];
    //显示动画
    [UIView animateWithDuration:0.6
                     animations:^{
                         //...
                         barView.top = 10;
                         
                     } completion:^(BOOL finished) {
                         //...
                         if (finished) {
                             [UIView setAnimationDelay:1];
                             [UIView animateWithDuration:1
                                              animations:^{
                                        barView.top = -40;
                                              }];
                         }
                         
                     }];
    
    //注册系统声音
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    //从本地取Url
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    SystemSoundID systemID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &systemID);
    
    //播放系统声音
    AudioServicesPlaySystemSound(systemID);
    
    //移除
    AudioServicesRemoveSystemSoundCompletion(systemID);
    
    
    //刷新完之后，立即隐藏消息未读的提示视图（tabbar上的提示视图），这里也可以使用通知来实现
    MainTabBarController *mainCtl = (MainTabBarController *)self.tabBarController;
    //隐藏提醒未读消息视图，hiddenBadgeView此方法已经在MainTabBarController.h中公开出
    [mainCtl hiddenBadgeView];
    
}


#pragma mark -上拉刷新
- (void)loadDataUp
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@20 forKey:@"count"];
    if (self.data.count > 0) {
        //拿到最后一个model
        WeiboModel *weiboModel = [self.data lastObject];
        //参数中返回参数max_id，拿到比当前model早的微博
        [params setObject:weiboModel.weiboId forKey:@"max_id"];
    }
    
    //请求网络
    [DataService requestWithURL:home_timeline
                         params:params
                     httpMethod:@"GET"
                 finishDidBlock:^(AFHTTPRequestOperation *opertion, id result) {
                     //请求成功
                     NSArray *array = result[@"statuses"];
                     
                     NSMutableArray *mArr = [NSMutableArray array];
                     for (NSDictionary *dic in array) {
                         WeiboModel *model = [[WeiboModel alloc] initContentWithDic:dic];
                         [mArr addObject:model];

                     }
                     //判断拿到的数据数量大小是否大于1
                     if (mArr.count > 1) {
                         //大于1，要移除重复的微博
                         [mArr removeObjectAtIndex:0];
                         //然后拼接到当前数据数组后面
                         [self.data addObjectsFromArray:mArr];
                         
                         _tableView.data = self.data;
                         //刷新表视图
                         [_tableView reloadData];
                     }
                     
                     //停止刷新
                     [_tableView footerEndRefreshing];
                     
                 } failuerBlock:^(AFHTTPRequestOperation *opertion, NSError *error) {
                     //请求失败
                     NSLog(@"上拉请求失败");
                     //停止刷新
                     [_tableView footerEndRefreshing];

                 }];
    
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
