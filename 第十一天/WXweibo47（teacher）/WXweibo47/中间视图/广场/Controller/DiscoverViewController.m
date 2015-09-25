//
//  DiscoverViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearByViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"广场";
    
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化视图
      [self _initViews];
}

- (void)_initViews
{
    NSArray *titles = @[@"附近微博",@"附近的人"];
    // 循环创建视图
    for (int i = 0; i < titles.count; i++) {
        // 创建按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        float jl = (kScreenWidth - 70 * 3) / 4.0;
        button.frame = CGRectMake(jl + (i % 3) * (jl + 70), 30 + (i / 3) * 120, 70, 70);
        // 添加图片
        NSString *imageName = [NSString stringWithFormat:@"%@.jpg",titles[i]];
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        // 添加事件
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // 设置阴影效果
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(2, 2);
        button.layer.shadowOpacity = 1;
        [self.view addSubview:button];
        
        // 创建文本视图
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.left, button.bottom + 5, button.width, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = titles[i];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:titleLabel];
        
    }
}

//按钮点击事件
- (void)buttonAction:(UIButton *)btn
{
    NearByViewController *nearVC = [[NearByViewController alloc] init];
    nearVC.title = @"周边";
    NSLog(@"text 测试");
    [self.navigationController pushViewController:nearVC animated:YES];
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
