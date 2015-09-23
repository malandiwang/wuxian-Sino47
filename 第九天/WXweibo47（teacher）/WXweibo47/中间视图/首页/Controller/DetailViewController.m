//
//  DetailViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/19.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor = [UIColor redColor];
    //关闭视图控制器的自动偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建表视图的头视图(这里的顺序特别重要)
    [self _createTableViewHeader];
    
    //创建表视图
    [self _createTableView];

    //_headView作为表视图的头视图
    _tableView.tableHeaderView = _headView;
    
    //请求数据(加载评论数据)
    [self _loadData];
    
}

//请求数据
- (void)_loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@20 forKey:@"count"];
    [params setObject:self.model.weiboId forKey:@"id"];
    
    
    [DataService requestWithURL:comments_show
                         params:params
                     httpMethod:@"GET"
                 finishDidBlock:^(AFHTTPRequestOperation *opertion, id result) {
                     //请求成功
                     
                     NSArray *commentDic = result[@"comments"];
                     NSMutableArray *mArr = [NSMutableArray array];
                     
                     for (NSDictionary *dic in commentDic) {
                         CommentModel *model = [[CommentModel alloc] initContentWithDic:dic];
                         [mArr addObject:model];
                     }
                     
                     self.commentModel = mArr;
                     
                     //刷新表视图
                     [_tableView reloadData];
                     
                     
                 } failuerBlock:^(AFHTTPRequestOperation *opertion, NSError *error) {
                     //请求失败
                     NSLog(@"请求失败，error is %@", error);
                     
                 }];
}


//创建表视图
- (void)_createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_tableView];
  
}




#pragma mark -UITableViewDataSource
//设置组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//设置行，---每一组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentModel.count;
    
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
    CommentModel *model = self.commentModel[indexPath.row];
    
    cell.textLabel.text = model.text;
    
//    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

//设置每一组的头视图
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int count = [self.model.comments_count intValue];
    if (!self.model.comments_count) {
        count = 0;
    }
    return [NSString stringWithFormat:@"   共%d条评论",count];
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



////单元格将被选中时调用的方法
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"section:%ld----row:%ld", indexPath.section, indexPath.row);
//}

//创建表视图的头视图
- (void)_createTableViewHeader
{
    CGFloat weibo_height = [self getHeightWithWeiboModel:self.model];
    //头视图
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _userView.height + weibo_height + 20)];
    
    //用户视图
    _userView.width = kScreenWidth;
    _userView.backgroundColor = [UIColor clearColor];
    //设置用户头像
    UIImageView *imgView = (UIImageView*)[_userView viewWithTag:100];
    imgView.layer.cornerRadius = 5.0;
    imgView.layer.masksToBounds = YES;
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.model.userModel.avatar_hd]];
    
    
    //设置用户昵称
    UILabel *userName = (UILabel*)[_userView viewWithTag:101];
    userName.backgroundColor = [UIColor clearColor];
    userName.text = self.model.userModel.screen_name;
    
    //设置用户个人描述吧
    UILabel *detailLabel = (UILabel *)[_userView viewWithTag:102];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.text = self.model.userModel.user_description;
    
    //添加到头视图上
    [_headView addSubview:_userView];
    
    
    //创建微博视图
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(10, _userView.bottom + 10, kScreenWidth - 20, weibo_height)];
    _weiboView.isDetail = YES;
    _weiboView.weiboModel = _model;
    
    [_headView addSubview:_weiboView];
    
    
}


//动态返回weiboView的高度
- (CGFloat)getHeightWithWeiboModel:(WeiboModel *)model
{
    CGFloat height = 0;
    height += [WXLabel getAttributedStringHeightWithString:self.model.text WidthValue:kScreenWidth - 40 delegate:nil font:[UIFont systemFontOfSize:18]];
    
    if (self.model.reWeibo != nil) {
        //有转发微博
        height += 10 + [WXLabel getAttributedStringHeightWithString:self.model.reWeibo.text WidthValue:kScreenWidth - 60 delegate:nil font:[UIFont systemFontOfSize:16]];
        
        if (self.model.reWeibo.bmiddle_pic != nil) {
            //有图片
            height += kWeiboViewImageHeight + 10;
        }
        
        
    }else {
        //无转发微博
        if (self.model.bmiddle_pic != nil) {
            height += kWeiboViewImageHeight + 10;
            
        }
        
    }
    
    
    return height + 30;
    
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
