//
//  HMDBaseDao.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
@interface HMDBaseDao : NSObject
//返回httpManager
-(AFHTTPSessionManager *)getAFHTTPSessionManager;
//返回httpManager
+(AFHTTPSessionManager *)getAFHTTPSessionManager;
//按参数字典返回加密过的字符串
-(NSString *)encryptParameters:(NSDictionary *)parameters;
//按data解密出对应的字符串
-(NSString *)decryptResponseObject:(NSData *)responseObject;
//后台数据返回成功
-(BOOL)successResponseFromHINAVI:(NSDictionary *)responseDict;
@end
