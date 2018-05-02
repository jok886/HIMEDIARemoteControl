//
//  HMDCoverView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/27.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDCoverView.h"

@implementation HMDCoverView
//-(instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        [self addPath];
//    }
//    return self;
//}
//-(void)awakeFromNib{
//    [super awakeFromNib];
//    [self addPath];
//}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint:CGPointMake(0, 0)];
    
    [path addLineToPoint:CGPointMake(w, 0)];
    [path addLineToPoint:CGPointMake(w, h)];
    [path addLineToPoint:CGPointMake(0, h)];
    [path addLineToPoint:CGPointMake(0, 0)];
    //设置线的状态
    path.lineWidth = 4;
    [HMDColor(255, 161, 50, 1) set];
    [path stroke];
}
-(void)addPath{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint:CGPointMake(0, 0)];
    
    [path addLineToPoint:CGPointMake(w, 0)];
    [path addLineToPoint:CGPointMake(w, h)];
    [path addLineToPoint:CGPointMake(0, h)];
    [path addLineToPoint:CGPointMake(0, 0)];
    //设置线的状态
    path.lineWidth = 4;
    [HMDColor(255, 161, 50, 1) set];
    [path stroke];
}
@end
