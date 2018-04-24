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
//#import <HPCastLink/HPDevicesService.h>
@implementation HMDTreasureChestDao
+(void)startPlayToTVWithImageData:(NSData *)imageData{
    if ([[HPCastLink sharedCastLink] isConnectTv]) {
        NSLog(@"主动断开");
        [[HPCastLink sharedCastLink] castSwithPhotoData:imageData completeBlock:^(BOOL succeed) {
            NSLog(@"");
        }];
    }else{
        [[HPCastLink sharedCastLink] searchTvDevicesServiceBlock:^(NSArray<HPDevicesService *> *response) {
            
            [[HPCastLink sharedCastLink] stopSearchTvDevicesService];
            for (HPDevicesService *device in response) {
                NSString *ip = HMDCURLINKDEVICEIP;
                NSLog(@"图片%@",device.ipAddress);
                if ([device.ipAddress isEqualToString:ip]) {
                    [[HPCastLink sharedCastLink] castPhotoPlayByImageData:imageData toDevicesService:device completeBlock:^(BOOL succeed, NSError *error) {
                        NSLog(@"头图成功弄%@___%@__%@",device.ipAddress,device.name,device.devicemac);
                    }];
                }
            }
            
            
        }];
    }

}

+(void)startPlayVideoToTVWithURL:(NSString *)videoURL{
    if ([[HPCastLink sharedCastLink] isConnectTv]) {
        [[HPCastLink sharedCastLink] castSwitchSourcesPlay:HPCastMediaTypeVideo url:(NSString *)videoURL startPosition:0 completeBlock:^(BOOL succeed) {
            
        }];
    }else{
        [HPCastLink sharedCastLink].enableDLNA = YES;
        [[HPCastLink sharedCastLink] searchTvDevicesServiceBlock:^(NSArray<HPDevicesService *> *response) {
            [[HPCastLink sharedCastLink] stopSearchTvDevicesService];
            for (HPDevicesService *device in response) {
                NSString *ip = HMDCURLINKDEVICEIP;
                if ([device.ipAddress isEqualToString:ip]) {
                    [[HPCastLink sharedCastLink] castStartPlay:HPCastMediaTypeVideo url:videoURL startPosition:0 toDevicesService:device completeBlock:^(BOOL succeed, NSError *error) {
                    }];
                }
            }
        }];
    }
}
@end
