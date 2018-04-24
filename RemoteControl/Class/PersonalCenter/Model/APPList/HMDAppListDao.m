//
//  HMDAppListDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDAppListDao.h"
#import "HMDAPKModel.h"

@implementation HMDAppListDao
-(void)getInstallAppListFinishBlock:(HMDGetAppListFinishBlock)finishBlock{
    
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *urlStr = [NSString stringWithFormat:HMD_DLAN_ALLAPPLIST,HMDCURLINKDEVICEIP];

    [session GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[responseDict allKeys]containsObject:@"apks"]) {
            NSArray *apksDict = [responseDict objectForKey:@"apks"];
            NSArray *apkModelArray = [HMDAPKModel hmd_modelArrayWithKeyValuesArray:apksDict];
            if (finishBlock) {
                finishBlock(YES,apkModelArray);
            }
            NSLog(@"success%s",__FUNCTION__);
        }else{
            
            if (finishBlock) {
                finishBlock(NO,nil);
            }
            NSLog(@"过期失败failure%s",__FUNCTION__);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure%s",__FUNCTION__);
    }];
}
@end
