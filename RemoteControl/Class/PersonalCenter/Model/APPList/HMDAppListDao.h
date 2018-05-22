//
//  HMDAppListDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTVBaseFunctionDao.h"
#import "HMDAPKModel.h"
typedef void(^HMDGetAppListFinishBlock)(BOOL success,NSArray *appList);         //获得数据
typedef void(^HMDOpenAppFinishBlock)(BOOL success);                             //打开app
typedef void(^HMDInstallAppFinishBlock)(NSString *package);                             //打开app
@interface HMDAppListDao : HMDTVBaseFunctionDao
@property (nonatomic,copy) HMDInstallAppFinishBlock installAppFinishBlock;

//本地安装的app
-(void)getInstallAppListFinishBlock:(HMDGetAppListFinishBlock)finishBlock;
//卸载本地的app
-(void)uninstallDLanAppWithPackage:(NSString *)package FinishBlock:(HMDOpenAppFinishBlock)finishBlock;
//打开本地的应用
-(void)openDLanAppWithPackage:(NSString *)package FinishBlock:(HMDOpenAppFinishBlock)finishBlock;
//系统推荐的app
-(void)getRecommendAppListFinishBlock:(HMDGetAppListFinishBlock)finishBlock;

//安装HINAVI应用
-(void)installHINAVIAppWithAPKModel:(HMDAPKModel *)apkModel FinishBlock:(HMDOpenAppFinishBlock)finishBlock;
@end
