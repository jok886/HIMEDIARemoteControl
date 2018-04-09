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


@end
@implementation HMDDeviceLinkDao

-(void)getDeviceInfo:(NSString *)deviceIP finishBlock:(HMDDeviceLinkFinishBlock)finishBlock{
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
        if (weakSelf.finishBlock) {
            weakSelf.finishBlock(NO);
        }
        NSLog(@"failure");
    }];
}

@end
