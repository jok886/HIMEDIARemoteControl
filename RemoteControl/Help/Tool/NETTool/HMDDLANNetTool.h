//
//  HMDDLANNetTool.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/4.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HMDDLANNetFileImageType,
    HMDDLANNetFileVideoType,
    HMDDLANNetFileMusicType,
} HMDDLANNetFileType;

@interface HMDDLANNetTool : NSObject
@property (nonatomic,assign,getter=isWIFIEnvironmental) BOOL wifiEnvironmental;   //wifi环境

+(HMDDLANNetTool *)sharedInstance;
/**
 * 获取WiFi 信息，返回的字典中包含了WiFi的名称、路由器的Mac地址、还有一个Data(转换成字符串打印出来是wifi名称)
 */
+ (NSDictionary *)fetchSSIDInfo;

/** 获取WiFi的名称 */
+ (NSString *)fetchWiFiName;

/** 获取本机在WiFi环境下的IP地址 */
+ (NSString *)getLocalIPAddressForCurrentWiFi;

/** 广播地址、子网掩码、端口等，组装成一个字典。 */
+ (NSMutableDictionary *)getLocalInfoForCurrentWiFi;
/** 获取本地设备的相关信息 */
+(NSMutableDictionary *)getDeviceInfoForDataString:(NSString *)dataStr;
/** 开启http服务 */
-(void)startWebServer;
/** 返回存储的路径 */
+(NSString *)saveFileForName:(NSString *)fileName saveType:(HMDDLANNetFileType)fileType;
/** 返回URL的路径 */
+(NSString *)getHttpWebURLWithFileName:(NSString *)fileName fileType:(HMDDLANNetFileType)fileType;
/** 生成文件名字 */
+(NSString *)getFileNameWithExtensionName:(NSString *)extensionName;

/** 开启wifi状态监听 */
-(void)startNotificationWifi;
@end
