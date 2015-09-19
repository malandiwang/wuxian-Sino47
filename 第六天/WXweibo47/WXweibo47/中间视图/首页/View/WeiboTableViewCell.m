//
//  WeiboTableViewCell.m
//  WXweibo47
//
//  Created by imac on 15/9/15.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "WeiboTableViewCell.h"

@implementation WeiboTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    //设置cell背景图片
    UIImage *img = [UIImage imageNamed:@"userinfo_shadow_pic.png"];
    //设置拉伸点
    _bgImageView.image = [img stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    
    //设置用户的头像圆角
    _titleButton.layer.cornerRadius = 5.0;
    _titleButton.layer.masksToBounds = YES;
    
    
    //初始化WeiboView
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    _weiboView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_weiboView];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setModel:(WeiboModel *)model
{
    if (_model != model) {
        _model = model;
        
        [self setNeedsLayout];
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置头像
    UserModel *userModel = self.model.userModel;
    [_titleButton sd_setImageWithURL:[NSURL URLWithString:userModel.profile_image_url] forState:UIControlStateNormal];
    
    //设置用户的昵称
    _nameLabel.text = userModel.screen_name;
    
    //设置来源地（特殊处理已经在WeiboModel中处理）
    _sourceLabel.text = self.model.source;
    
    //设置微博时间（特殊处理已经在WeiboModel中处理）
    _timeLabel.text = self.model.created_at;
    
    
    
    //处理转发，评论，赞显示的数量最大为99
    //对评论数、转发数、赞的数量做处理
    NSInteger reposts = [self.model.reposts_count integerValue];
    NSInteger comments = [self.model.comments_count integerValue];
    NSInteger attitudes = [self.model.attitudes_count integerValue];
    
    if (reposts > 99) {
        //显示99+
        [_repostButton setTitle:@"转发:99+" forState:UIControlStateNormal];
    }else {
        //转发
        NSString *repostStr = [NSString stringWithFormat:@"转发:%@", self.model.reposts_count];
        [_repostButton setTitle:repostStr forState:UIControlStateNormal];
    }
    if (comments > 99) {
        //显示99+
        [_commentButton setTitle:@"评论:99+" forState:UIControlStateNormal];
    }else {
        //评论
        NSString *commentStr = [NSString stringWithFormat:@"评论:%@", self.model.comments_count];
        [_commentButton setTitle:commentStr forState:UIControlStateNormal];
    }
    if (attitudes > 99) {
        //显示99+
        [_zanButton setTitle:@"赞:99+" forState:UIControlStateNormal];
    }else {
        //赞
        NSString *zanStr = [NSString stringWithFormat:@"赞:%@", self.model.attitudes_count];
        [_zanButton setTitle:zanStr forState:UIControlStateNormal];
    }
    
    
    //把model传给WeiboView去处理
    _weiboView.frame = CGRectMake(20, 70, kScreenWidth - 40, self.contentView.height - 70 - 50);
    _weiboView.weiboModel = self.model;
    
    
}









- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
