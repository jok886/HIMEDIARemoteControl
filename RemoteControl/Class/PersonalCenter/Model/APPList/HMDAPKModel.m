//
//  HMDAPKModel.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDAPKModel.h"

@implementation HMDAPKModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"apkID":@"id",
             @"apkClass":@"class",
             };
    
}
@end
