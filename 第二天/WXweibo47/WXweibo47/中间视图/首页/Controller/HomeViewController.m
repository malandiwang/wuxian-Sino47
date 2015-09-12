//
//  HomeViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "HomeViewController.h"

#import "ThemeManager.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"首页";
    
    //使程序启动时就弹出登陆界面
    [self _logIn];
    
    
    //------------------测试------------------//
//    //UILabel(text)
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
//    label.text = @"主题颜色";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.backgroundColor = [UIColor grayColor];
//    label.font = [UIFont boldSystemFontOfSize:20];
//    
//    //根据封装的ThemeManager（主题管家）来返回字体的RGB
//    label.textColor = [[ThemeManager shareThemeManager] getThemeColorWithTextColorKey:@"Channel_Dot_color"];
//    
//    [self.view addSubview:label];
//    
    

}

- (IBAction)pushAction:(id)sender {
    
    UIViewController *secondVC = [[UIViewController alloc] init];
    secondVC.view.backgroundColor = [UIColor orangeColor];
    
    [self.navigationController pushViewController:secondVC animated:YES];
    
}


//登录
- (void)_logIn
{
    AppDelegate *delegata = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegata.sinaweibo logIn];

    
}

//- (IBAction)logInAction:(id)sender {
//    
//    AppDelegate *delegata = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    
//    [delegata.sinaweibo logIn];
//}


//text
//cat主题
- (IBAction)catAction:(UIButton *)sender {
    
    ThemeManager *themeManager = [ThemeManager shareThemeManager];
    themeManager.themeName = sender.titleLabel.text;
    
}

//bluemoon主题
- (IBAction)bluemoonAction:(UIButton *)sender {
    
    ThemeManager *themeManager = [ThemeManager shareThemeManager];
    
    themeManager.themeName = sender.titleLabel.text;
    
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
