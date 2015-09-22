//
//  AppDelegate.h
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

//刷新数据代理协议
@protocol LogInDidRefreshDelegate <NSObject>

- (void)logInDidRefreshData;

@end

//实现微博的代理协议SinaWeiboDelegate
@interface AppDelegate : UIResponder <UIApplicationDelegate,SinaWeiboDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, nonatomic) SinaWeibo *sinaweibo;



//设置代理
@property (nonatomic, assign) id<LogInDidRefreshDelegate>loginDelegate;

@property (nonatomic, strong) UIWindow *secondWindow;


@end

