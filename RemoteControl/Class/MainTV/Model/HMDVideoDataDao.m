//
//  HMDVideoDataDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDVideoDataDao.h"
#import "HMDVideoModel.h"
#import "HMDVideoHistoryModel.h"
#import "NSString+HMDExtend.h"
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

-(void)getPlayHistoryFinishBlock:(HMDGetPlayHistoryFinishBlock)finishBlock{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *recommendURL = [NSString stringWithFormat:HMD_DLAN_VIDEO_PLAY_HISTORY,HMDCURLINKDEVICEIP];
    [session GET:recommendURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *posterArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
        if (posterArray.count>0) {
            NSArray *videoModelArray = [HMDVideoHistoryModel hmd_modelArrayWithKeyValuesArray:posterArray];
            if (finishBlock) {
                finishBlock(YES,videoModelArray);
            }
        }else{
            if (finishBlock) {
                finishBlock(YES,nil);
            }
        }
        
        NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure");
    }];
}

-(void)playHistoryWithHistoryModel:(HMDVideoHistoryModel *)videoHistoryModel FinishBlock:(HMDPostPlayNetPosterOrderFinishBlock)finishBlock{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *recommendURL = [NSString stringWithFormat:HMD_DLAN_VIDEO_PLAY_HISTORYVIDEO,HMDCURLINKDEVICEIP];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [videoHistoryModel.cmd mj_JSONString],@"cmd",
                                videoHistoryModel.videoSource,@"videoSource",
                                videoHistoryModel.videoImgUrl,@"videoImgUrl",
                                videoHistoryModel.extra,@"extra",
                                videoHistoryModel.videoCallback,@"videoCallback",
                                videoHistoryModel.date,@"date",
                                videoHistoryModel.videoAction,@"videoAction",
                                videoHistoryModel.videoName,@"videoName",
                                videoHistoryModel.vid,@"vid",
                                videoHistoryModel.week,@"week",
                                nil];
    [session POST:recommendURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (finishBlock) {
            finishBlock(YES);
        }
        NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO);
        }
        NSLog(@"failure");
    }];
}

-(void)getPosterCategoryFinishBlock:(HMDPosterCategoryFinishBlock)finishBlock{
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *recommendURL = [NSString stringWithFormat:HMD_DLAN_VIDEO_CATEGORY,HMDCURLINKDEVICEIP];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"/data/data/com.himedia.wallposter/shared_prefs/classifyxmlname.xml",@"posterCategory",
                                nil];
    [session POST:recommendURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (finishBlock) {
            finishBlock(YES,nil);
        }
        NSLog(@"success");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure");
    }];
}
@end
