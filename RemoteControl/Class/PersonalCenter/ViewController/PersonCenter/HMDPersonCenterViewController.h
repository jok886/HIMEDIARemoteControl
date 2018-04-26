//
//  HMDPersonCenterViewController.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/2.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//  个人中心

#import "HMDBaseViewController.h"
@class HMDUserModel;

typedef void(^HMDPersonCenterUPUserInfoBlock)(HMDUserModel *userModel);

@interface HMDPersonCenterViewController : HMDBaseViewController
@property (nonatomic,copy) HMDPersonCenterUPUserInfoBlock upUserInfoBlock;
-(void)upUserInfoWithUserModel:(HMDUserModel *)userModel;
@end
