//
//  HMDScrollTitleViewController.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/2.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//  滚动的标题

#import "HMDBaseViewController.h"

@protocol  HMDScrollTitleViewControllerDelegate<NSObject>

@optional
- (void)scrollViewDidSelectItemAtIndex:(NSInteger)index;
@end
@interface HMDScrollTitleViewController : HMDBaseViewController
@property (nonatomic,strong) NSMutableArray *titleArray;                        //标题栏
@property (nonatomic,assign) CGRect viewFrame;                                  //尺寸
//宽高不设置的话自动调整
@property (nonatomic,assign) BOOL autoLayoutBtn;                                //自动布局:默认YES
@property (nonatomic,assign) CGFloat btnW;                                      //按钮的宽:默认100
@property (nonatomic,assign) CGFloat btnH;                                      //按钮的高:默认35
@property (nonatomic,copy) UIColor *selectColor;                                //选中的颜色

@property (nonatomic,weak) id<HMDScrollTitleViewControllerDelegate> delegate;   //点击代理

//界面初始化
-(void)setupUIWithTitleArray:(NSArray *)titleArray;
-(void)btnClickAtIndex:(NSInteger)index;
@end
