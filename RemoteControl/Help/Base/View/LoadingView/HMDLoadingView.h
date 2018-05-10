//
//  HMDLoadingView.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/7.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//  加载动画

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    HMDLoadingViewResultTypeSuccess,
    HMDLoadingViewResultTypeError,
    HMDLoadingViewResultTypeExclamationMark,
} HMDLoadingViewResultType;

@interface HMDLoadingView : UIView
@property(nonatomic, strong) UIColor *loadingColor;                 //加载颜色
@property(nonatomic, strong) UIColor *successColor;                 //成功颜色
@property(nonatomic, strong) UIColor *exclamationColor;             //提示颜色
@property(nonatomic, strong) UIColor *errorColor;                   //错误颜色

@property(nonatomic, assign) CGFloat lineWidth;                     //线宽
@property(nonatomic, assign) CGFloat radius;                        //半径

@property(nonatomic) CGPoint loadingViewCenter;                      //加载中心位置

- (void) start;
- (void) startWithNoti:(NSString *)noti;
- (void)endAnimationWithResult:(HMDLoadingViewResultType )result;

@end
