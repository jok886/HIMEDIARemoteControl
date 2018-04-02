//
//  HMDMainViewController.m
//  RemoteControl
//
//  Created by Lin on 2018/3/30.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDMainViewController.h"
#import "HMDScrollTitleViewController.h"
#import "HMDScrollContentViewController.h"
@interface HMDMainViewController ()
<HMDScrollTitleViewControllerDelegate,HMDScrollContentViewControllerDelegate>
@property (nonatomic,weak) HMDScrollTitleViewController *titleViewController;             //标题
@property (nonatomic,weak) HMDScrollContentViewController *contentViewController;         //内容
@end

@implementation HMDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //是否第一次登陆,第一次需要初始化引导界面
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -初始化
-(void)setupUI{
    [self setupContentViewController];
    [self setupTitleViewController];
}

//标题
-(void)setupTitleViewController{
    HMDScrollTitleViewController *titleVC = [[HMDScrollTitleViewController alloc]init];

    titleVC.titleArray = [NSMutableArray arrayWithObjects:@"宝箱",
                          @"视频",
                          @"音乐",
                          nil];
    titleVC.delegate = self;
    
    titleVC.viewFrame = CGRectMake(60, 45, HMDScreenW-120, 30);
    [self.view addSubview:titleVC.view];
    self.titleViewController = titleVC;
    [self addChildViewController:titleVC];
}
//内容
-(void)setupContentViewController{
    HMDScrollContentViewController *contentVC = [[HMDScrollContentViewController alloc]init];

    for (int i = 0; i<3; i++) {
        UIViewController *childVC = [[UIViewController alloc]init];
        childVC.view.backgroundColor = HMDRandomColor;
        [contentVC.childVCArray addObject:childVC];
    }
    CGFloat viewW = HMDScreenW;
    CGFloat viewH = HMDScreenH - 85-45;
    contentVC.viewFrame = CGRectMake(0, 85, viewW, viewH);
    contentVC.delegate = self;
    [self.view addSubview:contentVC.view];
    self.contentViewController = contentVC;
    [self addChildViewController:contentVC];
}

#pragma mark -代理
//对应的标题被点击
-(void)scrollViewDidSelectItemAtIndex:(NSInteger)index{
    [self.contentViewController showViewAtIndex:index];
}
//滚动
-(void)scrollContentViewDidEndDecelerating:(UIScrollView *)scrollView atIndex:(NSInteger)index{
    [self.titleViewController btnClickAtIndex:index];
}
@end
