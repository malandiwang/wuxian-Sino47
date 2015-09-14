//
//  RootDrawerController.m
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "RootDrawerController.h"

#import "MMExampleDrawerVisualStateManager.h"

@interface RootDrawerController ()

@end

@implementation RootDrawerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    
    //先拿到故事版
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //从故事版中拿到控制器
    //左边的控制器
    self.leftDrawerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"LeftVC"];
    //中间的控制器
    self.centerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"CenterVC"];
    //右边的控制器
    self.rightDrawerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"RightVC"];
    
    //设置控制器的属性
    //设置阴影
    [self setShowsShadow:YES];
    
    //设置显示左右的宽度
    [self setMaximumRightDrawerWidth:60.0];
    [self setMaximumLeftDrawerWidth:160.0];
    
    //设置手势的作用区域
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    //配置动画的回调函数
    [self
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    
    
    //程序启动时设置为数据持久化的动画
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:kDrawAnimationType];
    NSNumber *drawLeftType = [dic objectForKey:kDrawLeftType];
    NSNumber *drawrightType = [dic objectForKey:kDrawRightType];
    

    //设置动画
    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:[drawLeftType integerValue]];
    [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:[drawrightType integerValue]];
    

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
