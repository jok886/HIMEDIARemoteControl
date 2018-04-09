//
//  HMDTVRemoteDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/9.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseDao.h"
typedef void(^HMDTVRemoteFinishBlock)(BOOL success);
@interface HMDTVRemoteDao : HMDBaseDao
@property (nonatomic,copy) HMDTVRemoteFinishBlock finishBlock;
-(void)remoteTVWithKey:(NSInteger)key finishBlock:(HMDTVRemoteFinishBlock)finishBlock;
@end
