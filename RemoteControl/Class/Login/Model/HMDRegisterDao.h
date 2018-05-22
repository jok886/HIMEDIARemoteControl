//
//  HMDRegisterDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDLoginDao.h"
typedef enum : NSInteger{
    HMDDynamicCodeRegisteType = 1,          //注册
    HMDDynamicCodeForgetPWDType = 2,        //忘记密码
    HMDDynamicCodeLoginType = 3,            //登录
}HMDDynamicCodeType;
@interface HMDRegisterDao : HMDLoginDao
//注册动态码
-(void)getDynamicCodeForRegister:(NSString *)phoneNum finishBlock:(void(^)(NSInteger status))finishBlock;
//修改密码动态码
-(void)getDynamicCodeForForgetPWD:(NSString *)phoneNum finishBlock:(void(^)(NSInteger status))finishBlock;
//注册
-(void)registerPhone:(NSString *)phoneNum dynamicCode:(NSString *)dynamicCode password:(NSString *)pwd finishBlock:(void(^)(NSInteger status))finishBlock;
//修改密码
-(void)recoverPWDWithPhone:(NSString *)phoneNum dynamicCode:(NSString *)dynamicCode password:(NSString *)pwd finishBlock:(void(^)(NSInteger status))finishBlock;

@end
