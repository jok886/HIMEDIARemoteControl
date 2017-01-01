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

@end
