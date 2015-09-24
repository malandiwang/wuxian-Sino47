//
//  WeiboTableViewCell.h
//  WXweibo47
//
//  Created by imac on 15/9/15.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboView.h"


@interface WeiboTableViewCell : UITableViewCell

{
    
    __weak IBOutlet UIImageView *_bgImageView;
    __weak IBOutlet UIButton *_titleButton;
    
    __weak IBOutlet UIButton *_repostButton;
    
    __weak IBOutlet UIButton *_commentButton;
    
    __weak IBOutlet UIButton *_zanButton;
    
    __weak IBOutlet UILabel *_nameLabel;
    
    __weak IBOutlet UILabel *_timeLabel;
    
    __weak IBOutlet UILabel *_sourceLabel;
    
    //WeiboView
    WeiboView *_weiboView;
    
    
}

@property (nonatomic, strong) WeiboModel *model;


@end
