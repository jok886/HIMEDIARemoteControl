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
@property (nonatomic,assign) HMDAPKStyle apkStyle;         //apk类型
//本地apk数据
@property (nonatomic,strong) NSString *name;                //apk名字
@property (nonatomic,strong) NSString *package;             //包地址
@property (nonatomic,strong) NSString *versionCode;         //版本
@property (nonatomic,strong) NSString *versionName;         //apk版本
//后台apk数据
@property (nonatomic,strong) NSString *alias;
@property (nonatomic,strong) NSString *apk_url;
@property (nonatomic,strong) NSString *channel;
@property (nonatomic,strong) NSString *img_url;
@property (nonatomic,strong) NSString *apkClass;
@property (nonatomic,strong) NSString *apkID;
@property (nonatomic,strong) NSString *installed;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *pkg;
@property (nonatomic,strong) NSString *ver_code;
@property (nonatomic,strong) NSString *ver_name;
@property (nonatomic,strong) NSString *md5;

@end
