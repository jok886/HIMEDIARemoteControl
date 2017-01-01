//
//  NETMacro.h
//  RemoteControl
//
//  Created by Lin on 2018/3/30.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//  定义网络接口相关宏

#ifndef NETMacro_h
#define NETMacro_h

#define HMDERRORLANADDRESS @"errorAddress"
#define HMD_NET_SEARCHDEVICE                       @"M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMan:\"ssdp:discover\"\r\nMX: 1\r\nST:\"searchTarget:ssdp:all\"\r\n\r\n"
#endif /* NETMacro_h */
