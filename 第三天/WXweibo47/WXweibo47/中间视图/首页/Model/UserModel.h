//
//  UserModel.h
//  WXweibo47
//
//  Created by imac on 15/9/14.
//  Copyright (c) 2015年 imac. All rights reserved.
//
/*
 返回值字段	字段类型	字段说明
 created_at	string	微博创建时间
 id	int64	微博ID
 mid	int64	微博MID
 idstr	string	字符串型的微博ID
 text	string	微博信息内容
 source	string	微博来源
 favorited	boolean	是否已收藏，true：是，false：否
 truncated	boolean	是否被截断，true：是，false：否
 in_reply_to_status_id	string	（暂未支持）回复ID
 in_reply_to_user_id	string	（暂未支持）回复人UID
 in_reply_to_screen_name	string	（暂未支持）回复人昵称
 thumbnail_pic	string	缩略图片地址，没有时不返回此字段
 bmiddle_pic	string	中等尺寸图片地址，没有时不返回此字段
 original_pic	string	原始图片地址，没有时不返回此字段
 geo	object	地理信息字段 详细
 user	object	微博作者的用户信息字段 详细
 retweeted_status	object	被转发的原微博信息字段，当该微博为转发微博时返回 详细
 reposts_count	int	转发数
 comments_count	int	评论数
 attitudes_count	int	表态数
 mlevel	int	暂未支持
 visible	object	微博的可见性及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；list_id为分组的组号
 pic_ids	object	微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。
 ad	object array	微博流内的推广微博ID
 */
#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic,copy) NSString *userId;  //用户的id
@property (nonatomic,copy) NSString *screen_name;  //用户的名字
@property (nonatomic,copy) NSString *location;  //用户所在地
@property (nonatomic,copy) NSString *user_description;  //用户个人描述
@property (nonatomic,copy) NSString *profile_image_url;  //用户头像地址（中图），50×50像素
@property (nonatomic,copy) NSNumber *followers_count; 	//粉丝数
@property (nonatomic,copy) NSNumber *friends_count;	//关注数
@property (nonatomic,copy) NSNumber *statuses_count;  //微博数
@property (nonatomic,copy) NSNumber *favourites_count;   //收藏数

@property (nonatomic,copy) NSString *created_at;  //发表时间
@property (nonatomic,copy) NSString *avatar_hd;  //用户头像地址（高清），高清头像原图
@property (nonatomic,copy) NSNumber *online_status;  //用户的在线状态，0：不在线、1：在线

@property(nonatomic,copy)NSString * gender;             //性别，m：男、f：女、n：未知



@end
