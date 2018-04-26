//
//  HMDVideoCMDModel.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/26.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDVideoCMDModel.h"

@implementation HMDVideoCMDModel

-(NSString *)lastTime{
    if (_lastTime == nil) {
        NSInteger time = [self.current_position integerValue];
        NSString *min = [NSString stringWithFormat:@"%02ld",time/60];
        NSString *sec = [NSString stringWithFormat:@"%02ld",time%60];
        _lastTime = [NSString stringWithFormat:@"%@:%@",min,sec];
    }
    return _lastTime;
}
@end
