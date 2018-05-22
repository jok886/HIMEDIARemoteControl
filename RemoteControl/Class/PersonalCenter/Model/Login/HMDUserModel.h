//
//  HMDUserModel.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/19.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseModel.h"

@interface HMDUserModel : HMDBaseModel
//微信端参数
@property (nonatomic,strong) NSString *openid;              //普通用户的标识，对当前开发者帐号唯一
@property (nonatomic,strong) NSString *nickname;            //普通用户昵称
@property (nonatomic,assign) NSInteger *sex;                //普通用户性别，1为男性，2为女性
@property (nonatomic,strong) NSString *province;            //普通用户个人资料填写的省份
@property (nonatomic,strong) NSString *city;                //普通用户个人资料填写的城市
@property (nonatomic,strong) NSString *country;             //国家，如中国为CN
@property (nonatomic,strong) NSString *headimgurl;          //用户头像，最后一个数值代表正方形头像大小
@property (nonatomic,strong) NSString *privilege;           //用户特权信息，json数组
@property (nonatomic,strong) NSString *unionid;             //用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的
//后台
@property (nonatomic,strong) NSString *hid;                 //后台的ID


@property (nonatomic,strong) NSString *head_portrait_url;   //手机登录的头像
@property (nonatomic,strong) NSString *status;              //登录状态
@end
