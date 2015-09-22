//
//  BaseViewController.h
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController

//显示或隐藏正在加载（自定义），公开的方法
//- (void)showLoading:(BOOL)show;


//使用第三方文件/显示或隐藏正在加载
- (void)showHUD:(NSString *)title;

//隐藏 HUDProg
- (void)hiddenHUD;

//加载完成提示HUD
- (void)completeHUD:(NSString *)title;






@end
