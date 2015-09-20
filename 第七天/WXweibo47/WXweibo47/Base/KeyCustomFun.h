//
//  KeyCustomFun.h
//  WXweibo47
//
//  Created by imac on 15/9/16.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyCustomFun : NSObject

//将一段text中的表情筛选出来，替换成照片

+ (NSString *)parseFaceText:(NSString *)text;


@end
