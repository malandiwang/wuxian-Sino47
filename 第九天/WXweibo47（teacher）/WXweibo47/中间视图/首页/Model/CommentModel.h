//
//  CommentModel.h
//  WXweibo47
//
//  Created by imac on 15/9/19.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"

@interface CommentModel : BaseModel

@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *commentId;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *mid;
@property (nonatomic,strong) UserModel *userModel;

@end
