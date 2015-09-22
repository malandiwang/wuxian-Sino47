//
//  FirendAndFollerViewController.m
//  WXweibo47
//
//  Created by imac on 15/9/20.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "FirendAndFollerViewController.h"
#import "FirOrFollCollectionViewCell.h"
#import "DetailPriViewController.h"

@interface FirendAndFollerViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@end

@implementation FirendAndFollerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //初始化collectionView
    [self _createCollectionView];
    
    //请求数据
    [self _loadingData];
    
    
    
}

//请求数据
- (void)_loadingData
{
    static NSString *str;
    
    if (_isFirOrFoll) {
        //关注
        str = @"friendships/friends.json";
        
    }else {
        //粉丝
        str = @"friendships/followers.json";
        
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.screenName forKey:@"screen_name"];
    [params setObject:@50 forKey:@"count"];
    
    [DataService requestWithURL:str
                         params:params
                     httpMethod:@"GET"
                 finishDidBlock:^(AFHTTPRequestOperation *opertion, id result) {
                     //...
                     NSArray *arrayJson = result[@"users"];
                     
                     NSMutableArray *mArr = [NSMutableArray array];
                     for (NSDictionary *dic in arrayJson) {
                         FirOrFollModel *model = [[FirOrFollModel alloc] initContentWithDic:dic];
                         
                         [mArr addObject:model];
                         
                     }
                     self.data = mArr;
                     
                     [_collectionView reloadData];
                     
                 } failuerBlock:^(AFHTTPRequestOperation *opertion, NSError *error) {
                     //请求失败
                     NSLog(@"请求失败");
                     
                 }];
    
}
//初始化collectionView
- (void)_createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.itemSize = CGSizeMake(100, 100);
    
    _collectionView = [[UICollectionView alloc]  initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_collectionView];
    
    //注册单元格(注册单元格用自己初始化的cell)（这里需要从XIB中去注册单元格）
    [_collectionView registerNib:[UINib nibWithNibName:@"FirOrFollCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell"];
    
    //此方法不能注册collectionView，
//    [_collectionView registerClass:[FirOrFollCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];

}

#pragma mark -UICollectionViewDelegateFlowLayout
#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
     NSString *indentiier = @"collectionCell";
    
    FirOrFollCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:indentiier forIndexPath:indexPath];
    
//    if (cell == nil) {
//    cell = [[[NSBundle mainBundle] loadNibNamed:@"FirOrFollCollectionViewCell" owner:nil options:nil] lastObject];
//        
//    }
    
//    cell.backgroundColor = [UIColor colorWithRed:arc4random()%10*0.1 green:arc4random()%10*0.1 blue:arc4random()%10*0.1 alpha:1];
    
    cell.layer.cornerRadius = 10.0;
    cell.layer.masksToBounds = YES;
    
    //    cell.backgroundColor = [UIColor clearColor];
    
    //传值
    cell.model = self.data[indexPath.row];
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailPriViewController *detailVC = [[DetailPriViewController alloc] init];
    
     FirOrFollModel *model = self.data[indexPath.row];
    
    detailVC.title = model.screen_name;
    detailVC.screenName = model.screen_name;
    [self.navigationController pushViewController:detailVC animated:YES];
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
