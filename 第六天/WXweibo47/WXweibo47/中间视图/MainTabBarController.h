//
//  MainTabBarController.h
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController

@property (nonatomic, strong) ThemeImageView *tarbarImgView;


//公开一个方法，隐藏未读的_badgeView
- (void)hiddenBadgeView;
@end
