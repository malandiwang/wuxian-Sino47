//
//  MessageViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "MessageViewController.h"
//#import "FaceView.h"
#import "FaceScrollView.h"

@interface MessageViewController ()<UIScrollViewDelegate>

{
    UIScrollView *scroll;
    UIPageControl *pageCtrl;
}

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"消息";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
//    FaceView *faceView = [[FaceView alloc] initWithFrame:CGRectZero];
//    faceView.backgroundColor = [UIColor grayColor];
//    
//    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, faceView.height)];
//    scroll.contentSize = CGSizeMake(faceView.width, faceView.height);
//    //关闭反弹效果
//    scroll.bounces = NO;
//    //设置分页
//    scroll.pagingEnabled = YES;
//    scroll.clipsToBounds = NO;
//    scroll.delegate = self;
//    scroll.showsHorizontalScrollIndicator = NO;
//    [scroll addSubview:faceView];
//    [self.view addSubview:scroll];
//    
//    pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
//    pageCtrl.bottom = scroll.bottom;
//    pageCtrl.numberOfPages = faceView.width / kScreenWidth;
//    
//    [pageCtrl addTarget:self action:@selector(pageCtrlAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:pageCtrl];
    
    
    //---------------使用block----------------//
    FaceScrollView *faceScrollView = [[FaceScrollView alloc] initWithBlock:^(NSString *faceName) {
        NSLog(@"%@", faceName);
    }];
    faceScrollView.top = 200;
    
    [self.view addSubview:faceScrollView];
    
}

////UIScrollView的代理方法
//#pragma mark -UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)myscrollView
//{
//    
//    //判断当下的滑动是否是scrollView（头视图中的滑动视图）
//    if (myscrollView == scroll) {
//        int page = myscrollView.contentOffset.x / kScreenWidth;
//        //当前页
//        pageCtrl.currentPage = page;
//    }
//    
//}
//
//- (void)pageCtrlAction:(UIPageControl *)myPageCtrl
//{
//    NSInteger count = myPageCtrl.currentPage;
//    [scroll setContentOffset:CGPointMake(count * kScreenWidth, 0) animated:YES];
//}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
