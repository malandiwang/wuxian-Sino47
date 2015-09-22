//
//  MainTabBarController.m
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

{
    ThemeImageView *_selectedImgView;
    
    ThemeImageView *_badgeView;
    
}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //自定义标签栏
    [self _creatTabbar];
    
    //创建定时器，轮询http请求
    [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(timerAction:)
                                   userInfo:nil
                                    repeats:YES];
    
    
}


//定时器
- (void)timerAction:(NSTimer *)timer
{
    //判断当前是否已经登录
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //拿到程序的userID
    NSString *uID = delegate.sinaweibo.userID;
    if (uID.length == 0) {
        return;
    }
    //传入参数uid，获取未读的微博
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:uID forKey:@"uid"];
    
    //请求网络
    [DataService requestWithURL:unread_count
                         params:params
                     httpMethod:@"GET"
                 finishDidBlock:^(AFHTTPRequestOperation *opertion, id result) {
                     //请求成功
                    //创建提醒视图
                     //使用懒加载模式
                     if (_badgeView == nil) {
                         _badgeView = [[ThemeImageView alloc] initWithFrame:CGRectMake(kScreenWidth/5-32, 0, 32, 32)];
                        _badgeView.imgName = @"number_notify_9.png";
                         [_tarbarImgView addSubview:_badgeView];
                         
                         ThemeLabel *unReadLabel = [[ThemeLabel alloc] initWithFrame:_badgeView.bounds];
                         unReadLabel.tag = 100;
                         unReadLabel.textAlignment = NSTextAlignmentCenter;
                         unReadLabel.font = [UIFont systemFontOfSize:13];
                         unReadLabel.backgroundColor = [UIColor clearColor];
                         unReadLabel.colorName = @"Timeline_Notice_color";
                         [_badgeView addSubview:unReadLabel];
                         
                     }
                     
                     NSNumber *status = result[@"status"];
                     NSInteger unread = [status integerValue];
                     if (unread > 0) {
                         _badgeView.hidden = NO;
                         //有新消息
                         
                         //如果新消息数量大于99，则显示99
                         if (unread > 99) {
                             unread = 99;
                         }
                         ThemeLabel *unreadLabel = (ThemeLabel *)[_badgeView viewWithTag:100];
                         unreadLabel.text = [NSString stringWithFormat:@"%ld", unread];
                         
                     }else {
                         //没有新消息，隐藏提醒视图
                         _badgeView.hidden = YES;
                     }
                     
                 } failuerBlock:^(AFHTTPRequestOperation *opertion, NSError *error) {
                     //请求失败
                     NSLog(@"unread is error:%@", error);
                     
                 }];
}

//公开一个方法，隐藏未读的_badgeView
- (void)hiddenBadgeView
{
    _badgeView.hidden = YES;
    
}


//自定义标签栏
- (void)_creatTabbar
{
    
    //隐藏标签栏
    self.tabBar.hidden = YES;
    //初始化自定义的tabBar
    _tarbarImgView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 55, kScreenWidth, 55)];
    
//    //获取图片路径
//    NSString *imgPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Skins/fisheye/mask_navbar.png"];
//    //通过路径拿到照片
//    _tarbarImgView.image = [UIImage imageWithContentsOfFile:imgPath];
    
    
//    //使用封装好的主题管家ThemeManager来设置图片
//    _tarbarImgView.image = [[ThemeManager shareThemeManager] getThemeImageWithImageName:@"mask_navbar.png"];
    
    
    //使用封装号的UIImageView来刷新UI
    _tarbarImgView.imgName = @"mask_navbar.png";
    
    
    
    //开启触摸接受事件
    _tarbarImgView.userInteractionEnabled = YES;

    _selectedImgView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 55)];
    
    
    
//    //获取图片路径
//    NSString *selectImgPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Skins/fisheye/home_bottom_tab_arrow.png"];
//    _selectedImgView.image = [UIImage imageWithContentsOfFile:selectImgPath];
    
    //使用封装号的UIImageView来刷新UI
    _selectedImgView.imgName = @"home_bottom_tab_arrow.png";

    
    [_tarbarImgView addSubview:_selectedImgView];
    
        [self.view addSubview:_tarbarImgView];
    
    //循环创建按钮标签
    NSArray *imageNames = @[@"home_tab_icon_1.png",@"home_tab_icon_2.png",@"home_tab_icon_3.png",@"home_tab_icon_4.png",@"home_tab_icon_5.png"];
    for (int i = 0; i < imageNames.count; i++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(kScreenWidth / 5.0 * i, 0, kScreenWidth / 5.0, 55)];
//        button.frame = CGRectMake(kScreenWidth / 5.0 * i, 0, kScreenWidth / 5.0, 55);
        
//        //设置按钮图片
//        //获取图片路径
//        NSString *btnimagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/Skins/fisheye/%@", imageNames[i]];
//        
//        [button setImage:[UIImage imageWithContentsOfFile:btnimagePath] forState:UIControlStateNormal];
//
        
        //使用封装号的UIButton来刷新UI
        button.imgName = imageNames[i];
        
        
        //设置点击事件
        button.tag = 100 + i;
        [button addTarget:self action:@selector(tabBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_tarbarImgView addSubview:button];
        
        if (i == 0) {
            _selectedImgView.center = button.center;
        }
    
    
    }
}


- (void)tabBarItemAction:(UIButton *)btn
{
    self.selectedIndex = btn.tag - 100;
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         _selectedImgView.center = btn.center;
                     }];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based applifisheyeion, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
