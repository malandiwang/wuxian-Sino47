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
    //根据微博的内容动态地返回高度
    //单元格的高度 ＝ 120 + 微博内容的高度
    
    //定义基准高度
    CGFloat height = 120;
    //获取内容
    WeiboModel *weiboModel = _data[indexPath.row];
    
    NSString *text = weiboModel.text;
    //第一种方法
//    CGRect rect = [text boundingRectWithSize:CGSizeMake(self.width - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14.0] forKey:NSFontAttributeName] context:nil];
    
    //使用第三方文件，WXLabel的类方法
    CGFloat weiboLabel_height = [WXLabel getAttributedStringHeightWithString:text WidthValue:self.width - 40 delegate:nil font:[UIFont systemFontOfSize:14]];
    
    height += weiboLabel_height + 10;
    
    //判断是否有转发微博
    if (weiboModel.reWeibo != nil) {
        //有转发微博
        NSString *reText = weiboModel.reWeibo.text;
        
//        CGRect reRect = [reText boundingRectWithSize:CGSizeMake(self.width - 60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12.0] forKey:NSFontAttributeName] context:nil];
        
        //使用第三方文件，WXLabel的类方法
        CGFloat reposterLabel_height = [WXLabel getAttributedStringHeightWithString:reText WidthValue:self.width - 60 delegate:nil font:[UIFont systemFontOfSize:12]];
        
        height += reposterLabel_height + 10;
        
        
        //是否带图片
        if (weiboModel.reWeibo.bmiddle_pic.length != 0) {
            //有图片
            height += kWeiboViewImageHeight + 10 +20;
            
        }else {
            //没有图片
            height += 10;
            
        }
        
        
    }else {
        //没有转发微博
        if (weiboModel.bmiddle_pic.length != 0) {
            //有图片
            height += kWeiboViewImageHeight + 10 + 20;
        }else {
            //没有图片
            height += 10;
            
        }
        
    }
    
    return height;
}


////单元格将被选中时调用的方法
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"section:%ld----row:%ld", indexPath.section, indexPath.row);
//}


@end
