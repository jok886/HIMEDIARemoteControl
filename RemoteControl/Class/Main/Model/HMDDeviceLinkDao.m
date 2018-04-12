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
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //超时时间
    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    session.requestSerializer.timeoutInterval = 2.f;
    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];

    NSString *url = [NSString stringWithFormat:HMD_NET_DEVICE_INFO,deviceIP];
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
