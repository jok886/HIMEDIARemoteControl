//
//  AppDelegate.h
//  RemoteControl
//
//  Created by Lin on 2018/3/30.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDUserModel.h"
#import "HMDDeviceModel.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) HMDUserModel *userModel;
@property (strong, nonatomic) HMDDeviceModel *deviceModel;
@property (assign, nonatomic,getter=isLogin) BOOL loginState;
@end

