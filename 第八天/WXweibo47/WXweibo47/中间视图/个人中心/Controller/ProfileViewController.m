//
//  ProfileViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "ProfileViewController.h"
#import "FirendAndFollerViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"个人中心";
    
    //构建UI
    [self _createViews];

    
    //加载数据
    [self _loadingData];
    

}


//加载数据
- (void)_loadingData
{
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"在路上的轩" forKey:@"screen_name"];
    
    [DataService requestWithURL:@"statuses/user_timeline.json"
                         params:nil
                     httpMethod:@"GET"
                 finishDidBlock:^(AFHTTPRequestOperation *opertion, id result) {
                     //...请求成功
                     NSArray *arrayjson = result[@"statuses"];
                     NSDictionary *dic = arrayjson[0];
                     NSDictionary *prefileDic = dic[@"user"];
                     ProfileModel *model = [[ProfileModel alloc] initContentWithDic:prefileDic];
                     NSMutableArray *mArr =[NSMutableArray array];
                     [mArr addObject:model];
                     self.data = mArr;
                     
                     //赋值
                     [self _sendData];

                     
                 } failuerBlock:^(AFHTTPRequestOperation *opertion, NSError *error) {
                     //请求失败
                     NSLog(@"请求失败");
                 }];
}

//-(void)setModel:(ProfileModel *)model
//{
//    if (_model != model) {
//        _model = model;
//        
//    }
//}

//为UI控件赋值
- (void)_createViews
{
    //背景图片
    _imgView.topCapHeight = 25;
    _imgView.leftCapWidth = 25;
    _imgView.imgName = @"timeline_rt_border_9.png";
    
    //设置下面四个imageView圆角
    firstImgView.layer.cornerRadius = 5.0;
    firstImgView.layer.masksToBounds = YES;
    
    secondImgView.layer.cornerRadius = 5.0;
    secondImgView.layer.masksToBounds = YES;
    
    thirdImgView.layer.cornerRadius = 5.0;
    thirdImgView.layer.masksToBounds = YES;
    
    fouthImgView.layer.cornerRadius = 5.0;
    fouthImgView.layer.masksToBounds = YES;
    
   

}

- (void)_sendData
{
    //昵称
    ProfileModel *model = self.data[0];
    nameLabel.text = model.screen_name;
    nameLabel.textColor = [UIColor orangeColor];
    
    //头像
    [imgName sd_setImageWithURL:[NSURL URLWithString:model.profile_image_url]];
    imgName.layer.cornerRadius = 10.0;
    imgName.layer.masksToBounds = YES;

    //性别
    if ([model.gender isEqualToString:@"m"]) {
        sexLabel.text = @"男";
    }else if ([model.gender isEqualToString:@"f"]){
        sexLabel.text = @"女";
    }else {
        sexLabel.text = @"未知";
    }
    
    //地址
    locationLabel.text = model.location;
    
    //简介
    descLabel.text = [NSString stringWithFormat:@"简介:%@", model.detail_description];
    
    //粉丝数
    NSInteger folloer_count = [model.followers_count integerValue];
    fsLabel.text = [NSString stringWithFormat:@"%ld", folloer_count];
    
    //关注数
    NSInteger friends = [model.friends_count integerValue];
    gzLabel.text = [NSString stringWithFormat:@"%ld", friends];
    
    firstImgView.userInteractionEnabled = YES;
    secondImgView.userInteractionEnabled = YES;
    thirdImgView.userInteractionEnabled = YES;
    fouthImgView.userInteractionEnabled = YES;
    
    //添加手势
    //粉丝
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailFolloers:)];
    [secondImgView addGestureRecognizer:tap1];
    
    //关注
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailFirends:)];
    [firstImgView addGestureRecognizer:tap2];

    
}

//-------------push--------------//
//关注
- (void)detailFirends:(UITapGestureRecognizer*)tap
{
    FirendAndFollerViewController *friVC = [[FirendAndFollerViewController alloc] init];
    friVC.title = @"关注";
    ProfileModel *model = self.data[0];
    friVC.screenName = model.screen_name;
    friVC.isFirOrFoll = YES;
    [self.navigationController pushViewController:friVC animated:YES];
}

//粉丝
- (void)detailFolloers:(UITapGestureRecognizer*)tap
{
    FirendAndFollerViewController *friVC = [[FirendAndFollerViewController alloc] init];
    friVC.title = @"粉丝";
    friVC.isFirOrFoll = NO;
    ProfileModel *model = self.data[0];
    friVC.screenName = model.screen_name;
    [self.navigationController pushViewController:friVC animated:YES];

}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
