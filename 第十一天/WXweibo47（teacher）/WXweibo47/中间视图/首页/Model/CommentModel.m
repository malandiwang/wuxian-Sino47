//
//  CommentModel.m
//  WXweibo47
//
//  Created by imac on 15/9/19.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (id)initContentWithDic:(NSDictionary *)jsonDic
{
    self = [super initContentWithDic:jsonDic];
    if (self) {
        //...
        self.commentId = [jsonDic objectForKey:@"id"];
        self.userModel = [[UserModel alloc] initContentWithDic:jsonDic[@"user"]];
        
    }
    
    return self;
}

@end
