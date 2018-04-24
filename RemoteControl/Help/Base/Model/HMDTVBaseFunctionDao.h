//
//  HMDTVBaseFunctionDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/12.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseDao.h"
typedef void(^HMDTVGetCaptureFinishBlock)(BOOL success,NSString *filePath,NSString *ip);        //截图成功
typedef void(^HMDTVDownLoadImageFinishBlock)(BOOL success,NSData *imageData);                   //下载图片成功
@interface HMDTVBaseFunctionDao : HMDBaseDao
//截屏
-(void)getCaptureFinishBlock:(HMDTVDownLoadImageFinishBlock)finishBlock;

//截屏
-(void)getImageCaptureFinishBlock:(HMDTVGetCaptureFinishBlock)finishBlock;
//下载图片
-(void)downLoadImageFromFilepath:(NSString *)filePath ip:(NSString *)ip Finish:(HMDTVDownLoadImageFinishBlock)finishBlock;
@end
