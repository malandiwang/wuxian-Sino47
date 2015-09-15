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
    
    //转发
    NSString *repostStr = [NSString stringWithFormat:@"转发:%@", self.model.reposts_count];
    [_repostButton setTitle:repostStr forState:UIControlStateNormal];
    
    //评论
    NSString *commentStr = [NSString stringWithFormat:@"评论:%@", self.model.comments_count];
    [_commentButton setTitle:commentStr forState:UIControlStateNormal];

    //赞
    NSString *zanStr = [NSString stringWithFormat:@"赞:%@", self.model.attitudes_count];
    [_zanButton setTitle:zanStr forState:UIControlStateNormal];

    
}









- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
