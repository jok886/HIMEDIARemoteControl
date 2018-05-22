//
//  HMDUpUserInfoDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/21.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDUpUserInfoDao.h"

@implementation HMDUpUserInfoDao
-(void)updateNicknameWithPhone:(NSString *)phoneNum nickName:(NSString *)nickName finishBlock:(void (^)(NSInteger))finishBlock{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:phoneNum forKey:@"phone"];
    [parameters setValue:nickName forKey:@"nickname"];
    
    NSString *encodeParameters = [self encryptParameters:parameters];
    NSString *url = HMD_HINAVI_PHONE_UPNICKNAME;
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

-(void)uploadAvatarWithPhone:(NSString *)phoneNum imageData:(NSData *)imageData finishBlock:(void (^)(BOOL, NSString *))finishBlock{
    HMDWeakSelf(self)
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"text/xml",nil];


        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"head" forKey:@"filekind"];
        [parameters setValue:@"image" forKey:@"filename"];
//        NSString *encodeParameters = [self encryptParameters:parameters];
        NSString *url = HMD_HINAVI_PHONE_UPLOADAVATAR;
        NSURLSessionDataTask *uploadTask = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

            
            NSString *typeName, *mimeType, *fileName;
                typeName = @"image";
                mimeType = @"image/*";
                fileName = @"fileName.jpg";

            [formData appendPartWithFileData:imageData name:typeName fileName:fileName mimeType:mimeType];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%lld--%lld",uploadProgress.totalUnitCount, uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //解密
            NSString *decodeResponseStr = [self decryptResponseObject:responseObject];
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[decodeResponseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            NSString *avatar;
            if ([responseDict isKindOfClass:[NSDictionary class]] && [[responseDict allKeys]containsObject:@"status"]) {
                if ([[responseDict objectForKey:@"status"] integerValue] == 200) {
                    if ([[responseDict allKeys]containsObject:@"avatar"]) {
                        avatar = [responseDict objectForKey:@"avatar"];
                    }
                }
            }
            if (avatar) {
                [weakSelf saveAvatarWithPhoneNum:phoneNum imageURL:avatar finishBlock:finishBlock];
            }else{
                if (finishBlock) {
                    finishBlock(NO,nil);
                }
            }
            NSLog(@"成功:%@",decodeResponseStr);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败:%@",error);
        }];
        [uploadTask resume];
}
-(void)saveAvatarWithPhoneNum:(NSString *)phoneNum imageURL:(NSString *)imageURL finishBlock:(void(^)(BOOL success,NSString *imageURL))finishBlock{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:phoneNum forKey:@"phone"];
    [parameters setValue:imageURL forKey:@"head_portrait_url"];
    
    NSString *encodeParameters = [self encryptParameters:parameters];
    NSString *url = HMD_HINAVI_PHONE_SAVEAVATAR;
    [session POST:url parameters:encodeParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解密
        NSString *decodeResponseStr = [self decryptResponseObject:responseObject];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[decodeResponseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([responseDict isKindOfClass:[NSDictionary class]] && [[responseDict allKeys]containsObject:@"status"]) {
            if (finishBlock) {
                NSString *status = [responseDict objectForKey:@"status"];
                if ([status integerValue] == 200) {
                    finishBlock(YES,imageURL);
                }else{
                    finishBlock(NO,nil);
                }
            }
        }else{
            if (finishBlock) {
                finishBlock(NO,nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure%s",__FUNCTION__);
    }];
}
@end
