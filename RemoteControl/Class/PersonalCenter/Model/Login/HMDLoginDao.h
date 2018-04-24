//
//  HMDLoginDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/19.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseDao.h"
@class HMDUserModel;
typedef void(^HMDWXLoginFinishBlock)(BOOL success,HMDUserModel *userModel);               //获取用户信息
@interface HMDLoginDao : HMDBaseDao
//登录通过code获取token,然后获取用户信息
-(void)getWechatInfoWithCode:(NSString *)code finishBlock:(HMDWXLoginFinishBlock)finishBlock;
//使用refresh_token获取新的token,然后获取用户信息
-(void)getWechatInfoWithRefreshToken:(NSString *)refresh_token finishBlock:(HMDWXLoginFinishBlock)finishBlock;
@end
