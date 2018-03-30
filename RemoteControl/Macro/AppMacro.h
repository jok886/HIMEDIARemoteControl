//
//  AppMacro.h
//  RemoteControl
//
//  Created by Lin on 2018/3/30.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//  定义常规宏

#ifndef AppMacro_h
#define AppMacro_h

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
#define HMDRandomColor HMDColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
#define HMDGlobeColor HMDColor(215, 215, 215)

//强弱引用
#define HMDStrongObj(o) __strong typeof(o) strong##o = weak##o;
#define HMDWeakObj(o) __weak typeof(o) weak##o = o;

#define HMDStrongSelf(o) __strong typeof(o) strongSelf = weakSelf;
#define HMDWeakSelf(o) __weak typeof(o) weakSelf = o;

//调试打印
#define HMDFunc HMDLog(@"%s",__func__)

#ifdef DEBUG // 调试

#define HMDLog(...) NSLog(__VA_ARGS__);

#else // 发布

#define HMDLog(...)
#endif /* AppMacro_h */
