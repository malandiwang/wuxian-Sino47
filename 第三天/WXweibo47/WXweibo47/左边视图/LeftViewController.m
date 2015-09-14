//
//  LeftViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/13.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "LeftViewController.h"
#import "MMExampleDrawerVisualStateManager.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_animationArr;
    NSArray *_imgMode;
    
    NSIndexPath *_lastIndexPathTop;
    NSIndexPath *_lastIndexPathDown;
    

}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    _tableView.scrollEnabled = NO;
    
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    _animationArr = @[@"无", @"偏移", @"偏移&旋转", @"旋转", @"视差"];
    _imgMode = @[@"小图", @"大图"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;

}


#pragma mark -UITableViewDataSource
//设置组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//设置行，---每一组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 2;
}

//返回一个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //单元格复用
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //赋值
    if (indexPath.section == 0) {
        cell.textLabel.text = _animationArr[indexPath.row];
        
    }else {
        cell.textLabel.text = _imgMode[indexPath.row];
        
    }
    
    //获取UserDefaults
    NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
    
    if (indexPath.section == 0) {
        //构建动画类型的CELL
        NSDictionary *dic = [userDefalts objectForKey:kDrawAnimationType];
        NSNumber *type = [dic objectForKey:kDrawLeftType];
        if (indexPath.row == [type integerValue]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if (indexPath.section == 1){
        NSNumber *imgScale = [userDefalts objectForKey:kImageScale];
        if (indexPath.row == [imgScale integerValue]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;

        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;

        }
    }
    
    
    return cell;
}



#pragma mark -UITableViewDelegate

//设置指定单元格row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//设置section的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //第六个，UILabel
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2, 100, 200, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor orangeColor];
    
    label.backgroundColor = [UIColor clearColor];
    
    label.font = [UIFont boldSystemFontOfSize:18.0];
    
    if (section == 0) {
        label.text = @"界面切换效果";
    }else {
        label.text = @"图片浏览模式";
    }
    return label;
}


//单元格将被选中时调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"左侧滑界面动画section:%ld----row:%ld", indexPath.section, indexPath.row);
    
    if (indexPath.section == 0) {
        //改变动画类型
        [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:indexPath.row];
        [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:indexPath.row];
        
        //保存动画，在MMExampleDrawerVisualStateManager.h中写一个保存数据的方法
        [[MMExampleDrawerVisualStateManager sharedManager] saveConfig];
        
        
    }else if (indexPath.section == 1) {
        //切换图片浏览模式
        //数据持久化
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@(indexPath.row) forKey:kImageScale];
        [defaults synchronize];
    }
    
    //刷新表视图
    [_tableView reloadData];

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
