//
//  HomeViewController.h
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@interface HomeViewController : BaseViewController<SinaWeiboRequestDelegate>

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) WeiboTableView *tableView;


- (void)logInDidRefreshData;


@end
