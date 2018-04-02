//
//  HMDScrollContentViewController.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/2.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseViewController.h"
@protocol  HMDScrollContentViewControllerDelegate<NSObject>

@optional
- (void)scrollContentViewDidEndDecelerating:(UIScrollView *)scrollView atIndex:(NSInteger)index;
@end
@interface HMDScrollContentViewController : HMDBaseViewController
@property (nonatomic,strong) NSMutableArray *childVCArray;                          //子栏目
@property (nonatomic,assign) CGRect viewFrame;                                      //尺寸
@property (nonatomic,weak) id<HMDScrollContentViewControllerDelegate> delegate;     //滚动代理

-(void)showViewAtIndex:(NSInteger)index;
@end
