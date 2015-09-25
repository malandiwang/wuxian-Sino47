//
//  FirOrFollCollectionViewCell.h
//  WXweibo47
//
//  Created by imac on 15/9/20.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirOrFollModel.h"

@interface FirOrFollCollectionViewCell : UICollectionViewCell

{
    
    __weak IBOutlet UILabel *folloersLabel;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UIImageView *_imgView;
}

@property (nonatomic, strong) FirOrFollModel *model;

@end
