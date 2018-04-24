//
//  HMDPersonCenterViewController.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/2.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//  个人中心

#import "HMDBaseViewController.h"
@class HMDUserModel;
@interface HMDPersonCenterViewController : HMDBaseViewController
-(void)upUserInfoWithUserModel:(HMDUserModel *)userModel;
@end
