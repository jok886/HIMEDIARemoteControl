//
//  CALayer+HMDXibAttributes.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/14.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "CALayer+HMDXibAttributes.h"

@implementation CALayer (HMDXibAttributes)
-(void)setBorderUIColor:(UIColor *)borderUIColor{
    self.borderColor = borderUIColor.CGColor;
}

-(UIColor *)borderUIColor{
    return [UIColor colorWithCGColor:self.borderColor];
}
@end
