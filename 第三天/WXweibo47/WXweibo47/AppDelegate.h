//
//  AppDelegate.h
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
//实现微博的代理协议SinaWeiboDelegate
@interface AppDelegate : UIResponder <UIApplicationDelegate,SinaWeiboDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, nonatomic) SinaWeibo *sinaweibo;


@end

