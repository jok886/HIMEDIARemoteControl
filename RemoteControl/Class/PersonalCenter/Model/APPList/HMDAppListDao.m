//
//  HMDAppListDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDAppListDao.h"
#import "GCDAsyncUdpSocket.h"

@interface HMDAppListDao()<GCDAsyncUdpSocketDelegate>
@property (nonatomic,strong) GCDAsyncUdpSocket *udpSocket;

@end
@implementation HMDAppListDao
-(void)dealloc{
    if (_udpSocket) {
        [_udpSocket close];
    }
}
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
            NSLog(@"failure%s",__FUNCTION__);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure%s",__FUNCTION__);
    }];
}

-(void)getRecommendAppListFinishBlock:(HMDGetAppListFinishBlock)finishBlock{
    
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *urlStr = HMD_HINAVI_ALLAPPLIST;
    NSDictionary *parametersDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    HMDCURWECHAHID,@"hid",
                                    nil];
    NSString *encryptParameters = [self encryptParameters:parametersDict];
    [session POST:urlStr parameters:encryptParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //解密
        NSString *decodeResponseStr = [self decryptResponseObject:responseObject];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[decodeResponseStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([[responseDict allKeys]containsObject:@"results"] && [[responseDict allKeys]containsObject:@"status"]) {
            NSString *status = [responseDict objectForKey:@"status"];
            if ([status isEqualToString:@"200"]) {
                NSArray *apksDict = [responseDict objectForKey:@"results"];
                NSArray *apkModelArray = [HMDAPKModel hmd_modelArrayWithKeyValuesArray:apksDict];
                if (finishBlock) {
                    finishBlock(YES,apkModelArray);
                }
                NSLog(@"success%s",__FUNCTION__);
            }else{
                if (finishBlock) {
                    finishBlock(NO,nil);
                }
                NSLog(@"failure%s",__FUNCTION__);
            }

        }else{
            if (finishBlock) {
                finishBlock(NO,nil);
            }
            NSLog(@"failure%s",__FUNCTION__);

        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO,nil);
        }
        NSLog(@"failure%s",__FUNCTION__);
    }];
}


-(void)openDLanAppWithPackage:(NSString *)package FinishBlock:(HMDOpenAppFinishBlock)finishBlock{
    
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *urlStr = [NSString stringWithFormat:HMD_DLAN_OPENAPK,HMDCURLINKDEVICEIP];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                package,@"package",
                                @"",@"activity",
                                @"",@"action",
                                @"startActivity",@"cmd",
                                @"http://172.20.5.8/2.ts",@"data",
                                nil];
    [session POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",responseStr);
        if (finishBlock) {
            finishBlock(YES);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO);
        }
        NSLog(@"failure%s",__FUNCTION__);
    }];
}

-(void)installHINAVIAppWithAPKModel:(HMDAPKModel *)apkModel FinishBlock:(HMDOpenAppFinishBlock)finishBlock{
    [self startMonitoring];
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    NSString *urlStr = [NSString stringWithFormat:HMD_DLAN_INSTALLAPK,HMDCURLINKDEVICEIP];
    NSDictionary *parametersDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    apkModel.apk_url,@"u",
                                    apkModel.pkg,@"package",
                                    nil];

    [session GET:urlStr parameters:parametersDict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[responseDict allKeys]containsObject:@"package"]) {
            NSString *package = [responseDict objectForKey:@"package"];
            if ([package isEqualToString:apkModel.pkg]) {
                if (finishBlock) {
                    finishBlock(YES);
                }
            }else{
                if (finishBlock) {
                    finishBlock(NO);
                }
            }
            
        }else{
            if (finishBlock) {
                finishBlock(NO);
            }
            NSLog(@"failure%s",__FUNCTION__);
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(NO);
        }
        NSLog(@"failure%s",__FUNCTION__);
    }];
}
#pragma mark - 下载监听
-(void)startMonitoring{
    NSError *error;
    if (_udpSocket == nil) {
        [self.udpSocket beginReceiving:&error];
        if (nil != error) {
            NSLog(@"failed.:%@",[error description]);
        }
    }

}

#pragma mark -GCDAsyncUdpsocket Delegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext

{
    NSString *package = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (self.installAppFinishBlock) {
        self.installAppFinishBlock(package);
    }
    NSLog(@"Reciv Data len:%lu",(unsigned long)[data length]);
    
}



- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error

{
    
    NSLog(@"udpSocketDidClose Error:%@",[error description]);
    
}
#pragma mark - 懒加载
-(GCDAsyncUdpSocket *)udpSocket{
    if (_udpSocket == nil) {
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *error;
        
        [_udpSocket bindToPort:10018 error:&error];
        
        if (nil != error) {
            
            NSLog(@"failed.:%@",[error description]);
            
        }
        
        
        
        [_udpSocket enableBroadcast:YES error:&error];
        
        if (nil != error) {
            
            NSLog(@"failed.:%@",[error description]);
            
        }
        
        [_udpSocket joinMulticastGroup:@"238.0.0.1" error:&error];
        
        if (nil != error) {
            NSLog(@"failed.:%@",[error description]);
        }


    }
    return _udpSocket;
}
@end
