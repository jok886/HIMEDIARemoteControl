//
//  HMDEventParamsResponse.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/16.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseModel.h"

@interface HMDEventParamsResponse : HMDBaseModel
@property (nonatomic, copy) NSString *deviceUUID;
@property (nonatomic, copy) NSString *serviceID;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventValue;
-(instancetype)initWithDeviceUUID:(NSString *)deviceUUID ServiceID:(NSString *)serviceID EventName:(NSString *)eventName EventValue:(NSString *)eventValue;
@end


/**
 动作结果响应
 */
@interface HMDEventResultResponse : NSObject
@property (nonatomic, assign) NSInteger result;
@property (nonatomic, copy) NSString *deviceUUID;
@property (nonatomic, assign) id    userData;
-(instancetype)initWithResult:(NSInteger)result DeviceUUID:(NSString *)deviceUUID UserData:(id)userData;
@end


/**
 当前动作响应
 */
@interface HMDCurrentAVTransportActionResponse : HMDEventResultResponse
@property (nonatomic, strong) NSArray<NSString *> *actions;
-(instancetype)initWithResult:(NSInteger)result DeviceUUID:(NSString *)deviceUUID Actions:(NSArray<NSString *> *)actions UserData:(id)userData;
@end

@interface HMDVolumResponse : HMDEventResultResponse
@property (nonatomic, copy)NSString * channel;
@property (nonatomic, assign)NSInteger volume;
-(instancetype)initWithResult:(NSInteger)result DeviceUUID:(NSString *)deviceUUID UserData:(id)userData Channel:(NSString *)channel Volume:(NSInteger)volume;
@end

/**
 当前投屏信息响应
 */
@interface HMDTransportInfoResponse : HMDEventResultResponse
@property (nonatomic, copy) NSString  *cur_transport_state;
@property (nonatomic, copy) NSString  *cur_transport_status;
@property (nonatomic, copy) NSString  *cur_speed;
@end


