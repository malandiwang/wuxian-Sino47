//
//  ThemeViewController.h
//  WXweibo47
//
//  Created by imac on 15/9/13.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@property (nonatomic, copy) NSString *lastThemeName;

@end
