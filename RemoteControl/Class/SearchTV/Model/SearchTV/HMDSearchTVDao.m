//
//  HMDSearchTVDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/12.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSearchTVDao.h"
#import "EncryptionTools.h"
#import "HMDVideoModel.h"

@implementation HMDSearchTVDao

-(void)searchTVHotTipWithFinishBlock:(HMDSearchTVTipFinishBlock)finishBlock{

    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSDictionary *parametersDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    HMDCURWECHAHID,@"hid",
                                    nil];
    NSString *encryptParameters = [self encryptParameters:parametersDict];
    [session POST:HMD_HINAVI_SEARCH_HOTWORD parameters:encryptParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解密
        NSString *decodeResponseStr = [self decryptResponseObject:responseObject];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[decodeResponseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([self successResponseFromHINAVI:responseDict]){
            if ([[responseDict allKeys] containsObject:@"results"]){
                NSArray *tipArray = [responseDict objectForKey:@"results"];
                if (finishBlock) {
                    finishBlock(YES,tipArray);
                }
            }else{
                if (finishBlock) {
                    finishBlock(NO,nil);
                }
            }
        }else{
            if (finishBlock) {
                finishBlock(NO,nil);
            }
        }
        NSLog(@"success:%s",__FUNCTION__);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure:%s",__FUNCTION__);
    }];
}

-(void)searchTVTipWithKeyWord:(NSString *)key FinishBlock:(HMDSearchTVTipFinishBlock)finishBlock{
    
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSDictionary *parametersDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    HMDCURWECHAHID,@"hid",
                                    key,@"key",
                                    nil];
    NSString *encryptParameters = [self encryptParameters:parametersDict];
    [session POST:HMD_HINAVI_SEARCH_KEYWORD parameters:encryptParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解密
        NSString *decodeResponseStr = [self decryptResponseObject:responseObject];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[decodeResponseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([self successResponseFromHINAVI:responseDict]){
            if ([[responseDict allKeys] containsObject:@"results"]){
                NSArray *tipArray = [responseDict objectForKey:@"results"];
                if (finishBlock) {
                    finishBlock(YES,tipArray);
                }
            }else{
                if (finishBlock) {
                    finishBlock(NO,nil);
                }
            }
        }else{
            if (finishBlock) {
                finishBlock(NO,nil);
            }
        }
        NSLog(@"success:%s",__FUNCTION__);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure:%s",__FUNCTION__);
    }];
}

-(void)searchTVWithKeyWord:(NSString *)key page:(NSInteger)page FinishBlock:(HMDSearchTVFinishBlock)finishBlock{
    
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSDictionary *parametersDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    HMDCURWECHAHID,@"hid",
                                    key,@"key",
                                    [NSString stringWithFormat:@"%ld",(long)page],@"page_number",
                                    @"9",@"page_count",
                                    nil];
    NSString *encryptParameters = [self encryptParameters:parametersDict];
    [session POST:HMD_HINAVI_SEARCH_TV parameters:encryptParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解密
        NSString *decodeResponseStr = [self decryptResponseObject:responseObject];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[decodeResponseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([self successResponseFromHINAVI:responseDict]){
            if ([[responseDict allKeys] containsObject:@"results"]){
                NSArray *results = [responseDict objectForKey:@"results"];
                NSArray *modelArray = [HMDVideoModel hmd_modelArrayWithKeyValuesArray:results];
                if (finishBlock) {
                    finishBlock(YES,modelArray);
                }
            }else{
                if (finishBlock) {
                    finishBlock(NO,nil);
                }
            }
        }else{
            if (finishBlock) {
                finishBlock(NO,nil);
            }
        }
        NSLog(@"success:%s",__FUNCTION__);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure:%s",__FUNCTION__);
    }];
}
@end
