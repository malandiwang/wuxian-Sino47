//
//  WeiboView.h
//  WXweibo47
//
//  Created by imac on 15/9/16.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "ZoomImageView.h"

@interface WeiboView : UIView<WXLabelDelegate>

{
    //换成WXLabel
    WXLabel *_weiboLabel;   //微博文本
    WXLabel *_reposterLabel; //转发文本
    
    ZoomImageView *_weiboImageView;    //微博图片
    ThemeImageView *_bgImageView;   //背景图片
    
}

//把model传过来，在内部处理
@property (nonatomic, strong) WeiboModel *weiboModel;

@property (nonatomic, assign) BOOL isDetail;


@end
