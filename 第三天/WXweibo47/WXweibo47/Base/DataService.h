//
//  DataService.h
//  WXweibo47
//
//  Created by imac on 15/9/14.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FinishDidBlock)(AFHTTPRequestOperation *opertion, id result);

typedef void (^FailuerBlock)(AFHTTPRequestOperation *opertion, NSError *error);

@interface DataService : NSObject

//封装网络请求
+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url
                                    params:(NSMutableDictionary *)params
                                httpMethod:(NSString *)httpMethod
                            finishDidBlock:(FinishDidBlock)finishDidBlock
                              failuerBlock:(FailuerBlock)failuerBlock;


@end
