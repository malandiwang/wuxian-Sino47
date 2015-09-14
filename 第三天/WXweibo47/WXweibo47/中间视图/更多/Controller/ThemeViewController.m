//
//  ThemeViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/13.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "ThemeViewController.h"

@interface ThemeViewController ()<UITableViewDataSource,UITableViewDelegate>

{
//    NSIndexPath *_lastIndexpath;
    
}

@end

@implementation ThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    

    [self _creatTableView];
    
    //加载数据
    [self _loadData];
    
}

//创建表视图
- (void)_creatTableView
{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.showsVerticalScrollIndicator = NO;
}


#pragma mark -UITableViewDataSource

//设置行，---每一组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

//返回一个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    // 获取当前主题类
    ThemeManager *themeManager = [ThemeManager shareThemeManager];
    
    if ([self.data[indexPath.row] isEqualToString:themeManager.themeName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = self.data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    return cell;
    
}


//单元格将被选中时调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 获取主题管家类
    ThemeManager *themeManager = [ThemeManager shareThemeManager];
    
    if (![themeManager.themeName isEqualToString:self.data[indexPath.row]]) {
        // 保存当前的主题
        // 改变当前的主题
        themeManager.themeName = self.data[indexPath.row];
        
        // 刷新表视图
        [_tableView reloadData];
        
    }
    
}


#pragma mark -加载数据
- (void)_loadData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
    NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSArray *themeName = [dataDic allKeys];
    
    self.data = themeName;
    
    //刷新
    [_tableView reloadData];
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
