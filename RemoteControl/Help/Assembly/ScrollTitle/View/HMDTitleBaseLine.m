//
//  HMDTitleBaseLine.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/2.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTitleBaseLine.h"

@implementation HMDTitleBaseLine

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = HMDColorFromValue(0xFFA500);
    }
    return self;
}

-(void)setViewWithColor:(UIColor *)color{
    self.backgroundColor = color;
}
@end
