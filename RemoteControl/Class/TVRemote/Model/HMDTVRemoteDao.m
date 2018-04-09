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
@property (nonatomic,strong) NSString *ip;
@end
@implementation HMDTVRemoteDao

-(instancetype)init{
    if (self = [super init]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:DLANLINKIP];
        self.ip = ip;
    }
    return self;
}

-(void)remoteTVWithKey:(NSInteger)key finishBlock:(HMDTVRemoteFinishBlock)finishBlock{
    if (finishBlock) {
        self.finishBlock = finishBlock;
    }
    HMDWeakSelf(self)
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //超时时间
    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    session.requestSerializer.timeoutInterval = 2.f;
    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml",@"text/plain",nil];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%ld",(long)key],@"key",
                                nil];
    NSString *url = [NSString stringWithFormat:HMD_NET_KEYSTOKE_EVENT,self.ip];
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
@end
