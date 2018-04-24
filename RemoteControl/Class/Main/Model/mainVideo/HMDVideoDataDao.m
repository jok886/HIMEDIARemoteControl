//
//  HMDVideoDataDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDVideoDataDao.h"
#import "HMDVideoModel.h"

@implementation HMDVideoDataDao
-(void)getRecommendVideoDataFinish:(HMDGetRecommendVideoDataFinishBlock)finish{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *recommendURL = [NSString stringWithFormat:HMD_DLAN_VIDEO_RECOMMEND_NETLIST,HMDCURLINKDEVICEIP];
    [session GET:recommendURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
        if ([[responseDict allKeys]containsObject:@"poster"]) {
            NSArray *posterArray = [responseDict objectForKey:@"poster"];
            NSArray *videoModelArray = [HMDVideoModel hmd_modelArrayWithKeyValuesArray:posterArray];
            if (finish) {
                finish(YES,videoModelArray);
            }
        }else{
            if (finish) {
                finish(NO,nil);
            }
        }

        NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finish) {
            finish(NO,nil);
        }
        NSLog(@"failure");
    }];
}

-(void)PostPlayNetPosterOrder:(HMDVideoModel *)videoModel finishBlock:(HMDPostPlayNetPosterOrderFinishBlock)finish{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *recommendURL = [NSString stringWithFormat:HMD_DLAN_VIDEO_POSTER_PLAY,HMDCURLINKDEVICEIP];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                videoModel.source_package,@"source_package",
                                videoModel.callback_method,@"callback_method",
                                videoModel.callback_key,@"callback_key",
                                videoModel.callback_value,@"callback_value",
                                nil];
    [session POST:recommendURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (finish) {
            finish(YES);
        }
        NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finish) {
            finish(NO);
        }
        NSLog(@"failure");
    }];
}
@end
