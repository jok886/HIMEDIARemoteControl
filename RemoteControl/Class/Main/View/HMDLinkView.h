//
//  HMDLinkView.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/9.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseView.h"
@class HMDLinkView;
@protocol  HMDLinkViewDelegate<NSObject>

@optional
-(void)LinkView:(HMDLinkView *)linkView linkBtnClick:(BOOL)link withViewController:(UIViewController *)viewController;
-(void)LinkView:(HMDLinkView *)linkView linkOffBtnClickWithViewController:(UIViewController *)viewController;
@end
@interface HMDLinkView : HMDBaseView
@property (nonatomic,weak) id<HMDLinkViewDelegate> delegate;     //滚动代理
-(void)switchLinkState:(BOOL)link ip:(NSString *)ip;
@end
