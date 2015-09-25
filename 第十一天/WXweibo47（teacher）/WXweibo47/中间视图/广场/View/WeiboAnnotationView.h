//
//  WeiboAnnotationView.h
//  WXweibo47
//
//  Created by imac on 15/9/24.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WeiboAnnotationView : MKAnnotationView<WXLabelDelegate>
{
    //头像视图
    UIImageView *_userImageView;

    //微博图片
    UIImageView *_weiboImageView;

    //微博内容视图
    WXLabel *_textLabel;

}


@end
