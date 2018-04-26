//
//  HMDTVModel.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/25.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTVModel.h"

@implementation HMDTVModel
//映射关系
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"tvID":@"id",};
}
@end
