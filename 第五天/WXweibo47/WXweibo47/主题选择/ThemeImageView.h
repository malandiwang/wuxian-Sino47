//
//  ThemeImageView.h
//  WXweibo47
//
//  Created by imac on 15/9/12.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

@property (nonatomic, copy) NSString *imgName;  //图片名字

@property (nonatomic, assign) NSInteger leftCapWidth;  //左拉伸点

@property (nonatomic, assign) NSInteger topCapHeight;  //右拉伸点


@end
