//
//  HMDTVRemoteDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/9.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseDao.h"
typedef void(^HMDTVRemoteFinishBlock)(BOOL success);            //遥控成功
typedef void(^HMDTVGetCaptureFinishBlock)(BOOL success,NSString *filePath,NSString *ip);     //截图成功
typedef void(^HMDTVDownLoadImageFinishBlock)(BOOL success,NSData *imageData);     //下载图片成功
@interface HMDTVRemoteDao : HMDBaseDao
@property (nonatomic,copy) HMDTVRemoteFinishBlock finishBlock;

-(void)remoteTVWithKey:(NSInteger)key finishBlock:(HMDTVRemoteFinishBlock)finishBlock;
-(void)getCaptureFinishBlock:(HMDTVDownLoadImageFinishBlock)finishBlock;
-(void)downLoadImageFromFilepath:(NSString *)filePath ip:(NSString *)ip Finish:(HMDTVDownLoadImageFinishBlock)finishBlock;
-(void)getAllAPK;
@end
