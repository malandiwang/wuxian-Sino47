//
//  KeyCustomFun.m
//  WXweibo47
//
//  Created by imac on 15/9/16.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "KeyCustomFun.h"
#import "RegexKitLite.h"

@implementation KeyCustomFun

//将一段text中的表情筛选出来，替换成照片
+ (NSString *)parseFaceText:(NSString *)text
{
    //使用第三方RegexKitLite文件，使用正则表达式检索出表情文本
    NSString *regex = @"\\[\\w+\\]";
    //由正则表达式检索text
    NSArray *faceArray = [text componentsMatchedByRegex:regex];
    //遍历表情文本数组
    for (NSString *faceName in faceArray) {
        //...
        //faceName:[呵呵] ---> <image url = '00x.png'>
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
        NSArray *faceConfig = [NSArray arrayWithContentsOfFile:filePath];
        
        //通过谓词检索
        NSString *t = [NSString stringWithFormat:@"self.chs = '%@'", faceName];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:t];
        NSArray *items = [faceConfig filteredArrayUsingPredicate:predicate];
        
        if (items.count > 0) {
            //...
            NSDictionary *faceDic = items[0];
            NSString *imgName = [faceDic objectForKey:@"png"];
            
            //构建替换的字符串
            NSString *replaceName = [NSString stringWithFormat:@"<image url = '%@'>", imgName];
            
            //替换字符串
            text = [text stringByReplacingOccurrencesOfString:faceName withString:replaceName];
        }
    }
    
    return text;
}


@end
