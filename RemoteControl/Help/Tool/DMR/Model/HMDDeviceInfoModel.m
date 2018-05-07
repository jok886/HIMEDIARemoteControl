//
//  HMDDeviceInfoModel.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/16.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDDeviceInfoModel.h"

@implementation HMDDeviceInfoModel
-(instancetype)initWithName:(NSString *)name andUUID:(NSString *)uuid
{
    if (self = [super init]) {
        self.name = name;
        self.uuid = uuid;
    }
    return self;
}

@end

@implementation HMDServerDeviceModel


@end

@implementation HMDRenderDeviceModel

-(instancetype)initWithName:(NSString *)name UUID:(NSString *)uuid Manufacturer:(NSString *)manufacturer ModelName:(NSString *)modelName ModelNumber:(NSString *)modelNumber SerialNumber:(NSString *)serialNumber DescriptionURL:(NSString *)descriptionURL LocalIP:(NSString *)localIP
{
    if (self = [super init]) {
        self.manufacturer = manufacturer;
        self.modelName = modelName;
        self.modelNumber = modelNumber;
        self.serialNumber = serialNumber;
        self.descriptionURL = descriptionURL;
        self.localIP = localIP;
    }
    return self;
}
@end


