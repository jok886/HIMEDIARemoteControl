//
//  HMDMusicListDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/22.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDMusicListDao.h"

@implementation HMDMusicListDao
-(void)getAllMusicListFinishBlock:(void (^)(BOOL, NSArray *))finishBlock{

    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *musicURL = [NSString stringWithFormat:HMD_DLAN_MUSIC_LIST,HMDCURLINKDEVICEIP];
    session.requestSerializer.timeoutInterval = 200.f;
    [session GET:musicURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responsDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *musicArray;
        if ( [responsDict isKindOfClass:[NSDictionary class]] && [[responsDict allKeys] containsObject:@"filelist"]) {
            musicArray = [responsDict objectForKey:@"filelist"];
        }
        if (musicArray.count>0) {
            if (finishBlock) {
                finishBlock(YES,musicArray);
            }
        }else{
            if (finishBlock) {
                finishBlock(NO,nil);
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

-(void)playMusicWithFilePath:(NSString *)filePath finishBlock:(void (^)(BOOL))finishBlock{
    
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *musicURL = [NSString stringWithFormat:HMD_DLAN_MUSIC_PLAY,HMDCURLINKDEVICEIP];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:filePath forKey:@"posterPicString"];
    [session POST:musicURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
@end
