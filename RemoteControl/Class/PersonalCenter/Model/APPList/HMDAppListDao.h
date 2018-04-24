//
//  HMDAppListDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseDao.h"
typedef void(^HMDGetAppListFinishBlock)(BOOL success,NSArray *appList);        //获得数据
@interface HMDAppListDao : HMDBaseDao
-(void)getInstallAppListFinishBlock:(HMDGetAppListFinishBlock)finishBlock;
@end
