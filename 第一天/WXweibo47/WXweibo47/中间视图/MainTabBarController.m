//
//  MainTabBarController.m
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

{
    UIImageView *_selectedImgView;
    
}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //自定义标签栏
    [self _creatTabbar];
    
}

//自定义标签栏
- (void)_creatTabbar
{
    
    //隐藏标签栏
    self.tabBar.hidden = YES;
    //初始化自定义的tabBar
    _tarbarImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 55, kScreenWidth, 55)];
    
    //获取图片路径
    NSString *imgPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Skins/fisheye/mask_navbar.png"];
    //通过路径拿到照片
    _tarbarImgView.image = [UIImage imageWithContentsOfFile:imgPath];
    
    //开启触摸接受事件
    _tarbarImgView.userInteractionEnabled = YES;

    _selectedImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 55)];
    
    
    
//    //获取图片路径
    NSString *selectImgPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Skins/fisheye/home_bottom_tab_arrow.png"];
    _selectedImgView.image = [UIImage imageWithContentsOfFile:selectImgPath];
    
//    [_tarbarImgView addSubview:_selectedImgView];
        [self.view addSubview:_tarbarImgView];
    
    //循环创建按钮标签
    NSArray *imageNames = @[@"home_tab_icon_1.png",@"home_tab_icon_2.png",@"home_tab_icon_3.png",@"home_tab_icon_4.png",@"home_tab_icon_5.png"];
    for (int i = 0; i < imageNames.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kScreenWidth / 5.0 * i, 0, kScreenWidth / 5.0, 55);
        
        //设置按钮图片
        //获取图片路径
        NSString *btnimagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/Skins/fisheye/%@", imageNames[i]];
        
        [button setImage:[UIImage imageWithContentsOfFile:btnimagePath] forState:UIControlStateNormal];
        
        
        //设置点击事件
        button.tag = 100 + i;
        [button addTarget:self action:@selector(tabBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_tarbarImgView addSubview:button];
        
        if (i == 0) {
            _selectedImgView.center = button.center;
        }
    
    
    }
}

- (void)tabBarItemAction:(UIButton *)btn
{
    self.selectedIndex = btn.tag - 100;
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         _selectedImgView.center = btn.center;
                     }];
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based applifisheyeion, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
