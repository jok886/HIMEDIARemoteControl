//
//  HMDDeviceModel.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseModel.h"
//服务端model
//保存设备的信息，可以从xml文件里面看到
@interface HMDDeviceServiceModel : NSObject

@property (nonatomic, copy) NSString *serviceType;
@property (nonatomic, copy) NSString *serviceId;
@property (nonatomic, copy) NSString *controlURL;
@property (nonatomic, copy) NSString *eventSubURL;
@property (nonatomic, copy) NSString *SCPDURL;

- (void)setArray:(NSArray *)array;

@end

@class HMDDeviceModel;

@interface HMDDeviceModel : HMDBaseModel
@property (nonatomic,strong) NSString *uuid;                                //UUID唯一标识符
@property (nonatomic,strong) NSString *ip;                                  //ip
@property (nonatomic,strong) NSString *port;                                //port
@property (nonatomic,strong) NSString *location;                            //请求机子详情的接口
@property (nonatomic,strong) NSString *server;
@property (nonatomic,strong) NSString *friendlyName;                        //显示名称
@property (nonatomic,strong) NSString *modelName;                           //设备名称
@property (nonatomic,strong) NSString *deviceType;                          //设备类型

@property (nonatomic, strong) HMDDeviceServiceModel *AVTransportServiceModel;
@property (nonatomic, strong) HMDDeviceServiceModel *RenderControlServiceModel;


-(void)upInfoWithXMLData:(NSData *)xmlData;
@end
