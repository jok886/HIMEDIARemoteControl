//
//  HMDBaseDao.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseDao.h"
#import "EncryptionTools.h"

@implementation HMDBaseDao

-(AFHTTPSessionManager *)getAFHTTPSessionManager{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer=[AFJSONRequestSerializer serializer];
    //超时时间
    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    session.requestSerializer.timeoutInterval = 30.f;
    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"text/xml",nil];
    return session;
}

+(AFHTTPSessionManager *)getAFHTTPSessionManager{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer=[AFJSONRequestSerializer serializer];
    //超时时间
    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    session.requestSerializer.timeoutInterval = 30.f;
    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"text/xml",nil];
    return session;
}

-(NSString *)encryptParameters:(NSDictionary *)parameters{
    NSString *parametersStr = [parameters mj_JSONString];
    NSString *encryptParameters = [EncryptionTools encryptAESWithHINAVI:parametersStr];
    return encryptParameters;
}

-(NSString *)decryptResponseObject:(NSData *)responseObject{
    NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    //解密
    NSString *decodeResponseStr = [EncryptionTools decryptAESWithHINAVI:responseStr];
    return decodeResponseStr;
}

-(BOOL)successResponseFromHINAVI:(NSDictionary *)responseDict{
    if ([[responseDict allKeys]containsObject:@"status"]) {
        NSString *status = [responseDict objectForKey:@"status"];
        if ([status isKindOfClass:[NSNumber class]]) {
            NSNumber *statusNum = (NSNumber *)status;
            status = [NSString stringWithFormat:@"%@",statusNum];
        }
        if ([status isEqualToString:@"200"]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
@end
