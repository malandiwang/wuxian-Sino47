//
//  ThemeImageView.m
//  WXweibo47
//
//  Created by imac on 15/9/12.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "ThemeImageView.h"

@implementation ThemeImageView

-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChangeThemeName object:nil];
}
//init方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //..
        //接受通知
        [self _initViews];
    }
    return self;
}
//从XIB中加载
-(void)awakeFromNib
{
    [super awakeFromNib];
    //接受通知

    [self _initViews];
    
}


//接受通知
- (void)_initViews
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadView) name:kChangeThemeName object:nil];
    
}

- (void)setImgName:(NSString *)imgName
{
    if (_imgName != imgName) {
        _imgName = [imgName copy];
        
        //保证程序一进来就有主题
        [self _loadView];
    }
}

//刷新UI
- (void)_loadView
{
    //刷新UI
    UIImage *img = [[ThemeManager shareThemeManager] getThemeImageWithImageName:self.imgName];
    
    //设置图片拉伸点
    img = [img stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    
    self.image = img;
    
    
}










@end
