//
//  AppDelegate.m
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "RootDrawerController.h"
#import "MainTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    
    //设置侧滑视图的背景图片，window的图片（侧滑视图的背景颜色都设置为透明）
    ThemeImageView *imgView = [[ThemeImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    imgView.imgName = @"mask_bg.jpg";
    [self.window addSubview:imgView];
    
    
    
    
    _sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        _sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        _sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        _sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    
    return YES;
    
}

//登录成功时调用的方法
#pragma mark -SinaWeiboDelegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"登录成功，一点都不开心！！！");
    
    //登陆成功后保存用户信息，sso，数据持久化
    [self storeAuthData];
    
//    RootDrawerController *rootVC = (RootDrawerController *)self.window.rootViewController;
//    MainTabBarController *mainTBC = (MainTabBarController *)rootVC.centerViewController;
//    UINavigationController *nav = mainTBC.viewControllers[0];
//    HomeViewController *homeVC = (HomeViewController *)nav.topViewController;
//    [homeVC loginDidRefreshData];

    
    
    //登录成功后让代理（HomeViewController）去刷新数据
    //安全判断
    if ([self.loginDelegate respondsToSelector:@selector(logInDidRefreshData)]) {
        //如果响应了就去刷新数据
        [self.loginDelegate logInDidRefreshData];
        
    }
    

}

//数据持久化,存储用户信息
- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
