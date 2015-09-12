//
//  ThemeManager.m
//  WXweibo47
//
//  Created by imac on 15/9/12.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "ThemeManager.h"

//单例
static ThemeManager *themeManager = nil;

@implementation ThemeManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        //...
        
        //拿到路径
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        //主题文件（字典）
        _themeConfiger = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        
        //主题的数据持久化
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *saveName = [defaults objectForKey:kThemeName];
        
        if (saveName.length == 0) {
            _themeName = @"猫爷";
        }else{
            _themeName = saveName;
            
        }
        
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSDictionary *themeDic = [defaults objectForKey:kChangeThemeName];
//        //系统启动时，判断字典中的_themeName是否有值，如果有则赋值给当前的_themeName
//        if ([themeDic objectForKey:kThemeName]) {
//            _themeName = [themeDic objectForKey:kThemeName];
//        }
        
        
        //修改状态栏的样式
        [self setStatusBarTitleColor];

        
    }
    return self;
}

//单例
+ (instancetype)shareThemeManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        themeManager = [[ThemeManager alloc] init];
        
    });
    
    return themeManager;
    
}

//根据主题的名字，获取当前主题下的图片
- (UIImage *)getThemeImageWithImageName:(NSString *)imageName
{
    //拿到路径，进行拼接
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@/%@", _themeConfiger[_themeName], imageName];
    //很据文件路径获取相应主题下的图片
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    
    return img;
}


//根据字体的key返回当前主题下的对应的颜色
- (UIColor *)getThemeColorWithTextColorKey:(NSString *)textColorKey
{
    
    //拿到相应主题下的config.plist文件
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@/config.plist", _themeConfiger[_themeName]];
    
    //根据文件拿到文字类型字典
    NSDictionary *textDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    //拿到对应的textColorKey的字典
    NSDictionary *textColorKeyDic = textDic[textColorKey];
    
    //判断字典中的元素的个数，如果有四个以上，就取出规定的alpha值，如果没有就返回1
    CGFloat alpha = textColorKeyDic.count >= 4 ? [textColorKeyDic[@"alpha"] floatValue] : 1;
    
    //根据字典里的RGB值和alpha值来返回相应的颜色
    UIColor *color = [UIColor colorWithRed:[textColorKeyDic[@"R"] floatValue] / 255.0 green:[textColorKeyDic[@"G"] floatValue] / 255.0 blue:[textColorKeyDic[@"B"] floatValue] / 255.0 alpha:alpha];
    
    return color;
}


//覆写set方法
- (void)setThemeName:(NSString *)themeName
{
    if (_themeName != themeName) {
        _themeName = themeName;
       
        //修改状态栏的样式，一定要放在发起通知之前
        [self setStatusBarTitleColor];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangeThemeName object:nil];
        
        
        //主题的数据持久化(_themeName改变时，修改存储的主题Key)
        [self storeAuthData];
        
        
    }
}

//修改状态栏的样式
- (void)setStatusBarTitleColor
{
    //拿到相应主题下的config.plist文件
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@/config.plist", _themeConfiger[_themeName]];
    
    //根据文件拿到文字类型字典
    NSDictionary *textDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSNumber *style = textDic[@"Statusbar_Style"];
    //赋值给自己的属性
    _statuBarStyle = [style integerValue];
    
    
}


//数据持久化,存储用户信息
- (void)storeAuthData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_themeName forKey:kThemeName];
    //同步
    [defaults synchronize];
    
}


@end
