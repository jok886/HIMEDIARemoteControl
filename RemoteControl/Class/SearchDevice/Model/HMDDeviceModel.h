//
//  HMDDeviceModel.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseModel.h"
@class HMDDeviceModel;
typedef void(^HMDDeviceModelParserfinishBlock)(BOOL success,HMDDeviceModel *newDeviceModel);               //XML解析结束
@interface HMDDeviceModel : HMDBaseModel
@property (nonatomic,strong) NSString *uuid;                                //UUID唯一标识符
@property (nonatomic,strong) NSString *ip;                                  //ip
@property (nonatomic,strong) NSString *port;                                //port
@property (nonatomic,strong) NSString *location;                            //请求机子详情的接口
@property (nonatomic,strong) NSString *server;
@property (nonatomic,strong) NSString *friendlyName;                        //显示名称
@property (nonatomic,strong) NSString *deviceType;                          //设备类型
@property (nonatomic,copy) HMDDeviceModelParserfinishBlock finishBlock;     //解析结束
-(void)upInfoWithXMLData:(NSData *)xmlData finishBlock:(HMDDeviceModelParserfinishBlock) finishBlock;
@end
