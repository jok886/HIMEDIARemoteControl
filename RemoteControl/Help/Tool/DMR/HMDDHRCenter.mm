//
//  HMDDHRCenter.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/16.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDDHRCenter.h"

@implementation HMDDHRCenter
+(HMDDHRCenter *)sharedInstance
{
    static HMDDHRCenter * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HMDDHRCenter alloc] init];
        
    });
    return instance;
}
-(instancetype)init
{
    if (self = [super init]) {
        _DMRControl = [[HMDDMRControl alloc] init];
        [_DMRControl start];
        
    }
    return self;
}
@end
