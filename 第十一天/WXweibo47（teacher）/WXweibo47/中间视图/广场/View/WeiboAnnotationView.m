//
//  WeiboAnnotationView.m
//  WXweibo47
//
//  Created by imac on 15/9/24.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboModel.h"
#import "WeiboAnnotation.h"
#import "DetailViewController.h"


@implementation WeiboAnnotationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //...
        
        //初始化UI
        [self _initViews];
        
    }
    return self;
}
//初始化子视图
- (void)_initViews
{
    //微博图片
    _weiboImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_weiboImageView];
    
    //用户头像
    _userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _userImageView.layer.borderColor = [UIColor greenColor].CGColor;
    _userImageView.layer.borderWidth = 1;
    
    [self addSubview:_userImageView];
    
    //微博视图
    _textLabel = [[WXLabel alloc] initWithFrame:CGRectZero
                  ];
    _textLabel.font = [UIFont systemFontOfSize:12.0];
    _textLabel.numberOfLines = 3;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.wxLabelDelegate = self;
    _textLabel.textColor = [UIColor orangeColor];
    [self addSubview:_textLabel];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //安全判断
    WeiboModel *weiboModel = nil;
    if ([self.annotation isKindOfClass:[WeiboAnnotation class]]) {
        //...
        WeiboAnnotation *annotation = (WeiboAnnotation *)self.annotation;
        weiboModel = annotation.weiboModel;
        
    }else {
        return;
        
    }
    
    
    //判断当前微博是否有图片
    if (weiboModel.bmiddle_pic.length == 0) {
        //无图片
        //设置背景图片
        self.image = [UIImage imageNamed:@"nearby_map_content.png"];
        //隐藏微博图片视图
        _weiboImageView.hidden = YES;
        
        //设置头像的位置
        _userImageView.frame = CGRectMake(20, 20, 45, 45);
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:weiboModel.userModel.profile_image_url]];
        
        //设置微博文本
        _textLabel.hidden = NO;
        _textLabel.frame = CGRectMake(_userImageView.right + 5, _userImageView.top, 110, _userImageView.height);
        //赋值
        _textLabel.text = weiboModel.text;
        
        
    }else {
        //有图片
        //设置背景图片
        self.image = [UIImage imageNamed:@"nearby_map_photo_bg.png"];
        //显示微博图片视图
        _weiboImageView.hidden = NO;
        _weiboImageView.frame = CGRectMake(15, 15, 90, 85);
        
        [_weiboImageView sd_setImageWithURL:[NSURL URLWithString:weiboModel.bmiddle_pic]];
        
        //设置头像位置
        _userImageView.frame = CGRectMake(70, 65, 30, 30);
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:weiboModel.userModel.profile_image_url]];
        
        //隐藏微博文本
        _textLabel.hidden = YES;
        
        
    }
    
    
}
//当点击某一个标注视图时，push到详情界面，并把model传过去
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //安全判断
    WeiboModel *weiboModel = nil;
    if ([self.annotation isKindOfClass:[WeiboAnnotation class]]) {
        //...
        WeiboAnnotation *annotation = (WeiboAnnotation *)self.annotation;
        weiboModel = annotation.weiboModel;
        
    }else {
        return;
        
    }

    //进入详情界面
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.title = @"微博详情";
    
    //把数据传过去
    detailVC.model = weiboModel;
    
    //通过响应者链拿到navigationController
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
    
}





@end
