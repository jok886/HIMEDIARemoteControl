//
//  HMDTVRemoteDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/9.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTVBaseFunctionDao.h"
typedef void(^HMDTVRemoteFinishBlock)(BOOL success);            //遥控成功

@interface HMDTVRemoteDao : HMDTVBaseFunctionDao
@property (nonatomic,copy) HMDTVRemoteFinishBlock finishBlock;
//按键控制
-(void)remoteTVWithKey:(NSInteger)key finishBlock:(HMDTVRemoteFinishBlock)finishBlock;

-(void)getAllAPK;
@end
