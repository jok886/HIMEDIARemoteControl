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

#import "HMDXMLParserTool.h"
#import <HPCastLink/HPCastLink.h>

#define HMD_HOST_SSDP @"239.255.255.250"
#define HMD_PORT_SSDP 1900

@interface HMDSearchDeviceDao()<GCDAsyncUdpSocketDelegate,HPCastLinkDelegate,HPCastSearchDelegate>
@property (nonatomic,strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic,strong) NSMutableDictionary *deviceDict;               //设备字典location为Key
@property (nonatomic,strong) NSMutableArray *deviceIPArray;                 //已经加过的设备IP
@property (nonatomic,strong) NSLock *lock;                                  //已经加过的设备IP
@end

@implementation HMDSearchDeviceDao

#pragma mark - 搜索
-(void)searchDevices{

    uint16_t port = 0;
    NSError * error = nil;
    [self.deviceDict removeAllObjects];
    [self.deviceIPArray removeAllObjects];

    self.udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.udpSocket enableBroadcast:YES error:&error];
    [self.udpSocket bindToPort:port error:&error];

    NSError *joinError = nil;
    [self.udpSocket joinMulticastGroup:HMD_HOST_SSDP error:&joinError];
    NSString *str = HMD_DLAN_SEARCHDEVICE;
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

    if ([[deviceDict allKeys]containsObject:@"LOCATION"]) {
//        NSLog(@"LOCATION:%@",deviceDict[@"LOCATION"]);
        NSString *location = deviceDict[@"LOCATION"];
        if (![[self.deviceDict allKeys]containsObject:location]) {
            //新发现的设备
            [self.deviceDict setObject:deviceDict forKey:location];
            if (self.delegate && [self.delegate respondsToSelector:@selector(SearchNewDevice:)]) {
                HMDDeviceModel *newDeviceModel = [HMDDeviceModel hmd_modelWithDictionary:deviceDict];
                [self.delegate SearchNewDevice:newDeviceModel];
            }
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
    NSString *ip = deviceModel.ip;
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [str stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    HMDWeakSelf(self)
    __block HMDDeviceModel *deviceModelBlock = deviceModel;
    AFHTTPSessionManager *session = [self getAFHTTPSessionManager];
    [session GET:encodeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"downloadProgress");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @synchronized(self){
            [deviceModelBlock upInfoWithXMLData:responseObject];
            if (![weakSelf.deviceIPArray containsObject:ip]) {
                
                if ([deviceModelBlock.deviceType containsString:@"MediaRenderer"] || [deviceModelBlock.deviceType containsString:@"AVTransport"]) {
                    NSLog(@"增加IP:%@",deviceModelBlock.ip);
                    [weakSelf.deviceIPArray addObject:ip];
                    if (weakSelf.finishBlock) {
                        weakSelf.finishBlock(YES, deviceModelBlock);
                    }
                }else{
                    NSLog(@"过滤了一个设备%@   deviceType:%@",deviceModelBlock.ip,deviceModelBlock.deviceType);
                }
            }else{
                NSLog(@"过滤了一个设备IP:%@",deviceModelBlock.ip);
            }
        }
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

-(NSMutableArray *)deviceIPArray{
    if (_deviceIPArray == nil) {
        _deviceIPArray = [NSMutableArray array];
    }
    return _deviceIPArray;
}

-(NSLock *)lock{
    if (_lock) {
        _lock = [[NSLock alloc]init];
    }
    return _lock;
}


/**
 设备连接成功
 */
-(void)devicesConnectSucceed{
    NSLog(@"devicesConnectSucceed");
}

/**
 TV投屏URL播放失败
 */
- (void)tvVideoCastFailure{
    NSLog(@"tvVideoCastFailure");
}

/**
 TV视频结束播放
 */
- (void)tvVideoEndPlay{
    NSLog(@"tvVideoEndPlay");
}

/**
 视频播放进度返回 （回调频率为一秒一次）
 
 @param progress 进度
 */
- (void)videoDynamicPlayProgress:(HPProgress)progress{
    
}

/**
 视频播放状态改变时触发
 
 @param state 播放状态
 */
- (void)videoPlayStateChangeWithState:(HPPlayState)state{
    
}

/**
 媒体音量改变时触发
 
 @param volume 音量
 */
- (void)multimediaVolumeChangeWithVolume:(HPVolume)volume{
    
}

/**
 设备连接断开
 */
- (void)devicesDisconnect{
    NSLog(@"devicesDisconnect");
}

/**
 TV端透传过来的字符串
 
 @param message 透传数据
 */
- (void)receivedTVRemoteControlStr:(NSString *)message{
    NSLog(@"receivedTVRemoteControlStr");
}

/**
 TV端透传过来的数据
 
 @param data 仅支持json 或 xml格式，开发时发送端与接收端约定好格式，使用正确的格式解析数据
 */
- (void)receivedTVRemoteControlData:(NSData *)data{
    NSLog(@"receivedTVRemoteControlData");
}
@end
