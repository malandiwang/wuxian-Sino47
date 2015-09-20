//
//  ZoomImageView.h
//  WXweibo47
//
//  Created by imac on 15/9/19.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDProgressView.h"


@interface ZoomImageView : UIImageView

{
    //放大后的滑动视图
    UIScrollView *_scrollerView;
    //放大的图片视图
    UIImageView *_fullImageView;
    //放大的手势
    UITapGestureRecognizer *_tap;
    //放大后的图片地址
    NSString *_fullImageUrl;
    //加载进度条
    DDProgressView *_progressView;
    
}

//公开方法，为视图添加点击放大，具体实现则在内部实现，只需要把需要显示的大图片的地址传过来就行了
- (void)addTapZoomInImageViewWithFullUrlString:(NSString *)urlString;


@end
