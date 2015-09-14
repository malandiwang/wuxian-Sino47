//
//  UserModel.m
//  WXweibo47
//
//  Created by imac on 15/9/14.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(id)initContentWithDic:(NSDictionary *)jsonDic
{
    self = [super initContentWithDic:jsonDic];
    if (self) {
        //..特殊处理
        self.userId = [jsonDic objectForKey:@"id"];
        
        self.user_description = [jsonDic objectForKey:@"description"];
        
    }
    return self;
}

@end
