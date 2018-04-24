//
//  HMDDeviceLinkDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDDeviceLinkDao.h"

#import "AFNetworking.h"

@interface HMDDeviceLinkDao()
@property (nonatomic,assign) NSInteger linkTime;            //链接次数,自动重连3次
@property (nonatomic,strong) NSString *deviceIP;            //链接次数,自动重连3次
@end
@implementation HMDDeviceLinkDao

-(void)getDeviceInfo:(NSString *)deviceIP finishBlock:(HMDDeviceLinkFinishBlock)finishBlock{
    if (![self.deviceIP isEqualToString:deviceIP]) {
        self.linkTime = 0;
        self.deviceIP = deviceIP;
    }

    if (finishBlock) {
        self.finishBlock = finishBlock;
    }
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];

    NSString *url = [NSString stringWithFormat:HMD_DLAN_DEVICE_INFO,deviceIP];
    HMDWeakSelf(self)
    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (weakSelf.finishBlock) {
            weakSelf.finishBlock(YES);
        }
        NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Linkfailure:%@",error);
        weakSelf.linkTime++;
        if (weakSelf.linkTime>=3) {
            if (weakSelf.finishBlock) {
                weakSelf.finishBlock(NO);
            }
        }else{
            //自动重连
            [weakSelf getDeviceInfo:weakSelf.deviceIP finishBlock:weakSelf.finishBlock];
            NSLog(@"自动重连%ld",(long)weakSelf.linkTime);
        }
        
    }];
}

@end
