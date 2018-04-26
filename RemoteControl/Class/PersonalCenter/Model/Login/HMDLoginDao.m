//
//  HMDLoginDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/19.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDLoginDao.h"
#import "HMDUserModel.h"
#import "EncryptionTools.h"
@implementation HMDLoginDao
-(void)getWechatInfoWithCode:(NSString *)code finishBlock:(HMDWXLoginFinishBlock)finishBlock{
    HMDWeakSelf(self)
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *oauth2URL = HMD_WINXIN_OAUTH2;

    NSDictionary *oauth2Dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"wxed8c151bb3208370",@"appid",
                                @"04a7e2e7f0b471d6fe6c94cb0bf5e0da",@"secret",
                                code,@"code",
                                @"authorization_code",@"grant_type",
                                nil];
    [session GET:oauth2URL parameters:oauth2Dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *tokenDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[tokenDict allKeys]containsObject:@"errcode"]) {
            //过期失败
            if (finishBlock) {
                finishBlock(NO,nil);
            }
            NSLog(@"过期失败failure%s",__FUNCTION__);
        }else{
            NSString *access_token = [tokenDict objectForKey:@"access_token"];//有效期2小时
            NSString *refresh_token = [tokenDict objectForKey:@"refresh_token"];//有效期30天
            NSString *openid = [tokenDict objectForKey:@"openid"];
            NSString *encryptRefresh_token = [EncryptionTools encryptAESWithHINAVI:refresh_token];
            [[NSUserDefaults standardUserDefaults] setObject:encryptRefresh_token forKey:WXLoginRefreshToken];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf getUserInfoWithToken:access_token openID:openid finishBlock:finishBlock];
            NSLog(@"success%s",__FUNCTION__);
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure%s",__FUNCTION__);
    }];
}
-(void)getWechatInfoWithRefreshToken:(NSString *)refresh_token finishBlock:(HMDWXLoginFinishBlock)finishBlock;{
    HMDWeakSelf(self)
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *refreshTokenURL = HMD_WINXIN_REFRESH_TOKEN;
    
    NSDictionary *refreshTokenDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"wxed8c151bb3208370",@"appid",
                                @"refresh_token",@"grant_type",
                                refresh_token,@"refresh_token",
                                nil];
    [session GET:refreshTokenURL parameters:refreshTokenDict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *tokenDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[tokenDict allKeys]containsObject:@"errcode"]) {
            //过期失败
            NSLog(@"过期失败failure%s",__FUNCTION__);
            if (finishBlock) {
                finishBlock(NO,nil);
            }
        }else{
            NSString *access_token = [tokenDict objectForKey:@"access_token"];//有效期2小时
            NSString *refresh_token = [tokenDict objectForKey:@"refresh_token"];//有效期30天
            NSString *openid = [tokenDict objectForKey:@"openid"];
            NSString *encryptRefresh_token = [EncryptionTools encryptAESWithHINAVI:refresh_token];
            [[NSUserDefaults standardUserDefaults] setObject:encryptRefresh_token forKey:WXLoginRefreshToken];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf getUserInfoWithToken:access_token openID:openid finishBlock:finishBlock];
            NSLog(@"success%s",__FUNCTION__);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure%s",__FUNCTION__);
    }];
}
-(void)getUserInfoWithToken:(NSString *)token openID:(NSString *)openID finishBlock:(HMDWXLoginFinishBlock)finishBlock{
    HMDWeakSelf(self)
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *userInfoURL = HMD_WINXIN_USERINFO;
    
    NSDictionary *userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      token,@"access_token",
                                      openID,@"openid",
                                      nil];
    [session GET:userInfoURL parameters:userInfoDict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *tokenDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[tokenDict allKeys]containsObject:@"errcode"]) {
            //过期失败
            if (finishBlock) {
                finishBlock(NO,nil);
            }
            NSLog(@"过期失败failure%s",__FUNCTION__);
        }else{
            NSDictionary *wxDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            //获取后台的信息
            [weakSelf getHIMEDIALoginInfoWithWXInfo:wxDict finishBlock:finishBlock];

            NSLog(@"success%s",__FUNCTION__);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure%s",__FUNCTION__);
    }];
}

-(void)getHIMEDIALoginInfoWithWXInfo:(NSDictionary *)wxInfoDict finishBlock:(HMDWXLoginFinishBlock)finishBlock{
    
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *openid = [wxInfoDict objectForKey:@"openid"];
    NSDictionary *parametersDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  openid,@"wxid",
                                  nil];
    NSString *encodeParameters = [self encryptParameters:parametersDict];

    [session POST:HMD_HINAVI_LOGIN parameters:encodeParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //解密
        NSString *decodeResponseStr = [self decryptResponseObject:responseObject];
        NSDictionary *hmdDict = [NSJSONSerialization JSONObjectWithData:[decodeResponseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([[hmdDict allKeys]containsObject:@"hid"]) {
            NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionaryWithDictionary:wxInfoDict];
            [userInfoDict addEntriesFromDictionary:hmdDict];
            HMDUserModel *userModel = [HMDUserModel hmd_modelWithDictionary:userInfoDict];
            [[NSUserDefaults standardUserDefaults] setObject:userModel.hid forKey:WXCurHID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (finishBlock) {
                finishBlock(YES,userModel);
            }
            NSLog(@"success%s",__FUNCTION__);
        }else{

            if (finishBlock) {
                finishBlock(NO,nil);
            }
            NSLog(@"过期失败failure%s",__FUNCTION__);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure%s",__FUNCTION__);
    }];
}
-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
@end
