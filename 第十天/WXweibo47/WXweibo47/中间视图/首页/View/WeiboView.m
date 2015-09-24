//
//  WeiboView.m
//  WXweibo47
//
//  Created by imac on 15/9/16.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "WeiboView.h"

@implementation WeiboView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //...
        //初始化视图
        [self _createView];
        
    }
    return self;
}
//初始化视图
- (void)_createView
{
    //微博文本视图
    _weiboLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _weiboLabel.backgroundColor = [UIColor clearColor];
//    _weiboLabel.numberOfLines = 0;
    
    //设置代理WXLabelDelegate
    _weiboLabel.wxLabelDelegate = self;
    [self addSubview:_weiboLabel];
    
    
    //转发微博文本
    _reposterLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _reposterLabel.backgroundColor = [UIColor clearColor];
//    _reposterLabel.numberOfLines = 0;
    //设置代理
    _reposterLabel.wxLabelDelegate = self;
    [self addSubview:_reposterLabel];

    //微博图片
    _weiboImageView = [[ZoomImageView alloc] initWithFrame:CGRectZero];
    _weiboImageView.contentMode = UIViewContentModeScaleAspectFit;
    _weiboImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_weiboImageView];
    
    //转发微博内容下的背景图片
    _bgImageView = [[ThemeImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.topCapHeight = 25;
    _bgImageView.leftCapWidth = 25;
    _bgImageView.imgName = @"timeline_rt_border_9.png";
    [self insertSubview:_bgImageView atIndex:0];
    
    
}

- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        [self setNeedsLayout];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //计算自己发的微博文本的frame
    NSString *text = self.weiboModel.text;
    
//    CGRect rect = [text boundingRectWithSize:CGSizeMake(self.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14.0] forKey:NSFontAttributeName] context:nil];
    
    //使用第三方文件，WXLabel的类方法
    CGFloat weiboLabel_height = [WXLabel getAttributedStringHeightWithString:text WidthValue:self.width delegate:self font:[UIFont systemFontOfSize:WB(self.isDetail)]];
    
    _weiboLabel.frame = CGRectMake(0, 10, self.width, weiboLabel_height);
    _weiboLabel.font = [UIFont systemFontOfSize:WB(self.isDetail)];
    _weiboLabel.text = text;
    
    //计算转发的微博的frame
    if (self.weiboModel.reWeibo != nil) {
        //有转发内容
        _reposterLabel.hidden = NO;
        _bgImageView.hidden = NO;
        
        NSString *reText = self.weiboModel.reWeibo.text;
        
        //传进去文本，返回大小（第一种方式）
//        CGRect reRect = [reText boundingRectWithSize:CGSizeMake(self.width - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12.0] forKey:NSFontAttributeName] context:nil];
        
        //使用第三方文件，WXLabel的类方法
        CGFloat reposterLabel_height = [WXLabel getAttributedStringHeightWithString:reText WidthValue:self.width delegate:self font:[UIFont systemFontOfSize:RWB(self.isDetail)]];
        
        _reposterLabel.frame = CGRectMake(10, _weiboLabel.bottom + 10, self.width - 20, reposterLabel_height + 10);
        
        _reposterLabel.font = [UIFont systemFontOfSize:RWB(self.isDetail)];
        _reposterLabel.text = reText;
    
//        判断是否有图片
        if (self.weiboModel.reWeibo.bmiddle_pic.length != 0) {
            //转发微博有图片
            _weiboImageView.hidden = NO;
            
            _weiboImageView.frame = CGRectMake(10, _reposterLabel.bottom + 10, kWeiboViewImageHeight, kWeiboViewImageHeight);
            [_weiboImageView sd_setImageWithURL:[NSURL URLWithString:self.weiboModel.reWeibo.bmiddle_pic]];
            
            //为图片添加点击放大事件
            [_weiboImageView addTapZoomInImageViewWithFullUrlString:self.weiboModel.reWeibo.original_pic];
            
            
        }else {
            //转发微博没有图片
            _weiboImageView.hidden = YES;
            
        }
        
        
        //设置转发微博的背景图片
        float bgImageView_height = (self.weiboModel.reWeibo.bmiddle_pic.length == 0) ? _reposterLabel.height + 10 : _reposterLabel.height + kWeiboViewImageHeight + 10 + 20;
        _bgImageView.frame = CGRectMake(0, _weiboLabel.bottom, self.width, bgImageView_height + 10);
        

    }else {
        //没有转发内容
        _reposterLabel.hidden = YES;
        _bgImageView.hidden = YES;
        
        //判断是否有图片
        if (self.weiboModel.bmiddle_pic.length != 0) {
            //有图片
            _weiboImageView.hidden = NO;
            _weiboImageView.frame = CGRectMake(0, _weiboLabel.bottom + 10, kWeiboViewImageHeight, kWeiboViewImageHeight);
            
            [_weiboImageView sd_setImageWithURL:[NSURL URLWithString:self.weiboModel.bmiddle_pic]];
            
            //为图片添加点击放大事件
            [_weiboImageView addTapZoomInImageViewWithFullUrlString:self.weiboModel.original_pic];
            
            
        }else {
            //没有图片
            
            _weiboImageView.hidden = YES;
            
        }
    }
    
}

#pragma mark -WXLabelDelegate
//正则表达式，
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@[\\w\\s.]+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#[.……“……”\\w\\s]+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel
{
    return [UIColor blueColor];
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel
{
    return [UIColor redColor];
}


//手指离开当前超链接文本响应的协议方法
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context
{
    NSLog(@"离开当前超链接文本%@", context);
    
}
//手指接触当前超链接文本响应的协议方法
- (void)toucheBenginWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context
{
    NSLog(@"接触当前超链接文本%@", context);

}



@end
