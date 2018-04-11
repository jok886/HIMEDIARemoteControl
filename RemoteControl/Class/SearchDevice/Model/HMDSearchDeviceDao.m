//
//  HMDSearchDeviceDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSearchDeviceDao.h"
#import "GCDAsyncUdpSocket.h"
#import "HMDLANNetTool.h"
#import "AFNetworking.h"
#import "HMDXMLParserTool.h"

#define HMD_HOST_SSDP @"239.255.255.250"
#define HMD_PORT_SSDP 1900

@interface HMDSearchDeviceDao()<GCDAsyncUdpSocketDelegate>
@property (nonatomic,strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic,strong) NSMutableDictionary *deviceDict;                   //设备字典UUID为Key
@end

@implementation HMDSearchDeviceDao

#pragma mark - 搜索
-(void)searchDevices{
    uint16_t port = 0;
    NSError * error = nil;
    [self.deviceDict removeAllObjects];
    self.udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.udpSocket enableBroadcast:YES error:&error];
    [self.udpSocket bindToPort:port error:&error];

    NSError *joinError = nil;
    [self.udpSocket joinMulticastGroup:HMD_HOST_SSDP error:&joinError];
    NSString *str = HMD_NET_SEARCHDEVICE;
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *receivingError = nil;
    [self.udpSocket beginReceiving:&receivingError];
    [self.udpSocket sendData:data toHost:HMD_HOST_SSDP port:HMD_PORT_SSDP withTimeout:-1 tag:0];
    [NSTimer scheduledTimerWithTimeInterval: 2 target: self
                                   selector:@selector(completeSearch) userInfo: self repeats: NO];
}

-(void)completeSearch{
    [self.udpSocket close];
    if (self.searchFinishBlock) {
        self.searchFinishBlock();
    }
    NSLog(@"搜索结束,发现%lu个设备",(unsigned long)[self.deviceDict allKeys].count);

}

#pragma mark - GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(nullable id)filterContext{
    NSString *receiveData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    if (ip == nil) {
        return;
    }
    NSMutableDictionary *deviceDict = [HMDLANNetTool getDeviceInfoForDataString:receiveData];
    [deviceDict setObject:ip forKey:@"IP"];
    [deviceDict setObject:[NSString stringWithFormat:@"%d",port] forKey:@"port"];
    if (![[self.deviceDict allKeys]containsObject:ip]) {
        //新发现的设备
        [self.deviceDict setObject:deviceDict forKey:ip];
        if (self.delegate && [self.delegate respondsToSelector:@selector(SearchNewDevice:)]) {
            HMDDeviceModel *newDeviceModel = [HMDDeviceModel hmd_modelWithDictionary:deviceDict];
            [self.delegate SearchNewDevice:newDeviceModel];
        }
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address{
    NSLog(@"didConnectToAddress");
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error{
    NSLog(@"didNotConnect");
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"didSendDataWithTag");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error{
    NSLog(@"didNotSendDataWithTag");
}

#pragma mark - 单独设备详情
-(void)getMoreInfoFromDevice:(HMDDeviceModel *)deviceModel finishBlock:(HMDSearchDeviceDaoGetMoreInfoFinishBlock)finishBlock{
    if (finishBlock) {
        self.finishBlock = finishBlock;
    }
    NSString *str = deviceModel.location;
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [str stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    HMDWeakSelf(self)
    __block HMDDeviceModel *deviceModelBlock = deviceModel;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //超时时间
    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    session.requestSerializer.timeoutInterval = 10.f;
    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/xml", nil];
    [session GET:encodeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"downloadProgress");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [deviceModelBlock upInfoWithXMLData:responseObject finishBlock:^(BOOL success, HMDDeviceModel *newDeviceModel) {
            //设备类型过滤
            if ([newDeviceModel.deviceType containsString:@"MediaRenderer"]) {
                if (weakSelf.finishBlock) {
                    weakSelf.finishBlock(success, newDeviceModel);
                }
            }else{
                NSLog(@"过滤了一个设备%@   deviceType:%@",newDeviceModel.ip,newDeviceModel.deviceType);
            }

        }];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取设备信息failure");
    }];
}
#pragma mark -懒加载
-(NSMutableDictionary *)deviceDict{
    if (_deviceDict == nil) {
        _deviceDict = [NSMutableDictionary dictionary];
    }
    return _deviceDict;
}
@end
