//
//  BaseNavigationController.h
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXNavigationController.h"
//改成继承WXNavigationController，实现视差动画
@interface BaseNavigationController : WXNavigationController<UINavigationControllerDelegate>

@end
