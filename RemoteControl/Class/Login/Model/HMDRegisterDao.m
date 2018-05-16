//
//  HMDRegisterDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDRegisterDao.h"

@implementation HMDRegisterDao
-(void)getDynamicCodeForRegister:(NSString *)phoneNum{
    [self getDynamicCodeForRegister:phoneNum codeType:HMDDynamicCodeRegisteType];
}

-(void)getDynamicCodeForRegister:(NSString *)phoneNum codeType:(HMDDynamicCodeType)type{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSDictionary *parametersDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    phoneNum,@"phone",
                                    [NSString stringWithFormat:@"%ld",(long)type],@"type",
                                    nil];
    NSString *encodeParameters = [self encryptParameters:parametersDict];
    NSString *url = HMD_HINAVI_DYNAMICCODE;
    [session GET:url parameters:encodeParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解密
        NSString *decodeResponseStr = [self decryptResponseObject:responseObject];
        NSDictionary *hmdDict = [NSJSONSerialization JSONObjectWithData:[decodeResponseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//        if ([[hmdDict allKeys]containsObject:@"hid"]) {
//            NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionaryWithDictionary:wxInfoDict];
//            [userInfoDict addEntriesFromDictionary:hmdDict];
//            HMDUserModel *userModel = [HMDUserModel hmd_modelWithDictionary:userInfoDict];
//            [[NSUserDefaults standardUserDefaults] setObject:userModel.hid forKey:WXCurHID];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            if (finishBlock) {
//                finishBlock(YES,userModel);
//            }
//            NSLog(@"success%s",__FUNCTION__);
//        }else{
//
//            if (finishBlock) {
//                finishBlock(NO,nil);
//            }
//            NSLog(@"过期失败failure%s",__FUNCTION__);
//        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (finishBlock) {
//            finishBlock(NO,nil);
//        }
        NSLog(@"failure%s",__FUNCTION__);
    }];
}
@end
