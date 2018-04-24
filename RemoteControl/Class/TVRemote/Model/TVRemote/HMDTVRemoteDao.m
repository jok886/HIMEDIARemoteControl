//
//  HMDTVRemoteDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/9.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTVRemoteDao.h"
#import "AFNetworking.h"
@interface HMDTVRemoteDao()

@end
@implementation HMDTVRemoteDao


-(void)remoteTVWithKey:(NSInteger)key finishBlock:(HMDTVRemoteFinishBlock)finishBlock{
    if (finishBlock) {
        self.finishBlock = finishBlock;
    }

    HMDWeakSelf(self)
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%ld",(long)key],@"key",
                                nil];
    NSString *url = [NSString stringWithFormat:HMD_DLAN_KEYSTOKE_EVENT,HMDCURLINKDEVICEIP];
    [session GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (weakSelf.finishBlock) {
            weakSelf.finishBlock(YES);
        }
         NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (weakSelf.finishBlock) {
            weakSelf.finishBlock(NO);
        }
        NSLog(@"failure");
    }];
}



-(void)getAllAPK{
    HMDWeakSelf(self)
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    
    NSString *url = [NSString stringWithFormat:HMD_DLAN_DEVICE_GETALLAPK,HMDCURLINKDEVICEIP];
    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (weakSelf.finishBlock) {
            weakSelf.finishBlock(NO);
        }
        NSLog(@"failure");
    }];
}


@end
