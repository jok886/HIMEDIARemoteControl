//
//  HMDDeviceLinkDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseDao.h"
typedef void(^HMDDeviceLinkFinishBlock)(BOOL success);
@interface HMDDeviceLinkDao : HMDBaseDao
@property (nonatomic,copy) HMDDeviceLinkFinishBlock finishBlock;

//链接
-(void)getDeviceInfo:(NSString *)deviceIP finishBlock:(HMDDeviceLinkFinishBlock)finishBlock;

@end
