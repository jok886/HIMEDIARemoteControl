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
-(void)getDynamicCodeForRegister:(NSString *)phoneNum;
@end
