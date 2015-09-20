//
//  ZoomImageView.m
//  WXweibo47
//
//  Created by imac on 15/9/19.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "ZoomImageView.h"

@implementation ZoomImageView

//公开方法，为视图添加点击放大，具体实现则在内部实现，只需要把需要显示的大图片的地址传过来就行了
- (void)addTapZoomInImageViewWithFullUrlString:(NSString *)urlString
{
    //开启点击事件
    self.userInteractionEnabled = YES;
    
    if (urlString != nil) {
        _fullImageUrl = urlString;
        
    }
    
    //添加手势
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomInImageView:)];
    [self addGestureRecognizer:_tap];
    
}


//点击放大
- (void)zoomInImageView:(UITapGestureRecognizer *)tap
{
    //再次做安全判断
    if (self.image == nil) {
        return;
    }
    //初始化子视图
    [self _initViews];
    
    //给子视图_fullImageView设置frame（测试）
    //获取该视图相对于另一个视图的frame
//    CGRect rect = [self convertRect:self.bounds toView:self.window];
    //    NSLog(@"%@", NSStringFromCGRect(rect));
    
//    _fullImageView.frame = rect;

    //放大的动画
    [UIView animateWithDuration:0.35 animations:^{
        //实现放大
        CGFloat height = kScreenWidth / (self.image.size.width / self.image.size.height);
        _fullImageView.frame = CGRectMake(0, 0, kScreenWidth, MAX(height, kScreenHeight));
        //设置滑动视图的内容大小
        _scrollerView.contentSize = CGSizeMake(kScreenWidth, height);
        
        
    } completion:^(BOOL finished) {
        //判断传过来的大图的url地址，加载大图
        if (_fullImageUrl == nil) {
            return;
        }
        //有值，则加载大图
        [_fullImageView sd_setImageWithURL:[NSURL URLWithString:_fullImageUrl] placeholderImage:self.image options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //..
//            NSLog(@"%.2f", (CGFloat)receivedSize / expectedSize);
            _progressView.hidden = NO;
            _progressView.progress = (CGFloat)receivedSize / expectedSize;
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //...
            //加载大图完成之后调用的block

            [_progressView removeFromSuperview];
            _progressView = nil;
        }];
        
    }];
    
}

//初始化子视图
- (void)_initViews
{
    //初始化滑动视图
    if (_scrollerView == nil) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollerView.backgroundColor = [UIColor grayColor];

        //添加点击缩小的手势
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutImageView:)];
        [_scrollerView addGestureRecognizer:tap1];
        
    }
    //添加到window上
    [self.window addSubview:_scrollerView];
    
    //初始化放大视图
    if (_fullImageView == nil) {
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.image = self.image;
        _fullImageView.contentMode = self.contentMode;
        [_scrollerView addSubview:_fullImageView];
    }

    if (_progressView == nil) {
        //初始化加载进度条
        _progressView = [[DDProgressView alloc] initWithFrame:CGRectMake(10, (kScreenHeight - 15) / 2, kScreenWidth - 20, 15)];
        //设置样式
        _progressView.outerColor = [UIColor grayColor];
        _progressView.innerColor = [UIColor yellowColor];
        _progressView.emptyColor = [UIColor whiteColor];
        
    }
    
    //添加到window上
    [self.window addSubview:_progressView];
    
}

//缩小图片的方法
- (void)zoomOutImageView:(UITapGestureRecognizer *)tap
{
    
    //移除进度条
    [_progressView removeFromSuperview];
    _progressView = nil;
    
    //执行缩小的方法
    [UIView animateWithDuration:0.3 animations:^{
        //...
        //相对缩小到原来的 位置
        _fullImageView.frame = [self convertRect:self.bounds fromView:self.window];
        
        _scrollerView.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        //...
        [_scrollerView removeFromSuperview];
        _scrollerView = nil;
        
        [_fullImageView removeFromSuperview];
        _fullImageView = nil;
        
    }];
}





@end
