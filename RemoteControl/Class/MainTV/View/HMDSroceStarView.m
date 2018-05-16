//
//  HMDSroceStarView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/16.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSroceStarView.h"

@implementation HMDSroceStarView


-(void)setupStarLayerWithWidth:(CGFloat)width{
    CGFloat marge = 2;
    CGFloat starW = width - 2*marge;
    UIBezierPath *starPath = [[UIBezierPath alloc] init];
    //移到左边的中点
    for (int i = 0; i < 5; i++) {
        CGFloat startX = i*(starW+marge)+marge;
        CGFloat startY = width *17/40.0;
        [starPath moveToPoint:CGPointMake(startX, startY)];
        [starPath addLineToPoint:CGPointMake(startX + 1/3.0 *starW, 1/3.0 *starW)];
        [starPath addLineToPoint:CGPointMake(startX + 1/2.0 *starW, 0)];
        [starPath addLineToPoint:CGPointMake(startX + 2/3.0 *starW, 1/3.0 *starW)];
        [starPath addLineToPoint:CGPointMake(startX + starW, 17/40.0 * width)];
        [starPath addLineToPoint:CGPointMake(startX + 3/4.0 *starW, 26/40.0 *width )];
        [starPath addLineToPoint:CGPointMake(startX + 4/5.0 *starW, width)];
        [starPath addLineToPoint:CGPointMake(startX + 1/2.0 *starW, 33/40.0 *width)];
        [starPath addLineToPoint:CGPointMake(startX + 1/5.0 *starW, width)];
        [starPath addLineToPoint:CGPointMake(startX + 1/4.0 *starW, 26/40.0 *width )];
        [starPath addLineToPoint:CGPointMake(startX, startY)];
    }
    self.layer.backgroundColor = [UIColor redColor].CGColor;
    CAShapeLayer *starLayer = [CAShapeLayer layer];
    starLayer.frame = self.bounds;
    starLayer.fillColor = HMDColor(204, 204, 204, 1).CGColor;
    starLayer.strokeColor = HMDColor(204, 204, 204, 1).CGColor;
    starLayer.path = starLayer.path;
    self.layer.mask = starLayer;
    
}
@end
