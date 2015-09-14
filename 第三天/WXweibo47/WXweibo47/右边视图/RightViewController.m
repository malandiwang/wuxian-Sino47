//
//  RightViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/13.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建视图
    [self _createView];
    
}

//创建视图
- (void)_createView
{
    
    //创建五个按钮
    NSArray *imgOfButton = @[@"newbar_icon_1.png",@"newbar_icon_2.png",@"newbar_icon_3.png",@"newbar_icon_4.png",@"newbar_icon_5.png"];
    
    for (int i = 0; i < imgOfButton.count; i ++) {
        ThemeButton *btn = [[ThemeButton alloc] initWithFrame:CGRectMake(10, 50 + 40 * i + 15 * i, 40, 40)];
        
        btn.tag = 2015 + i;
        
        btn.imgName = imgOfButton[i];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
        
    }
    
   //创建下面的两个按钮
    //创建地图按钮
    UIButton *mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 430, 60, 60)];
    
    [mapBtn addTarget:self action:@selector(mapClick:) forControlEvents:UIControlEventTouchUpInside];

    [mapBtn setImage:[UIImage imageNamed:@"btn_map_location.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:mapBtn];
    
    
    //创建二维码按钮
    UIButton *imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 500, 60, 60)];
    
    [imgBtn addTarget:self action:@selector(imgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [imgBtn setImage:[UIImage imageNamed:@"qr_btn.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:imgBtn];
}


//五个小按钮触发事件
- (void)btnClick:(ThemeButton *)btn
{
    if (btn.tag == 2015) {
        //发微博
        NSLog(@"发微博-------不可能");
    }
}

//地图按钮触发事件
- (void)mapClick:(UIButton *)btn
{
    NSLog(@"没有地图");
}

//二维码按钮触发事件
- (void)imgBtnClick:(UIButton *)btn
{
    NSLog(@"没有相机");
}


//设置状态栏
- (UIStatusBarStyle)preferredStatusBarStyle
{
    NSInteger style = [ThemeManager shareThemeManager].statuBarStyle;
    if (style == 0) {
        return UIStatusBarStyleDefault;
    }
    
    return UIStatusBarStyleLightContent;
}







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
