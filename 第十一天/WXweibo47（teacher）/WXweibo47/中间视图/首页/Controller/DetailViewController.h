//
//  DetailViewController.h
//  WXweibo47
//
//  Created by imac on 15/9/19.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "CommentModel.h"


@interface DetailViewController : BaseViewController

{
    //表视图
    UITableView *_tableView;
    //表视图头视图
    UIView *_headView;
    //头视图中的微博视图
    WeiboView *_weiboView;
    
    
    IBOutlet UIView *_userView;
    
}
//传过来的WeiboModel
@property (nonatomic, strong) WeiboModel *model;

//评论接口获取的数据
@property (nonatomic, strong) NSArray *commentModel;


@end
