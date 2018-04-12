//
//  HMDScrollContentView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/3.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDScrollContentView.h"
#import "HMDBaseViewController.h"
@interface HMDScrollContentView()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *contentScrollView;                 //标题背景
@property (nonatomic,strong) NSArray *childVCArray;                         //子栏目
@end

@implementation HMDScrollContentView

#pragma mark -初始化

//UI
-(void)setupUI{
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    
    contentScrollView.frame = self.bounds;
    
    [self addSubview:contentScrollView];
    
    self.contentScrollView = contentScrollView;
    
    // 设置代理
    contentScrollView.delegate = self;
    self.contentScrollView.contentSize = CGSizeMake(self.childVCArray.count * self.bounds.size.width, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.bounces = NO;
}

#pragma mark -内部逻辑
-(void)setupChildViewControllerAtIndex:(NSInteger)index{
    UIViewController *childVC = self.childVCArray[index];
    
    // 判断下有没有父控件
    if (childVC.view.superview) return;
    CGFloat viewW = CGRectGetWidth(self.frame);
    CGFloat viewH = CGRectGetHeight(self.frame);
    CGFloat x = index * viewW;
    // 设置vc的view的位置
    CGRect frame = CGRectMake(x, 0, viewW,viewH);
    childVC.view.frame = frame;
    if ([childVC isKindOfClass:[HMDBaseViewController class]]) {
        HMDBaseViewController *baseChildVC =(HMDBaseViewController *)childVC;
        baseChildVC.viewControllerFrame = frame;
    }
    [self.contentScrollView addSubview:childVC.view];
}
#pragma mark -UIScrollViewDelegate
// 监听scrollView滚动完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    // 获取角标
    CGFloat viewW = CGRectGetWidth(self.frame);
    NSInteger i = scrollView.contentOffset.x / viewW;
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollContentViewDidEndDecelerating:atIndex:)]) {
        [self.delegate scrollContentViewDidEndDecelerating:scrollView atIndex:i];
    }
    // 2.把对应子控制器的view添加上去
    [self setupChildViewControllerAtIndex:i];
}

#pragma mark -API
-(void)setupUIWithchildViewController:(NSArray *)childVCArray{
    self.childVCArray = [NSArray arrayWithArray:childVCArray];
    [self setupUI];
}
-(void)showViewAtIndex:(NSInteger)index{
    [self setupChildViewControllerAtIndex:index];
    // 让scrollView滚动对应位置
    CGFloat x = index * self.frame.size.width;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
}

@end
