//
//  FaceView.h
//  WXweibo47
//
//  Created by imac on 15/9/22.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSString *faceName);

@interface FaceView : UIView

{
    NSMutableArray *_items; //大数组
    //放大镜
    UIImageView *_magnifierView;
    //选中的表情名
    NSString *_selectedFaceName;

    
}


@property (nonatomic, copy) SelectedBlock block;


@end
