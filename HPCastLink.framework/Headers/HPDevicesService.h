//
//  HPDevicesService.h
//  HappyCast
//
//  Created by 王志军 on 16/5/13.
//  Copyright © 2016年 王志军. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HPServiceModel;
@class HPDLNADevice;

@interface HPDevicesService : NSObject

//  tv设备ip地址
@property (nonatomic,copy)NSString *ipAddress;

//  tv设备服务名称
@property (nonatomic,copy)NSString *name;

/**
 mac地址
 */
@property (nonatomic, copy) NSString *devicemac;

//  tv是否支持无界面音乐播放(tv老版本音乐播放，会出现黑屏，新版本推音乐播放，无黑屏界面，只有声音)
@property (nonatomic,assign)BOOL isSupportMusicCast;

//  tv是否支持弹幕播放
@property (nonatomic,assign)BOOL isSupportBarrageCast;

//  是否是历史连接设备
@property (nonatomic,assign)BOOL isHistoryConnect;

//  (将废弃)连接状态 0:未连接 1:已连接推送URl播放 2:正在连接 3:已镜像 4:正在镜像ing 5:连接到自己手机
@property (nonatomic,assign)NSInteger conState;

/**
 是否被选中，  如果是已经连接的状态，则为选中，即 conState 不为0，5
 */
@property (nonatomic, assign) BOOL isSelectd;




@property (nonatomic,strong)HPServiceModel *sdkModel;
@property (nonatomic,strong)HPServiceModel *apkModel;
@property (nonatomic, strong)HPDLNADevice * dlnaModel;

#warning 以下属性是乐播App专用属性，打包时可以删除

// 镜像状态 0 未镜像   1:已镜像
@property (nonatomic,assign)NSInteger mirrorState;
// 是扫码获得互联网连接电视
@property (nonatomic,assign)BOOL isScanInternetTV;
// 电视唯一标示
@property (nonatomic,copy)NSString *cname;
// 是否在同一网络
@property (nonatomic,assign)BOOL isSameNetwork;
// 电视wifi名字
@property (nonatomic,copy)NSString *tvSsid;

@end
