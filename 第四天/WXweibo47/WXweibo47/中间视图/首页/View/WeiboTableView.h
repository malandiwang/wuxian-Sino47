//
//  WeiboTableView.h
//  WXweibo47
//
//  Created by imac on 15/9/15.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "UserModel.h"

@interface WeiboTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;


@end
