//
//  HMDAPKModel.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseModel.h"
typedef enum {
    HMDAPKInstallStyle = 0,     //已安装
    HMDAPKRecommendStyle = 1,            //推荐
} HMDAPKStyle; //apk的类型
@interface HMDAPKModel : HMDBaseModel
@property (nonatomic,strong) NSString *name;                //apk名字
@property (nonatomic,strong) NSString *package;             //包地址
@property (nonatomic,strong) NSString *versionCode;         //版本
@property (nonatomic,strong) NSString *versionName;         //apk版本

@property (nonatomic,assign) HMDAPKStyle apkStyle;         //apk类型
@end
