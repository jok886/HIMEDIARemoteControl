//
//  HMDDeviceLinkDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseDao.h"

@interface HMDDeviceLinkDao : HMDBaseDao

-(void)connectWithDeviceIP:(NSString *)deviceIP onPort:(NSInteger)port;
@end
