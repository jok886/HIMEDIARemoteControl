//
//  AppMacro.h
//  RemoteControl
//
//  Created by Lin on 2018/3/30.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//  定义常规宏

#ifndef AppMacro_h
#define AppMacro_h
//普通常量

//解密的key
#define HMDEncryptKey    @"564f5335f01448fea293929e418c75dd"
//登录
#define HMDLoginModel    @"HMDLoginModel"
//是否登录
#define HMDLoginState            @"HMDLoginState"
//手机登录
#define HMDLoginPhoneModel    @"HMDLoginPhoneModel"
//微信登录
#define HMDLoginWXModel    @"HMDLoginWXModel"
//登录RefreshToken
#define HMDLoginRefreshToken    @"HMDLoginRefreshToken"
//微信登陆后后台HID
#define WXCurHID    @"HMDCurHID"
//上次链接的IP
#define DLANLastTimeLinkIP    @"DLANLastTimeLinkIP"
//上次链接的UUID
#define DLANLastTimeLinkDeviceUUID    @"DLANLastTimeLinkDeviceUUID"
//当前链接的IP
#define DLANLINKIP    @"DlanLinkIP"
//侧键控制开关
#define OPENSIDEKEY    @"OpenSideKey"
//震动开关
#define OPENSHOCK    @"OpenShock"
//搜索记录
#define HMDSearchWordHistory    @"SearchWordHistory"
//链接状态框高度
#define LINKVIEHIGHT    50
#define SafeAreaTop     44
#define SafeAreaBottom  34
#define HMDSTATUSBARMAXY CGRectGetMaxY([[UIApplication sharedApplication] statusBarFrame])
//机型判断
#define IPAD     [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad

//iPhone4
#define iPhone4 [UIScreen mainScreen].bounds.size.height<=480.0f
//iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhone5s
#define iPhone5S [UIScreen mainScreen].bounds.size.height<=568.0f
//iphone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

//iphone6plus
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(1125,2436),[[UIScreen mainScreen] currentMode].size) : NO)

#define HMDScreenH [UIScreen mainScreen].bounds.size.height
#define HMDScreenW [UIScreen mainScreen].bounds.size.width
#define HMDColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//颜色
#define HMDColorFromValue(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HMDColorFromValue(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HMDRandomColor HMDColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255),1.0)
#define HMDGlobeColor HMDColor(215, 215, 215)
#define WHITE           0xFFFFFF

#define LINE_COLOR      0xF5F5F5


#define BG_COLOR        0xF8F8F8

#define SECOND_GRAY     0xB9B9B9
#define MAIN_BLUE       0x4F96F0
#define MAIN_RED        0XE51776

#define BLACK           0x262626
#define MAIN_COLOR      0Xfe4c4f

#define SECOND_COLOR    0x224A7D

#define MAJOR_COLOR     0x0C1116

#define MSG_COLOR       0X282226
#define TAB_COLOR       0X181E1C
#define TABBAR_COLOR    0x282226
#define SMALLGRAY       0x999999
#define GRAY            0x666666

#define HMDMAIN_COLOR   HMDColorFromValue(0x3BC797)        //主色调
#define HMDTEXT_COLOR   HMDColorFromValue(0x333333)        //主文字颜色
#define HMDTEXT_UNUSE_COLOR   HMDColorFromValue(0x999999)        //文字未使用颜色
#define TIP_COLOR        HMDColorFromValue(0x7F7978)
#define SUCCESS_COLOR    HMDColorFromValue(0x2FCBF9)
#define WARNNING_COLOR   HMDColorFromValue(0xfa5459)
//强弱引用
#define HMDStrongObj(o) __strong typeof(o) strong##o = weak##o;
#define HMDWeakObj(o) __weak typeof(o) weak##o = o;

#define HMDStrongSelf(o) __strong typeof(o) strongSelf = weakSelf;
#define HMDWeakSelf(o) __weak typeof(o) weakSelf = o;
#define single_interface(class)  + (class *)shared##class;


// 单利
#define single_implementation(class) \
static class *_instance; \
\
+ (class *)shared##class \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}
//调试打印
#define HMDFunc HMDLog(@"%s",__func__)

#ifdef DEBUG // 调试

#define HMDLog(...) NSLog(__VA_ARGS__);

#else // 发布

#define HMDLog(...)
#endif 
#endif /* AppMacro_h */
