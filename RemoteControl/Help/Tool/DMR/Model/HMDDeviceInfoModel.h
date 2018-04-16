//
//  HMDDeviceInfoModel.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/16.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseModel.h"

@interface HMDDeviceInfoModel : HMDBaseModel
//设备uuid
@property(nonatomic, copy)NSString * uuid;
//设备名称
@property(nonatomic, copy)NSString * name;
-(instancetype)initWithName:(NSString *)name andUUID:(NSString *)uuid;
@end


@interface HMDServerDeviceModel : HMDDeviceInfoModel

@end

@interface HMDRenderDeviceModel : HMDDeviceInfoModel
//生产商
@property (nonatomic, retain) NSString *manufacturer;
//型号名
@property (nonatomic, retain) NSString *modelName;
//型号编号
@property (nonatomic, retain) NSString *modelNumber;
//设备生产串号
@property (nonatomic, retain) NSString *serialNumber;
//设备地址
@property (nonatomic, copy) NSString * descriptionURL;


-(instancetype)initWithName:(NSString *)name UUID:(NSString *)uuid Manufacturer:(NSString *)manufacturer ModelName:(NSString *)modelName ModelNumber:(NSString *)modelNumber SerialNumber:(NSString *)serialNumber DescriptionURL:(NSString *)descriptionURL;
@end
