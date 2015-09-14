//
//  WeiboModel.m
//  WXweibo47
//
//  Created by imac on 15/9/14.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "WeiboModel.h"

@implementation WeiboModel

-(id)initContentWithDic:(NSDictionary *)jsonDic
{
    self = [super initContentWithDic:jsonDic];
    if (self) {
        //...特殊处理
        //微博的id
        self.weiboId = [jsonDic objectForKey:@"id"];
        
        //处理作者
        NSDictionary *userDic = [jsonDic objectForKey:@"user"];
        if (userDic) {
            self.userModel = [[UserModel alloc] initContentWithDic:userDic];
        }
        
        //处理转发微博
        if (jsonDic[@"retweeted_status"]) {
            NSDictionary *retweet = [jsonDic objectForKey:@"retweeted_status"];
            self.reWeibo = [[WeiboModel alloc] initContentWithDic:retweet];
        }
        
    }
    
    return self;
}

@end
