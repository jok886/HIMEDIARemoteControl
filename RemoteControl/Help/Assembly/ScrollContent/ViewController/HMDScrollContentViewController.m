//
//  HMDScrollContentViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/2.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDScrollContentViewController.h"

@interface HMDScrollContentViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *contentScrollView;               //标题背景
@end

@implementation HMDScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConst];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.frame = self.viewFrame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -初始化
//基本参数
-(void)setupConst{
    self.view.frame = self.viewFrame;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
//UI
-(void)setupUI{
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    
    contentScrollView.frame = self.view.bounds;
    
    [self.view addSubview:contentScrollView];
    
    self.contentScrollView = contentScrollView;
    
    // 设置代理
    contentScrollView.delegate = self;
    self.contentScrollView.contentSize = CGSizeMake(self.childVCArray.count * self.view.bounds.size.width, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.bounces = NO;
}

#pragma mark -内部逻辑
-(void)setupChildViewControllerAtIndex:(NSInteger)index{
    UIViewController *childVC = self.childVCArray[index];
    
    // 判断下有没有父控件
    if (childVC.view.superview) return;
    CGFloat viewW = CGRectGetWidth(self.view.frame);
    CGFloat viewH = CGRectGetHeight(self.view.frame);
    CGFloat x = index * viewW;
    // 设置vc的view的位置
    childVC.view.frame = CGRectMake(x, 0, viewW,viewH);
    [self.contentScrollView addSubview:childVC.view];
}
#pragma mark -UIScrollViewDelegate
// 监听scrollView滚动完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    // 获取角标
    CGFloat viewW = CGRectGetWidth(self.view.frame);
    NSInteger i = scrollView.contentOffset.x / viewW;
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollContentViewDidEndDecelerating:atIndex:)]) {
        [self.delegate scrollContentViewDidEndDecelerating:scrollView atIndex:i];
    }
    // 2.把对应子控制器的view添加上去
    [self setupChildViewControllerAtIndex:i];
}

#pragma mark -API
-(void)showViewAtIndex:(NSInteger)index{
    [self setupChildViewControllerAtIndex:index];
    // 让scrollView滚动对应位置
    CGFloat x = index * self.viewFrame.size.width;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
}
#pragma mark -懒加载
-(NSMutableArray *)childVCArray{
    if (_childVCArray == nil) {
        _childVCArray = [NSMutableArray array];
    }
    return _childVCArray;
}
@end
