//
//  HMDTreasureChestDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/12.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTreasureChestDao.h"
#import "HMDDHRCenter.h"
#import <HPCastLink/HPCastLink.h>
#import "GDataXMLNode.h"
#import "RemoteControl-Swift.h"
#import "AppDelegate.h"
//#import <HPCastLink/HPDevicesService.h>
@implementation HMDTreasureChestDao
//+(void)startPlayToTVWithImageData:(NSData *)imageData{
//    if ([[HPCastLink sharedCastLink] isConnectTv]) {
//        NSLog(@"主动断开");
//        [[HPCastLink sharedCastLink] castSwithPhotoData:imageData completeBlock:^(BOOL succeed) {
//            NSLog(@"");
//        }];
//    }else{
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        HPDevicesService *deviceModel = appDelegate.devicesService;
//        [[HPCastLink sharedCastLink] castPhotoPlayByImageData:imageData toDevicesService:deviceModel completeBlock:^(BOOL succeed, NSError *error) {
//            NSLog(@"头图成功弄%@___%@__%@",deviceModel.ipAddress,deviceModel.name,deviceModel.devicemac);
//        }];
//    }
//
//}

//+(void)startPlayMediaWithURL:(NSString *)mediaURL{
//
//    AFHTTPSessionManager *session = [HMDTreasureChestDao getAFHTTPSessionManager];
//
//    NSString *url = [NSString stringWithFormat:HMD_DLAN_PLAY_MEDIA,HMDCURLINKDEVICEIP];
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
//                                mediaURL,@"url",
//                                nil];
//    [session POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSLog(@"success");
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"Linkfailure:%@",error);
//
//    }];
//}

//+(void)startPlayVideoToTVWithURL:(NSString *)videoURL{
//    if ([[HPCastLink sharedCastLink] isConnectTv]) {
//        [[HPCastLink sharedCastLink] castSwitchSourcesPlay:HPCastMediaTypeVideo url:(NSString *)videoURL startPosition:0 completeBlock:^(BOOL succeed) {
//
//        }];
//    }else{
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        HPDevicesService *deviceModel = appDelegate.devicesService;
//        [[HPCastLink sharedCastLink] castStartPlay:HPCastMediaTypePhoto url:videoURL startPosition:0 toDevicesService:deviceModel completeBlock:^(BOOL succeed, NSError *error) {
//            NSLog(@"___");
//        }];
////        [HPCastLink sharedCastLink].enableDLNA = YES;
////        [[HPCastLink sharedCastLink] searchTvDevicesServiceBlock:^(NSArray<HPDevicesService *> *response) {
////            [[HPCastLink sharedCastLink] stopSearchTvDevicesService];
////            for (HPDevicesService *device in response) {
////                NSString *ip = HMDCURLINKDEVICEIP;
////                if ([device.ipAddress isEqualToString:ip]) {
////                    [[HPCastLink sharedCastLink] castStartPlay:HPCastMediaTypeVideo url:videoURL startPosition:0 toDevicesService:device completeBlock:^(BOOL succeed, NSError *error) {
////                    }];
////                }
////            }
////        }];
//    }
//}

//-(void)startPlayMediaWithURL:(NSString *)mediaURL{
//    NSString *ip = HMDCURLINKDEVICEIP;
//   
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
////    HPDevicesService *deviceModel = appDelegate.deviceModel;
//     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:25826",ip]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
//
//
//    
//    HMDDLan *dlan = [[HMDDLan alloc] init];
//    request.HTTPBody = [[dlan dLanSetAVTransportURIWithUri:mediaURL] dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"");
//    }];
//    [task resume];
//    
//
//}
@end
