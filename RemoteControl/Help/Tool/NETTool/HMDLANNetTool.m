//
//  HMDLANNetTool.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/4.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDLANNetTool.h"
#import <SystemConfiguration/CaptiveNetwork.h>//获取WiFi信息
#import <ifaddrs.h>
#import <arpa/inet.h>  
@implementation HMDLANNetTool

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
    NSDictionary *info = [HMDLANNetTool fetchSSIDInfo];
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
    NSString *address = HMDERRORLANADDRESS;
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

+(NSDictionary *)getDeviceInfoForDataString:(NSString *)dataStr{
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
                //获取IP
                if ([key isEqualToString:@"LOCATION"]) {
                    //                     http://192.168.31.238:25806/description.xml
                    //获取端口
                    //正则表达式
                    NSString *patternPort = @"\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}";
                    //创建predicate
                    NSRegularExpression *regexPort = [NSRegularExpression regularExpressionWithPattern:patternPort
                                                                                           options:NSRegularExpressionCaseInsensitive
                                                                                             error:nil];
                    //查找第一个匹配结果，如果查找不到的话match会是nil
                    NSTextCheckingResult *match = [regexPort firstMatchInString:value
                                                                    options:NSMatchingReportCompletion
                                                                      range:NSMakeRange(0, [value length])];
                    if (match)
                    {
                        NSString *port = [value substringWithRange:match.range];
                        [infoDict setObject:curIP forKey:@"port"];
                    }
                    //获取IP
                    //正则表达式
                    NSString *pattern = @"\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}";
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
                        NSString *curIP = [value substringWithRange:match.range];
                        [infoDict setObject:curIP forKey:@"IP"];
                    }
                }
            }
        }
    }
    return infoDict;
}
@end
