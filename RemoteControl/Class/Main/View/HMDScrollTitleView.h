//
//  HMDScrollTitleView.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/3.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseView.h"
@protocol  HMDScrollTitleViewDelegate<NSObject>

@optional
- (void)scrollViewDidSelectItemAtIndex:(NSInteger)index;
@end
@interface HMDScrollTitleView : HMDBaseView

//宽高不设置的话自动调整
@property (nonatomic,assign) BOOL autoLayoutBtn;                                //自动布局:默认YES
@property (nonatomic,assign) CGFloat btnW;                                      //按钮的宽:默认100
@property (nonatomic,assign) CGFloat btnH;                                      //按钮的高:默认35
@property (nonatomic,copy) UIColor *selectColor;                                //选中的颜色

@property (nonatomic,weak) id<HMDScrollTitleViewDelegate> delegate;   //点击代理

//界面初始化
-(void)setupUIWithTitleArray:(NSArray *)titleArray;
-(void)btnClickAtIndex:(NSInteger)index;
@end
