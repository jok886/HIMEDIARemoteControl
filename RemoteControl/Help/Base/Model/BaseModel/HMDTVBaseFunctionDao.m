//
//  HMDTVBaseFunctionDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/12.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//  一些通用的功能

#import "HMDTVBaseFunctionDao.h"
#import "UIImageView+HMDDLANLoadImage.h"
@implementation HMDTVBaseFunctionDao
-(void)getImageCaptureFinishBlock:(HMDTVGetCaptureFinishBlock)finishBlock{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *ip = HMDCURLINKDEVICEIP;
    NSString *url = [NSString stringWithFormat:HMD_DLAN_DEVICE_GETCAPTURE,ip];
    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *filePath = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (finishBlock) {
            finishBlock(YES,filePath,ip);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil,nil);
        }
        NSLog(@"failure");
    }];
}
-(void)getCaptureFinishBlock:(HMDTVDownLoadImageFinishBlock)finishBlock{
    
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *ip = HMDCURLINKDEVICEIP;
    NSString *url = [NSString stringWithFormat:HMD_DLAN_DEVICE_GETCAPTURE,ip];
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
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:filePath forKey:@"posterPicString"];

    NSString *url = [NSString stringWithFormat:HMD_DLAN_DEVICE_DOWNLOADICON,ip];
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
