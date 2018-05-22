//
//  HMDRegisterDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDRegisterDao.h"

@implementation HMDRegisterDao
-(void)getDynamicCodeForRegister:(NSString *)phoneNum finishBlock:(void (^)(NSInteger))finishBlock{
    [self getDynamicCodeForRegister:phoneNum codeType:HMDDynamicCodeRegisteType finishBlock:finishBlock];
}
-(void)getDynamicCodeForForgetPWD:(NSString *)phoneNum finishBlock:(void (^)(NSInteger))finishBlock{
        [self getDynamicCodeForRegister:phoneNum codeType:HMDDynamicCodeForgetPWDType finishBlock:finishBlock];
}
-(void)getDynamicCodeForRegister:(NSString *)phoneNum codeType:(HMDDynamicCodeType)type finishBlock:(void (^)(NSInteger))finishBlock{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:phoneNum forKey:@"phone"];
    [parameters setValue:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"type"];

    NSString *encodeParameters = [self encryptParameters:parameters];
    NSString *url = HMD_HINAVI_DYNAMICCODE;
    [session POST:url parameters:encodeParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解密
        NSString *decodeResponseStr = [self decryptResponseObject:responseObject];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[decodeResponseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([responseDict isKindOfClass:[NSDictionary class]] && [[responseDict allKeys]containsObject:@"status"]) {
            if (finishBlock) {
                NSString *status = [responseDict objectForKey:@"status"];
                finishBlock([status integerValue]);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"failure%s",__FUNCTION__);
    }];
}

- (void)registerPhone:(NSString *)phoneNum dynamicCode:(NSString *)dynamicCode password:(NSString *)pwd finishBlock:(void (^)(NSInteger))finishBlock{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:phoneNum forKey:@"phone"];
    [parameters setValue:pwd forKey:@"password"];
    [parameters setValue:dynamicCode forKey:@"dynamic_code"];

    NSString *encodeParameters = [self encryptParameters:parameters];
    NSString *url = HMD_HINAVI_PHONE_REGISTER;
    [session POST:url parameters:encodeParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解密
        NSString *decodeResponseStr = [self decryptResponseObject:responseObject];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[decodeResponseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([responseDict isKindOfClass:[NSDictionary class]] && [[responseDict allKeys]containsObject:@"status"]) {
            if (finishBlock) {
                NSString *status = [responseDict objectForKey:@"status"];
                finishBlock([status integerValue]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure%s",__FUNCTION__);
    }];
}

-(void)recoverPWDWithPhone:(NSString *)phoneNum dynamicCode:(NSString *)dynamicCode password:(NSString *)pwd finishBlock:(void (^)(NSInteger))finishBlock{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:phoneNum forKey:@"phone"];
    [parameters setValue:pwd forKey:@"password"];
    [parameters setValue:dynamicCode forKey:@"dynamic_code"];
    
    NSString *encodeParameters = [self encryptParameters:parameters];
    NSString *url = HMD_HINAVI_PHONE_RECOVERPWD;
    [session POST:url parameters:encodeParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解密
        NSString *decodeResponseStr = [self decryptResponseObject:responseObject];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[decodeResponseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([responseDict isKindOfClass:[NSDictionary class]] && [[responseDict allKeys]containsObject:@"status"]) {
            if (finishBlock) {
                NSString *status = [responseDict objectForKey:@"status"];
                finishBlock([status integerValue]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure%s",__FUNCTION__);
    }];
}


@end
