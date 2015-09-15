//
//  WeiboTableView.m
//  WXweibo47
//
//  Created by imac on 15/9/15.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboTableViewCell.h"

@implementation WeiboTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        //...
        //自己实现自己的协议
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
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
    //单元格复用
    //这个字符串WeiboCell要和XIB中的单元格的identifier一样
   static NSString *identifier = @"WeiboCell";
    WeiboTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        //从XIB中加载出cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WeiboTableViewCell" owner:nil options:nil] lastObject];
        
    }
    cell.model = self.data[indexPath.row];
    
    return cell;
}


#pragma mark -UITableViewDelegate

//设置指定单元格row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}


////单元格将被选中时调用的方法
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"section:%ld----row:%ld", indexPath.section, indexPath.row);
//}

@end
