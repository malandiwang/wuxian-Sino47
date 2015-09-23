//
//  BaseNavigationController.m
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseNavigationController.h"

#import "MainTabBarController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController


-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChangeThemeName object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadNavigationImg) name:kChangeThemeName object:nil];
    
    
    //设置导航栏为不透明
    self.navigationBar.translucent = NO;
    
    //设置代理
    self.delegate = self;
    
    //设置导航栏背景图片
    [self _loadNavigationImg];
    
}


//设置导航栏背景图片
- (void)_loadNavigationImg
{
//    //获取图片
//    NSString *imgNav = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Skins/fisheye/mask_titlebar.png"];
//    
//    UIImage *img = [UIImage imageWithContentsOfFile:imgNav];
    
    UIImage *img = [[ThemeManager shareThemeManager] getThemeImageWithImageName:@"mask_titlebar.png"];
    
    
    //修改图片的大小
    UIGraphicsBeginImageContext(CGSizeMake(kScreenWidth, 64));
    [img drawInRect:CGRectMake(0, 0, kScreenWidth, 84)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    
    //刷新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
    
}

//设置状态栏为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    //直接返回ThemeManager（主题管家）（状态栏为枚举值）
    return [ThemeManager shareThemeManager].statuBarStyle;
    
}

//使用导航栏的代理方法来监听导航控制器下有几个视图控制器，以此来实现隐藏和现实自定义的标签栏
#pragma mark -UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSInteger count = self.viewControllers.count;
    
    MainTabBarController *tabCtrl = (MainTabBarController*)self.tabBarController;
    if (count == 1) {
        //..
        //不隐藏
//        [UIView animateWithDuration:0.1 animations:^{
//            //..
//            tabCtrl.tarbarImgView.right = kScreenWidth;
//            
//        }];
        //使用了WXNavigationController，不在自定义动画
        tabCtrl.tarbarImgView.hidden = NO;
        
    }else if (count == 2){
        //隐藏
//        tabCtrl.tarbarImgView.right = 0;
        
        tabCtrl.tarbarImgView.hidden = YES;
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
