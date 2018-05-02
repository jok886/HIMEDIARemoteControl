//
//  HMDSearchDeviceDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseDao.h"
#import "HMDDeviceModel.h"

typedef void(^HMDSearchDeviceDaoGetMoreInfoFinishBlock)(BOOL success,HMDDeviceModel *newDeviceModel);               //数据更新结束
typedef void(^HMDSearchDeviceDaoSearchFinishBlock)(void);               //停止搜索
typedef void(^HMDDeviceLinkFinishBlock)(BOOL success);
@protocol  HMDSearchDeviceDaoDelegate<NSObject>

@optional
- (void)SearchNewDevice:(HMDDeviceModel *)newDeviceModel;
@end
@interface HMDSearchDeviceDao : HMDBaseDao
@property (nonatomic,assign) CGFloat clostTime;                                 //默认2s
@property (nonatomic,weak) id<HMDSearchDeviceDaoDelegate> delegate;   //点击代理
@property (nonatomic,copy) HMDSearchDeviceDaoGetMoreInfoFinishBlock finishBlock;     //解析结束
@property (nonatomic,copy) HMDSearchDeviceDaoSearchFinishBlock searchFinishBlock;     //解析结束
//搜索设备
-(void)searchDevices;
//在原有基础上搜索设备
//-(void)searchDevicesExcludeDevices:(NSArray *)devices;
//按UUID获取设备详情
-(void)getMoreInfoFromDevice:(HMDDeviceModel *)deviceModel finishBlock:(HMDSearchDeviceDaoGetMoreInfoFinishBlock) finishBlock;
//链接
-(void)getDeviceInfo:(NSString *)deviceIP finishBlock:(HMDDeviceLinkFinishBlock)finishBlock;
@end
