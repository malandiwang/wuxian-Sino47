//
//  DetailPriViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/20.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "DetailPriViewController.h"

@interface DetailPriViewController ()

{
    ThemeImageView *_bgImgView; //背景视图
    UIImageView *_imgView;  //头像视图
    UILabel *_nameLabel;    //昵称label
    UILabel *_descrLabel;   //简介
    
}

@end

@implementation DetailPriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //创建视图
    [self _initViews];
    
    
    //加载数据
    [self _loadingData];
}

//创建视图
- (void)_initViews
{
    _bgImgView = [[ThemeImageView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 180)];
    //背景图片
    _bgImgView.topCapHeight = 25;
    _bgImgView.leftCapWidth = 25;
    _bgImgView.imgName = @"timeline_rt_border_9.png";
    
    [self.view addSubview:_bgImgView];
    
    //头像视图
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    _imgView.layer.cornerRadius = 10.0;
    _imgView.layer.masksToBounds = YES;
    _imgView.backgroundColor = [UIColor orangeColor];
    [_bgImgView addSubview:_imgView];
    
    
    //昵称
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 20, kScreenWidth - 130, 40)];
    _nameLabel.textColor = [UIColor orangeColor];
    _nameLabel.text = @"hehe";
    [_bgImgView addSubview:_nameLabel];
    
    //简介
    _descrLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 60, kScreenWidth - 130, 40)];
    _descrLabel.textColor = [UIColor purpleColor];
    _descrLabel.text = @"hehe";
    [_bgImgView addSubview:_descrLabel];
    

    //创建下面四个lable
    for (int i = 0; i < 4; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(((kScreenWidth - 200 - 20) / 5) * (i + 1) + 50 * i, 120, 50, 50)];
        label.backgroundColor = [UIColor grayColor];
        label.layer.cornerRadius = 5.0;
        label.layer.masksToBounds = YES;
        label.tag = 2015 + i;
        label.textColor = [UIColor cyanColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        if (i == 2) {
            label.text = @"资料";
        }
        if (i == 3) {
            label.text = @"更多";
            
        }
        [_bgImgView addSubview:label];
    }
    
    
}
//加载数据
- (void)_loadingData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.screenName forKey:@"screen_name"];
    
    [DataService requestWithURL:@"users/show.json"
                         params:params
                     httpMethod:@"GET"
                 finishDidBlock:^(AFHTTPRequestOperation *opertion, id result) {
                     //...
                     ProfileModel *model = [[ProfileModel alloc] initContentWithDic:result];
                     NSMutableArray *mArr =[NSMutableArray array];
                     [mArr addObject:model];
                     self.data = mArr;
 
                     //请求到数据后赋值
                     [self _sendData];
                     
                 } failuerBlock:^(AFHTTPRequestOperation *opertion, NSError *error) {
                     //...
                     NSLog(@"请求失败");
                 }];
}


//赋值
- (void)_sendData
{
    
    ProfileModel *model = self.data[0];
    //头像
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.profile_image_url]];
    //匿名
    _nameLabel.text = model.screen_name;

    //简介
    _descrLabel.text = model.detail_description;
    
    //粉丝
    UILabel *fsLabel = (UILabel*)[_bgImgView viewWithTag:2016];
    NSInteger follower = [model.followers_count integerValue];
    fsLabel.text = [NSString stringWithFormat:@"粉丝:%ld", follower];
    
    //关注吧
    UILabel *gzLabel = (UILabel*)[_bgImgView viewWithTag:2015];
    NSInteger friends = [model.friends_count integerValue];
    gzLabel.text = [NSString stringWithFormat:@"关注:%ld", friends];
    

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
