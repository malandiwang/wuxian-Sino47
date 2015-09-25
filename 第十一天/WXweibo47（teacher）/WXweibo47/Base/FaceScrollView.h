//
//  FaceScrollView.h
//  WXweibo47
//
//  Created by imac on 15/9/22.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"

//再次封装,使用block回调
@interface FaceScrollView : UIView<UIScrollViewDelegate>

{
    FaceView *_faceView;
    UIScrollView *_scrollView;
    UIPageControl *_pageCtrl;
    
}
//自定义block
- (id)initWithBlock:(SelectedBlock)block;



@end
