//
//  HMDDMRControl.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/16.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMDEventParamsResponse.h"
#import "HMDDeviceInfoModel.h"

@protocol HMDDMRControlDelegate <NSObject>

@optional
/**
 发现并添加DMR(媒体渲染器)
 */
-(void)onDMRAdded;

/**
 移除DMR
 */
-(void)onDMRRemoved;

/**
 无DMR被选中
 */
-(void)noDMRBeSelected;

-(void)getCurrentAVTransportActionResponse:(HMDCurrentAVTransportActionResponse *)response;

-(void)getTransportInfoResponse:(HMDTransportInfoResponse *)response;

-(void)previousResponse:(HMDEventResultResponse *)response;

-(void)nextResponse:(HMDEventResultResponse *)response;

-(void)DMRStateViriablesChanged:(NSArray <HMDEventParamsResponse *> *)response;

-(void)playResponse:(HMDEventResultResponse *)response;

-(void)pasuseResponse:(HMDEventResultResponse *)response;

-(void)stopResponse:(HMDEventResultResponse *)response;

-(void)setAVTransponrtResponse:(HMDEventResultResponse *)response;

-(void)setVolumeResponse:(HMDEventResultResponse *)response;

-(void)getVolumeResponse:(HMDVolumResponse *)response;


@end

@interface HMDDMRControl : NSObject
@property (nonatomic, strong)id <HMDDMRControlDelegate> delegate;
/***************************
 *
 * 媒体控制器相关(DMC)
 ***************************/

/**
 启动媒体控制器
 */
-(void)start;


/**
 重启媒体控制器
 */
-(void)restart;


/**
 停止
 */
-(void)stop;

-(BOOL)isRunning;
/*****************************
 *
 * 媒体服务器相关(DMS)
 *****************************/

/**
 获取附近媒体服务器
 
 */
-(NSArray <HMDServerDeviceModel *> *)getActiveServers;


/**
 根据uuid选择一个媒体服务器
 
 @param uuid uuid
 */
-(void)chooseServerWithUUID:(NSString *)uuid;


/**
 获取当前的媒体服务器
 
 @return 返回
 */
-(HMDServerDeviceModel *)getCurrentServer;


/***************************
 *
 *媒体渲染器(DMR)
 ***************************/


/**
 获取附近媒体渲染器(DMR)
 
 @return 返回数组
 */
-(NSArray <HMDRenderDeviceModel *> *)getActiveRenders;

/**
 使用uuid选择一个媒体渲染器
 
 @param uuid 传入uuid
 */
-(void)chooseRenderWithUUID:(NSString *)uuid;


/**
 获取当前的媒体渲染器
 
 @return <#return value description#>
 */
-(HMDRenderDeviceModel *)getCurrentRender;

/**
 播放
 */
-(void)renderPlay;


/**
 暂停
 */
-(void)renderPause;


/**
 媒体渲染器停止
 */
-(void)renderStop;


/**
 下一首／下一集
 */
-(void)renderNext;


/**
 上一首／上一集
 */
-(void)renderPrevious;

/**
 设置当前播放URI
 
 @param uriStr URI
 @param didl DIDL
 */
-(void)renderSetAVTransportWithURI:(NSString *)uriStr metaData:(NSString *)didl;


/**
 设置音量
 
 @param volume 传入音量
 */
-(void)renderSetVolume:(int)volume;


/**
 获取当前音量
 */
-(void)renderGetVolome;

/**
 获取当前动作 OnGetCurrentTransportActionsResult
 */
-(void)getCurrentTransportAction;


/**
 获取当前信息 回调 OnGetTransportInfoResult
 */
-(void)getTransportInfo;
@end
