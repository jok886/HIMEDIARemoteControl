//
//  NETMacro.h
//  RemoteControl
//
//  Created by Lin on 2018/3/30.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//  定义网络接口相关宏

#ifndef NETMacro_h
#define NETMacro_h

//错误地址
#define HMDERRORLANADDRESS  @"errorAddress"
//当前IP
#define HMDCURLINKDEVICEIP [[NSUserDefaults standardUserDefaults] objectForKey:DLANLINKIP]
//设备发现
#define HMD_NET_SEARCHDEVICE    @"M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMan:\"ssdp:discover\"\r\nMX: 1\r\nST:\"searchTarget:ssdp:all\"\r\n\r\n"
//遥控器按钮
#define HMD_NET_KEYSTOKE_EVENT  @"http://%@:8899/send"
//设备信息
#define HMD_NET_DEVICE_INFO  @"http://%@:8899/get"
//截屏
#define HMD_NET_DEVICE_GETCAPTURE  @"http://%@:8899/getCapture"
//下载图片
#define HMD_NET_DEVICE_DOWNLOADICON  @"http://%@:8899/getNoPackageAppIcon"
//获取所有应用
#define HMD_NET_DEVICE_GETALLAPK @"http://%@:8899/getAllApkInfo"
#endif /* NETMacro_h */
