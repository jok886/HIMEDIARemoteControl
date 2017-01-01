//
//  HMDSearchDeviceViewController.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/4.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseViewController.h"
typedef void(^HMDSearchDeviceVCSelectedFinishBlock)(NSString *ip,NSInteger port);               //链接
@interface HMDSearchDeviceViewController : HMDBaseViewController
@property (nonatomic,copy) HMDSearchDeviceVCSelectedFinishBlock selectedFinishBlock;
@end
