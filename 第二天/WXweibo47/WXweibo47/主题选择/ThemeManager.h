//
//  ThemeManager.h
//  WXweibo47
//
//  Created by imac on 15/9/12.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject


@property (nonatomic, copy) NSString *themeName;    //主题的名字

@property (nonatomic, strong) NSDictionary *themeConfiger;  //主题名字与路径的信息

//电池条的标示
@property (nonatomic, assign, readonly) NSInteger statuBarStyle;


//单例
+ (instancetype)shareThemeManager;

//根据主题的名字，获取当前主题下的图片
- (UIImage *)getThemeImageWithImageName:(NSString *)imageName;

//根据字体的key返回当前主题下的对应的颜色
- (UIColor *)getThemeColorWithTextColorKey:(NSString *)textColorKey;


@end
