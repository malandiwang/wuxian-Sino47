//
//  DataService.m
//  WXweibo47
//
//  Created by imac on 15/9/14.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "DataService.h"

#define BASE_URL @"https://open.weibo.cn/2/"
@implementation DataService

//封装网络请求
+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url
                                    params:(NSMutableDictionary *)params
                                httpMethod:(NSString *)httpMethod
                            finishDidBlock:(FinishDidBlock)finishDidBlock
                              failuerBlock:(FailuerBlock)failuerBlock
{
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
        
    }
    
    //1.构建URL
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@", BASE_URL, url];
    
    //处理参数
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinoDic = [defaults objectForKey:@"SinaWeiboAuthData"];
    NSString *accessTokenKey = [sinoDic objectForKey:@"AccessTokenKey"];
    //安全判断
    if (accessTokenKey.length == 0) {
        return nil;
    }
    //拼接access_token
    [params setObject:accessTokenKey forKey:@"access_token"];
    
    //2.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    AFHTTPRequestOperation *opertion = nil;
    
    if ([httpMethod isEqualToString:@"GET"]) {
        //get请求
        opertion = [manager GET:urlStr
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 //请求成功
                 NSLog(@"AF-GET请求成功");
                 if (finishDidBlock) {
                     finishDidBlock(operation, responseObject);
                 }
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 //请求失败
                 NSLog(@"AF-GET请求失败");
                 if (failuerBlock) {
                     failuerBlock(operation, error);
                 }

             }];
    }else if ([httpMethod isEqualToString:@"POST"]){
    
        //post请求
        //标示文件符
        BOOL isFile = NO;
        //遍历参数
        for (NSString *key in params) {
            id value = params[key];
            if ([value isKindOfClass:[NSData class]]) {
                isFile = YES;
                break;
            }
        }
        
        if (!isFile) {
            //没有文件
            opertion = [manager POST:urlStr
               parameters:params
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      //请求成功
                      NSLog(@"AF-POST(非文件)请求成功");
                      if (finishDidBlock) {
                          finishDidBlock(operation, responseObject);
                      }

                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      //请求失败
                      NSLog(@"AF-POST(非文件)请求失败");
                      if (failuerBlock) {
                          failuerBlock(operation, error);
                      }

                  }];
        }else {
        
            //有文件
            opertion = [manager POST:urlStr
               parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //添加文件
    //遍历参数
    for (NSString *key in params) {
        id value = params[key];
        //往form表单中添加data数据
        if ([value isKindOfClass:[NSData class]]) {
            [formData appendPartWithFileData:value
                                        name:key
                                    fileName:key
                                    mimeType:@"image/jpeg"];
        }
    }
}
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      //请求成功
                      NSLog(@"AF-POST(有文件)请求成功");
                      if (finishDidBlock) {
                          finishDidBlock(operation, responseObject);
                      }

                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      //请求失败
                      NSLog(@"AF-POST(有文件)请求失败");
                      if (failuerBlock) {
                          failuerBlock(operation, error);
                      }

                  }];
        }
    }
    
    
    //设置返回数据的解析方式
    opertion.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    
    return opertion;
    
}



@end
