//
//  HMDBaseModel.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/2.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMDBaseModel : NSObject
/**
字典转模型
 */
+(instancetype)hmd_modelWithDictionary:(NSDictionary *)dic;
/**
 JSON转模型
 */
+(instancetype)hmd_modelWithJSONString:(NSString *)jsonStr;
+(instancetype)hmd_modelWithJSONData:(NSData *)jsonData;
/**
 JSON转模型
 */
+(NSArray *)hmd_modelArrayWithKeyValuesArray:(NSArray *)dictArray;
@end
