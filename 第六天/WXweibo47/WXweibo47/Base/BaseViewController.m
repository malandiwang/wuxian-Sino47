//
//  BaseViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

{
    //自定义，提醒视图
    UIView *_tipView;
    //第三方，提醒视图
    MBProgressHUD *_hud;
    
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //自定义导航栏的标题视图
    [self _initTitleLabel];
}

//自定义导航栏的标题视图
- (void)_initTitleLabel
{
    //第六个，UILabel
    ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.text = self.navigationItem.title;
    
    label.colorName = @"Mask_Title_color";
    
    self.navigationItem.titleView = label;
    
}

//显示或隐藏正在加载(自定义)
//- (void)showLoading:(BOOL)show
//{
//    if (_tipView == nil) {
//        _tipView = [[UIView alloc] initWithFrame:self.view.bounds];
//        _tipView.backgroundColor = [UIColor whiteColor];
//        
//        //创建label
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (_tipView.height-20)/2 - 100, _tipView.width, 20)];
//        label.text = @"正在加载。。。";
//        label.textAlignment = NSTextAlignmentCenter;
//        label.backgroundColor = [UIColor clearColor];
//        [_tipView addSubview:label];
//        
//        //创建风火轮
//        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [activity startAnimating];
//        activity.frame = CGRectMake(100, label.top, 20, 20);
//        [_tipView addSubview:activity];
//        
//    }
//    //判断传过来的bool值
//    if (show) {
//        [self.view addSubview:_tipView];
//        
//    }else {
//        [_tipView removeFromSuperview];
//    }
//}



//显示或隐藏正在加载(使用第三方HUD)
//使用第三方文件/显示或隐藏正在加载
- (void)showHUD:(NSString *)title
{
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    //背景变暗
    _hud.dimBackground = YES;
    
    //设置文本
    _hud.labelText = title;
    
}


//隐藏 HUD
- (void)hiddenHUD
{
    //1秒后隐藏提醒视图
    [_hud hide:YES afterDelay:1];
    
}


//加载完成提示HUD
- (void)completeHUD:(NSString *)title
{
    //设置加载完成后，显示的提醒视图和文本
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //一定要设置提醒视图的模式
    _hud.mode = MBProgressHUDModeCustomView;
    //设置提醒的文本
    _hud.labelText = title;
    //1.5秒后隐藏提醒视图
    [_hud hide:YES afterDelay:1.5];
    
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
