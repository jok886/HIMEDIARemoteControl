//
//  HMDTVBaseFunctionDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/12.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//  一些通用的功能

#import "HMDTVBaseFunctionDao.h"
#import "AFNetworking.h"

@implementation HMDTVBaseFunctionDao
-(void)getCaptureFinishBlock:(HMDTVDownLoadImageFinishBlock)finishBlock{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //超时时间
    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    session.requestSerializer.timeoutInterval = 30.f;
    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml",@"text/plain",nil];
    NSString *ip = HMDCURLINKDEVICEIP;
    NSString *url = [NSString stringWithFormat:HMD_NET_DEVICE_GETCAPTURE,ip];
    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *filePath = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        [self downLoadImageFromFilepath:filePath ip:ip Finish:finishBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure");
    }];
}

-(void)downLoadImageFromFilepath:(NSString *)filePath ip:(NSString *)ip Finish:(HMDTVDownLoadImageFinishBlock)finishBlock{
    NSLog(@"下载");
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //超时时间
    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    session.requestSerializer.timeoutInterval = 30.f;
    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml",@"text/plain",nil];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                filePath,@"posterPicString",
                                nil];
    NSString *url = [NSString stringWithFormat:HMD_NET_DEVICE_DOWNLOADICON,ip];
    [session POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"----");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *encodedImageStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        if (finishBlock) {
            finishBlock(YES, decodedImageData);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO, nil);
        }
        NSLog(@"failure");
    }];
}
@end
