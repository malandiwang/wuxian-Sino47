//
//  FirendAndFollerViewController.h
//  WXweibo47
//
//  Created by imac on 15/9/20.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseViewController.h"
#import "FirOrFollModel.h"

@interface FirendAndFollerViewController : BaseViewController

{
    UICollectionView *_collectionView;
    
}


@property (nonatomic, strong) NSString *screenName;

@property (nonatomic, assign) BOOL isFirOrFoll;

@property (nonatomic, strong) NSArray *data;


@end
