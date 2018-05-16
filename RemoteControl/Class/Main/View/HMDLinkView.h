//
//  HMDLinkView.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/9.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseView.h"
@class HMDLinkView;

typedef enum : NSUInteger {
    HMDLinkViewStateLinking,            //连接中
    HMDLinkViewStateLinked,             //已连接
    HMDLinkViewStateunLink,             //未链接
} HMDLinkViewState;

@protocol  HMDLinkViewDelegate<NSObject>

@optional
-(void)LinkView:(HMDLinkView *)linkView linkBtnClick:(HMDLinkViewState)linkState withViewController:(UIViewController *)viewController;
-(void)LinkView:(HMDLinkView *)linkView remoteBtnClickWithViewController:(UIViewController *)viewController;
@end
@interface HMDLinkView : HMDBaseView
@property (assign, nonatomic) HMDLinkViewState linkViewState;
@property (nonatomic,weak) id<HMDLinkViewDelegate> delegate;     //滚动代理

+(HMDLinkView *)sharedInstance;
-(void)setupUI;
-(void)switchLinkState:(HMDLinkViewState)linkState ip:(NSString *)ip uuid:(NSString *)uuid;
@end
