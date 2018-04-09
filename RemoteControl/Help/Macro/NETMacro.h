//
//  NETMacro.h
//  RemoteControl
//
//  Created by Lin on 2018/3/30.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//  定义网络接口相关宏

#ifndef NETMacro_h
#define NETMacro_h
//普通常量
#define DLANLINKIP    @"DlanLinkIP"
//错误地址
#define HMDERRORLANADDRESS  @"errorAddress"
//设备发现
#define HMD_NET_SEARCHDEVICE    @"M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMan:\"ssdp:discover\"\r\nMX: 1\r\nST:\"searchTarget:ssdp:all\"\r\n\r\n"
//遥控器按钮
#define HMD_NET_KEYSTOKE_EVENT  @"http://%@:8899/send"
//设备信息
#define HMD_NET_DEVICE_INFO  @"http://%@:8899/get"

#endif /* NETMacro_h */
