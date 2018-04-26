//
//  HMDBaseModel.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/2.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseModel.h"
#import "MJExtension.h"
@implementation HMDBaseModel
+(instancetype)hmd_modelWithDictionary:(NSDictionary *)dic{
    Class curClass = [self class];
    return [curClass mj_objectWithKeyValues:dic];
}

+(instancetype)hmd_modelWithJSONString:(NSString *)jsonStr{
    Class curClass = [self class];
    return [curClass mj_objectWithKeyValues:jsonStr];
}
+(instancetype)hmd_modelWithJSONData:(NSData *)jsonData{
    Class curClass = [self class];
    return [curClass mj_objectWithKeyValues:jsonData];
}
+(NSArray *)hmd_modelArrayWithKeyValuesArray:(NSArray *)dictArray{
    Class curClass = [self class];
    return [curClass mj_objectArrayWithKeyValuesArray:dictArray];
}
//映射关系
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    return @{
//             @"uuid":@"UUID",
//             @"location":@"LOCATION",
//             @"server":@"SERVER",
//             @"ip":@"IP",
//             };
    return nil;
}
@end
