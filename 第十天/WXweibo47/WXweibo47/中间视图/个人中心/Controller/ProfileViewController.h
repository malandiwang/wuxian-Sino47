//
//  ProfileViewController.h
//  WXweibo47
//
//  Created by imac on 15/9/11.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseViewController.h"
#import "ProfileModel.h"

@interface ProfileViewController : BaseViewController


{
    __weak IBOutlet UILabel *fsLabel;
    
    __weak IBOutlet UILabel *gzLabel;
    __weak IBOutlet UILabel *descLabel;
    __weak IBOutlet UILabel *locationLabel;
    __weak IBOutlet ThemeImageView *_imgView;
    
    __weak IBOutlet UIImageView *imgName;

    __weak IBOutlet UILabel *nameLabel;
    
    __weak IBOutlet UILabel *sexLabel;
    
    __weak IBOutlet UIImageView *thirdImgView;
    
    __weak IBOutlet UIImageView *fouthImgView;
    __weak IBOutlet UIImageView *secondImgView;
    __weak IBOutlet UIImageView *firstImgView;
}

@property (nonatomic, strong) NSArray *data;


@end
