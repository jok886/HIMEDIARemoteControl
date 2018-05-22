//
//  HMDResetNickNameViewController.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/21.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseViewController.h"
@class HMDResetNickNameViewController;
@protocol HMDResetNickNameDelegate <NSObject>

- (void)resetNickNameViewController:(HMDResetNickNameViewController *)resetNickNameViewController resetNickName:(NSString *)nickName;

@end
@interface HMDResetNickNameViewController : HMDBaseViewController
@property (nonatomic,copy) id<HMDResetNickNameDelegate> delegate;
@end
