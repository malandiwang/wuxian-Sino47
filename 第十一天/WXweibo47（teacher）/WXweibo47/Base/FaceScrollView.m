//
//  FaceScrollView.m
//  WXweibo47
//
//  Created by imac on 15/9/22.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "FaceScrollView.h"

@implementation FaceScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //...
        //初始化视图
        [self _initViews];
    }
    return self;
}


//自定义block
- (id)initWithBlock:(SelectedBlock)block
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        //...
        
        _faceView.block = block;
    }
    
    return self;
}

//初始化视图
- (void)_initViews
{
    
    self.width = kScreenWidth;
    
    _faceView = [[FaceView alloc] initWithFrame:CGRectZero];
    _faceView.backgroundColor = [UIColor clearColor];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _faceView.height)];
    
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.clipsToBounds = NO;
    _scrollView.contentSize = CGSizeMake(_faceView.width, 0);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    [_scrollView addSubview:_faceView];
    [self addSubview:_scrollView];
    
    
    _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.bottom, kScreenWidth, 20)];
    _pageCtrl.numberOfPages = _faceView.width / kScreenWidth;
    _pageCtrl.backgroundColor = [UIColor clearColor];
    [_pageCtrl addTarget:self action:@selector(pageCtrlAction:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:_pageCtrl];
    
    self.height = _scrollView.height + _pageCtrl.height;
    
}

- (void)pageCtrlAction:(UIPageControl *)mypageCtrl
{
    NSInteger count = mypageCtrl.currentPage;
    [_scrollView setContentOffset:CGPointMake(count * kScreenWidth, 0) animated:YES];
    
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageCtrl.currentPage = _scrollView.contentOffset.x / kScreenWidth;
}


- (void)drawRect:(CGRect)rect
{
    //把背景视图设置上
    UIImage *img = [UIImage imageNamed:@"emoticon_keyboard_background.png"];
    [img drawInRect:rect];
    
}

@end
