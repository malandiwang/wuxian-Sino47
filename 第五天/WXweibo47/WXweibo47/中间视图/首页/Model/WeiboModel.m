//
//  WeiboModel.m
//  WXweibo47
//
//  Created by imac on 15/9/14.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"
#import "KeyCustomFun.h"


@implementation WeiboModel

//WeiboModel中的特殊处理
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
        
        //处理表情
        //[呵呵] ---> <image url = '00x.png'>
        self.text = [KeyCustomFun parseFaceText:self.text];
        
        
        //处理来源(第一种方式，通过截取)
//        NSRange range =  [self.source rangeOfString:@">"];
//        self.source = [self.source substringFromIndex:range.location+1];
//        
//        NSRange range1 = [self.source rangeOfString:@"<"];
//        self.source = [self.source substringToIndex:range1.location];
        
        
        
        //第二种方式，正则表达式，系统的NSRegularExpression
        //构建正则表达式
//        NSString *regex = @">[.\\w\\s]+<";
//        //根据系统的方法，创建NSRegularExpression对象
//        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
//        //根据NSRegularExpression对象拿到数组array
//        NSArray *array = [regular matchesInString:self.source options:0 range:NSMakeRange(0, self.source.length)];
//        
//        if (array.count > 0) {
//            //取出数组中第一个元素，为NSTextCheckingResult类型
//            NSTextCheckingResult *result = array[0];
//            //拿到result中的范围range
//            NSRange range = result.range;
//            //处理range的范围
//            range.location += 1;
//            range.length -= 2;
//            //截取字符串
//            self.source = [self.source substringWithRange:range];
//        }
        
        
        //使用第三方库(RegexKitLite.h)，正则表达式
        //构建正则表达式（正则表达式详解，见拓展笔记）
        NSString *regex = @">[.\\w\\s]+<";
        //使用第三方库取出数组
        NSArray *array = [self.source componentsMatchedByRegex:regex];
        if (array.count > 0) {
            //拿到数组中的元素，为一个字符串
            NSString *str = array[0];
            //根据字符串创建range
            NSRange range = {1, str.length-2};
            //截取字符串
            self.source = [str substringWithRange:range];
        }
        
        //处理日期
        //------Tue Sep 15 20:30:53 +0800 2015-------//
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"];
        //对formatter1做本地处理-解决在真机上显示不出时间的bug
        formatter1.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        
        //由字符串self.created_at转换成NSDate对象
        NSDate *date = [formatter1 dateFromString:self.created_at];
    
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];

        [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
        //对formatter2做本地处理-解决在真机上显示不出时间的bug
        formatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        self.created_at =  [formatter2 stringFromDate:date];
        
    }
    return self;
}

@end
