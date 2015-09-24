//
//  ProfileModel.m
//  WXweibo47
//
//  Created by imac on 15/9/19.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "ProfileModel.h"

@implementation ProfileModel

-(id)initContentWithDic:(NSDictionary *)jsonDic
{
    self = [super initContentWithDic:jsonDic];
    if (self) {
        self.detail_description = [jsonDic objectForKey:@"description"];
    }
    
    return self;
    
}

@end
