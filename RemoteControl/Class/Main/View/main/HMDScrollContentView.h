//
//  HMDScrollContentView.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/3.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseView.h"
@protocol  HMDScrollContentViewDelegate<NSObject>

@optional
- (void)scrollContentViewDidEndDecelerating:(UIScrollView *)scrollView atIndex:(NSInteger)index;
@end

@interface HMDScrollContentView : HMDBaseView

@property (nonatomic,weak) id<HMDScrollContentViewDelegate> delegate;     //滚动代理

-(void)setupUIWithchildViewController:(NSArray *)childVCArray;
-(void)showViewAtIndex:(NSInteger)index;
@end
