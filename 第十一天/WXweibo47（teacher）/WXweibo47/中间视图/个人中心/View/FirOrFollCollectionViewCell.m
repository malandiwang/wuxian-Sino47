//
//  FirOrFollCollectionViewCell.m
//  WXweibo47
//
//  Created by imac on 15/9/20.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "FirOrFollCollectionViewCell.h"

@implementation FirOrFollCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    
}

- (void)setModel:(FirOrFollModel *)model
{
    if (_model != model) {
        _model = model;
        [self setNeedsLayout];
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //头像
    [_imgView sd_setImageWithURL:[NSURL URLWithString:self.model.profile_image_url]];
    _imgView.layer.cornerRadius = 10.0;
    _imgView.layer.masksToBounds = YES;
    
    //昵称
    nameLabel.text = self.model.screen_name;
    
    
    //简介
    NSInteger count = [self.model.followers_count integerValue];
    
    folloersLabel.text = [NSString stringWithFormat:@"粉丝:%ld",count];
    
    
}


@end
