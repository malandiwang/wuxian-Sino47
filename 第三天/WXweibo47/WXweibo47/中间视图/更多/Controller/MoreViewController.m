//
//  MoreViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "MoreViewController.h"

#import "MoreTableViewCell.h"

#import "ThemeViewController.h"


@interface MoreViewController ()
{
    NSArray *firstLabelText;
    NSArray *imgName;
}
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"更多";
    
    //使用通知刷新表视图（第一种方法）
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadName) name:@"ChangeLabelText" object:nil];
    
    
    //拿到数据
    imgName = @[@"more_icon_theme.png", @"more_icon_account.png", @"more_icon_feedback.png"];
    
    firstLabelText = @[@"主题", @"账户管理", @"意见反馈", @"注销当前账号"];
    
    //创建表视图
    [self _creatTableView];
    
    
}

//创建表视图
- (void)_creatTableView
{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //设置不能拉伸
    _tableView.scrollEnabled = NO;
    
    
}

#pragma mark -UITableViewDataSource
//设置组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//设置行，---每一组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    
    return 1;
}

//返回一个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //从XIB中加载Cell
    MoreTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreTableViewCell" owner:nil options:nil] lastObject];
    
    if (indexPath.section == 2) {
        //..
        
        //UILabel
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2, 0, 200, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor orangeColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:17.0];

        label.text = firstLabelText[3];
        
        [cell.contentView addSubview:label];
        
        cell.imgView.hidden = YES;
        cell.firstLabel.hidden = YES;
        
    }else if (indexPath.section == 1) {
        //...
        
        cell.firstLabel.text = firstLabelText[2];
        cell.imgView.imgName = imgName[2];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        
    }else if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            cell.themeLabel.text = [ThemeManager shareThemeManager].themeName;
            
            cell.themeLabel.hidden = NO;

            
        }
        
        cell.firstLabel.text = firstLabelText[indexPath.row];
        cell.imgView.imgName = imgName[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


#pragma mark -UITableViewDelegate


//设置section的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 44;
    }
    
    return 20;
}

//单元格将被选中时调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"section:%ld----row:%ld", indexPath.section, indexPath.row);
    if (indexPath.section == 0 && indexPath.row == 0) {
        //push
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        
        [self.navigationController pushViewController:themeVC animated:YES];
    }
    
}

////使用通知刷新表视图（第一种方法）
//- (void)_loadName
//{
//    //主题改变时刷新表视图
//    [_tableView reloadData];
//    
//}



//视图将要出现时刷新表视图（第二种方法）
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
