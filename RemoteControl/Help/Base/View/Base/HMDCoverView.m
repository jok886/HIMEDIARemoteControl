//
//  HMDCoverView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/27.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDCoverView.h"
@interface HMDCoverView()
@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@property (nonatomic,strong) CAShapeLayer *progressLayer;
@end
@implementation HMDCoverView
#define degreesToRadians(x) (M_PI*(x)/180.0)

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupDefaultValue];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupDefaultValue];
}

-(void)setupDefaultValue{
    self.cornerRadius = 4;
    self.borderWidth = 1;
}
-(void)setGradientLayer{
    CGRect rect = self.bounds;
    //渐变色
    if (_gradientLayer) {
        [_gradientLayer removeFromSuperlayer];
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = rect;
    gradientLayer.colors = @[(id)HMDColorFromValue(0x3BC797).CGColor,(id)HMDColorFromValue(0x3BC7C5).CGColor];  // 设置渐变颜色
    gradientLayer.startPoint = CGPointMake(0.5, 0);   //
    gradientLayer.endPoint = CGPointMake(0.5, 1);     //

    
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.frame = rect;
    progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    progressLayer.strokeColor  = [[UIColor redColor] CGColor];
    progressLayer.lineCap = kCALineCapRound;
    progressLayer.lineWidth = self.borderWidth;
    CGFloat offset = 0.5 * self.borderWidth;
    CGFloat radius = self.cornerRadius + offset;
    CGFloat radius_O = self.cornerRadius + self.borderWidth;          //外径
    //边框
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(radius, offset)];
    
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect) - radius, offset)];
    [path addArcWithCenter:CGPointMake(CGRectGetMaxX(rect)-radius_O, radius_O) radius:radius startAngle:degreesToRadians(-90) endAngle:degreesToRadians(0) clockwise:YES];
    
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect)-offset, CGRectGetMaxY(rect)-radius_O)];
    [path addArcWithCenter:CGPointMake(CGRectGetMaxX(rect)-radius_O, CGRectGetMaxY(rect)-radius_O) radius:radius startAngle:degreesToRadians(0) endAngle:degreesToRadians(90) clockwise:YES];
    
    [path addLineToPoint:CGPointMake(radius, CGRectGetMaxY(rect)-offset)];
    [path addArcWithCenter:CGPointMake(radius_O, CGRectGetMaxY(rect)-radius_O) radius:radius startAngle:degreesToRadians(90) endAngle:degreesToRadians(180) clockwise:YES];
    
    [path addLineToPoint:CGPointMake(offset, radius_O)];
    [path addArcWithCenter:CGPointMake(radius_O, radius_O) radius:radius startAngle:degreesToRadians(180) endAngle:degreesToRadians(270) clockwise:YES];

    progressLayer.path = [path CGPath];
    progressLayer.strokeEnd = 1.0;
    gradientLayer.mask = progressLayer;
    [self.layer insertSublayer:gradientLayer atIndex:0];
    self.gradientLayer = gradientLayer;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setGradientLayer];
}
@end
