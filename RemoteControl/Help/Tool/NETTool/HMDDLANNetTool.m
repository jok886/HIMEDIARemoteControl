//
//  HMDDLANNetTool.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/4.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDDLANNetTool.h"

#import <SystemConfiguration/CaptiveNetwork.h>//获取WiFi信息
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
#import <GCDWebServer/GCDWebServerFileResponse.h>
#import <AFNetworking/AFNetworking.h>

#import "UIImage+Extend.h"
#import "HMDProgressHub.h"
@interface HMDDLANNetTool ()
@property (nonatomic,strong) GCDWebServer *webServer;
@property (nonatomic,assign) BOOL firstTimeNet;                 //第一次网络状态判断
@property (nonatomic,assign) BOOL openWebServer;                //需要开启网络服务
@end


@implementation HMDDLANNetTool
+(HMDDLANNetTool *)sharedInstance
{
    static HMDDLANNetTool * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HMDDLANNetTool alloc] init];
        instance.firstTimeNet = YES;
    });
    return instance;
}

/**
 * 获取WiFi 信息，返回的字典中包含了WiFi的名称、路由器的Mac地址、还有一个Data(转换成字符串打印出来是wifi名称)
 */
+ (NSDictionary *)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if (!ifs) {
        return nil;
    }
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
}

/** 获取WiFi的名称 */
+ (NSString *)fetchWiFiName {
    NSString *WiFiName = nil;
    NSDictionary *info = [HMDDLANNetTool fetchSSIDInfo];
    if (info && [info count]) {
        // 这里其实对应的有三个key:kCNNetworkInfoKeySSID、kCNNetworkInfoKeyBSSID、kCNNetworkInfoKeySSIDData，
        // 不过它们都是CFStringRef类型的
        WiFiName = [info objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
        //            WiFiName = [info objectForKey:@"SSID"];
    }
    return WiFiName;
}


/** 获取本机在WiFi环境下的IP地址 */
+ (NSString *)getLocalIPAddressForCurrentWiFi{
    NSString *address;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    return address;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
        freeifaddrs(interfaces);
    }
    return address;
}

/** 广播地址、子网掩码、端口等，组装成一个字典。 */
+ (NSMutableDictionary *)getLocalInfoForCurrentWiFi {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    //----192.168.1.255 广播地址
                    NSString *broadcast = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    if (broadcast) {
                        [dict setObject:broadcast forKey:@"broadcast"];
                    }
                    NSLog(@"broadcast address--%@",broadcast);
                    //--192.168.1.106 本机地址
                    NSString *localIp = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    if (localIp) {
                        [dict setObject:localIp forKey:@"localIp"];
                    }
                    NSLog(@"local device ip--%@",localIp);
                    //--255.255.255.0 子网掩码地址
                    NSString *netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                    if (netmask) {
                        [dict setObject:netmask forKey:@"netmask"];
                    }
                    NSLog(@"netmask--%@",netmask);
                    //--en0 端口地址
                    NSString *interface = [NSString stringWithUTF8String:temp_addr->ifa_name];
                    if (interface) {
                        [dict setObject:interface forKey:@"interface"];
                    }
                    NSLog(@"interface--%@",interface);
                    return dict;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return dict;
}

+(NSMutableDictionary *)getDeviceInfoForDataString:(NSString *)dataStr{
    NSArray *dataInfo = [dataStr componentsSeparatedByString:@"\n"];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    for (NSString *subStr in dataInfo) {
        @autoreleasepool{
            if ([subStr containsString:@":"]) {
                NSRange indexRang = [subStr rangeOfString:@":"];
                NSInteger strLength = subStr.length;
                NSString *key = [subStr substringWithRange:NSMakeRange(0, indexRang.location)];
                NSString *value = [subStr substringWithRange:NSMakeRange(indexRang.location+1, strLength - indexRang.location-1)];
                while ([value hasPrefix:@" "]) {
                    value = [value substringWithRange:NSMakeRange(1, value.length-1)];
                }
                if ([value containsString:@"\r"]) {
                    //结尾的换行删掉
                    NSRange indexRang = [value rangeOfString:@"\r"];
                    if (indexRang.location == value.length-1) {
                        value = [value substringWithRange:NSMakeRange(0, value.length-1)];
                    }
                }
                [infoDict setObject:value forKey:key];
                //获取UUID
                if ([key isEqualToString:@"USN"]) {
                    //获取IP
                    //正则表达式
                    NSString *pattern = @"\\w{4}-\\w{4}-\\w{4}-\\w{4}-\\w{4}-\\w{4}-\\w{4}-\\w{4}-";
                    //创建predicate
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                           options:NSRegularExpressionCaseInsensitive
                                                                                             error:nil];
                    //查找第一个匹配结果，如果查找不到的话match会是nil
                    NSTextCheckingResult *match = [regex firstMatchInString:value
                                                                    options:NSMatchingReportCompletion
                                                                      range:NSMakeRange(0, [value length])];
                    if (match)
                    {
                        NSString *curUUID = [value substringWithRange:match.range];
                        [infoDict setObject:curUUID forKey:@"UUID"];
                    }
                }
            }
        }
    }
    return infoDict;
}

+(BOOL)isRightIPAddress:(NSString *)ip{
    {

        //正则表达式
        NSString *pattern = @"^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)$";
        //创建predicate
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        //查找第一个匹配结果，如果查找不到的话match会是nil
        NSTextCheckingResult *match = [regex firstMatchInString:ip
                                                        options:NSMatchingReportCompletion
                                                          range:NSMakeRange(0, [ip length])];
        if (match)
        {
            return YES;
        }else{
            return NO;
        }
    }
}

#pragma mark - httpWebServer
-(void)setupWebServer{
    
    NSLog(@"ip:%@",[HMDDLANNetTool getLocalIPAddressForCurrentWiFi]);
    //不符合时的响应
    //    GCDWebServerResponse *mediaNotFoundResponse = [[GCDWebServerResponse alloc] initWithStatusCode:404];
    //图片响应
    HMDWeakSelf(self)
    [self.webServer addHandlerForMethod:@"GET" pathRegex:@"/image/" requestClass:[GCDWebServerRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
        NSString *filePath = [weakSelf getFilePathWithRequestURL:request.URL.absoluteString fileType:HMDDLANNetFileImageType];
        
        NSData *imageData = [weakSelf getImageDataWithFilePath:filePath];
        
        GCDWebServerDataResponse *response = [GCDWebServerDataResponse responseWithData:imageData contentType:@"image/jpeg"];
        completionBlock(response);
    }];
    [self.webServer addHandlerForMethod:@"GET" pathRegex:@"/video/" requestClass:[GCDWebServerRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
        NSString *filePath = [weakSelf getFilePathWithRequestURL:request.URL.absoluteString fileType:HMDDLANNetFileVideoType];
        NSLog(@"request.byteRange____length:%lu____location:%lu__filePath:%@",(unsigned long)request.byteRange.length,(unsigned long)request.byteRange.location,filePath);
        
        GCDWebServerFileResponse *response = [GCDWebServerFileResponse responseWithFile:filePath byteRange:request.byteRange];
        completionBlock(response);
    }];
    
}
-(void)startWebServer{
    self.openWebServer = YES;
    [self.webServer startWithPort:8899 bonjourName:nil];
}

-(void)stopWebServer{
    self.openWebServer = NO;
    [self.webServer stop];
}

-(NSString *)getFilePathWithRequestURL:(NSString *)url fileType:(HMDDLANNetFileType)fileType{
    NSString *fileName;

    switch (fileType) {
        case HMDDLANNetFileImageType:
            {
                NSArray *separate = [url componentsSeparatedByString:@"/image/"];
                fileName = [separate lastObject];
            }
            break;
        case HMDDLANNetFileVideoType:
        {
            NSArray *separate = [url componentsSeparatedByString:@"/video/"];
            fileName = [separate lastObject];
        }
            break;
        case HMDDLANNetFileMusicType:
        {
            NSArray *separate = [url componentsSeparatedByString:@"/music/"];
            fileName = [separate lastObject];
        }
            break;
        default:
            break;
    }
    //截取地址信息
    NSString *filePath = [HMDDLANNetTool saveFileForName:fileName saveType:fileType];
    return filePath;
}

-(NSData *)getImageDataWithFilePath:(NSString *)filePath{
    NSData *imageData;
    UIImage *curImage = [UIImage imageWithContentsOfFile:filePath];

    if ([filePath containsString:@".png"]) {
        imageData = UIImagePNGRepresentation(curImage);
    }else{
        imageData = UIImageJPEGRepresentation(curImage, 1.0);
    }

    return imageData;
}

+(NSString *)getFileNameWithExtensionName:(NSString *)extensionName {
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmmssSSS"];
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];

    datestr = [datestr stringByAppendingString:extensionName];
    return datestr;
}

+(NSString *)saveFileForName:(NSString *)fileName saveType:(HMDDLANNetFileType)fileType{

    //草稿放在NSDocumentDirectory,其余放在NSCachesDirectory
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    NSString *pathStr = @"httpWeb/";
    switch (fileType) {
        case HMDDLANNetFileImageType:
            pathStr = [pathStr stringByAppendingString:@"image"];
            break;
        case HMDDLANNetFileVideoType:
            pathStr = [pathStr stringByAppendingString:@"video"];
            break;
        case HMDDLANNetFileMusicType:
            pathStr = [pathStr stringByAppendingString:@"music"];
            break;
        default:
            break;
    }
    NSString *filePath = [path stringByAppendingPathComponent:pathStr];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileDir is exists.");
    }
    NSString *videoFilePath = [NSString stringWithFormat:@"%@/%@",filePath,fileName];
    return videoFilePath;
}

+(NSString *)getHttpWebURLWithFileName:(NSString *)fileName fileType:(HMDDLANNetFileType)fileType{
 
    NSString *pathStr;
    switch (fileType) {
        case HMDDLANNetFileImageType:
            pathStr = @"image";
            break;
        case HMDDLANNetFileVideoType:
            pathStr = @"video";
            break;
        case HMDDLANNetFileMusicType:
            pathStr = @"music";
            break;
        default:
            break;
    }
    NSString *url = [NSString stringWithFormat:@"http://%@:8899/%@/%@",[HMDDLANNetTool getLocalIPAddressForCurrentWiFi],pathStr,fileName];

    return url;
}
#pragma mark - 网络环境变换
-(void)startNotificationWifi{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (self.firstTimeNet) {
            self.firstTimeNet = NO;
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    self.wifiEnvironmental = YES;
                    break;
                default:
                    self.wifiEnvironmental = NO;
                    break;
            }
        }else{
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    self.wifiEnvironmental = YES;
                    [self linkWithWIFI];
                    break;
                default:
                    self.wifiEnvironmental = NO;
                    [self unLinkWithWIFI];
                    break;
            }
        }
        
    }];
    [manager startMonitoring];
}
//进入wifi链接
-(void)linkWithWIFI{
    [HMDProgressHub showMessage:@"链接到wifi" hideAfter:1.5];
}
//丢失wifi链接
-(void)unLinkWithWIFI{
    [HMDProgressHub showMessage:@"与wifi断开链接" hideAfter:1.5];
}
#pragma mark - 懒加载
-(GCDWebServer *)webServer{
    if (_webServer == nil) {
        _webServer = [[GCDWebServer alloc] init];
    }
    return _webServer;
}

-(void)setWifiEnvironmental:(BOOL)wifiEnvironmental{
    _wifiEnvironmental = wifiEnvironmental;
    if (wifiEnvironmental) {
        if (![self.webServer isRunning]) {
            if (self.openWebServer) {
                [self.webServer startWithPort:8899 bonjourName:nil];
            }
        }
    }else{
        if ([self.webServer isRunning]) {
            [self.webServer stop];
        }
    }
}
@end
