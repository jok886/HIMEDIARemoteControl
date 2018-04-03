//
//  HMDMainViewController.m
//  RemoteControl
//
//  Created by Lin on 2018/3/30.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDMainViewController.h"
#import "HMDNavigationController.h"

#import "HMDScrollTitleView.h"
#import "HMDScrollContentView.h"

#import "HMDPersonCenterViewController.h"
@interface HMDMainViewController ()
<HMDScrollTitleViewDelegate,
HMDScrollContentViewDelegate>
@property (nonatomic,weak) HMDScrollTitleView *titleView;               //标题
@property (nonatomic,weak) HMDScrollContentView *contentView;           //内容
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;                                   //用户头像
@property (weak, nonatomic) IBOutlet UIImageView *linkStateImageView;                       //链接状态
@property (weak, nonatomic) IBOutlet UILabel *linkStateLabel;                               //状态文字
@property (weak, nonatomic) IBOutlet UIButton *linkBtn;                                     //链接按钮

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
    HMDScrollTitleView *titleView = [[HMDScrollTitleView alloc]init];

    NSMutableArray *titleArray = [NSMutableArray arrayWithObjects:@"宝箱",
                          @"视频",
                          @"音乐",
                          nil];
    titleView.delegate = self;
    
    titleView.frame = CGRectMake(60, 45, HMDScreenW-120, 30);
    [titleView setupUIWithTitleArray:titleArray];
    [self.view addSubview:titleView];
    self.titleView = titleView;

}
//内容
-(void)setupContentViewController{
    HMDScrollContentView *contentView = [[HMDScrollContentView alloc]init];
    NSMutableArray *childVCArray = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        UIViewController *childVC = [[UIViewController alloc]init];
        childVC.view.backgroundColor = HMDRandomColor;
        [childVCArray addObject:childVC];
    }
    CGFloat viewW = HMDScreenW;
    CGFloat viewH = HMDScreenH - 85-45;
    contentView.frame = CGRectMake(0, 85, viewW, viewH);
    contentView.delegate = self;
    [contentView setupUIWithchildViewController:childVCArray];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
}
#pragma mark -点击
//点击用户头像
- (IBAction)avatarBtnClick:(UIButton *)sender {
    //跳转个人中心
    HMDPersonCenterViewController *personCenterVC = [[HMDPersonCenterViewController alloc]init];
//    HMDNavigationController *nav = [[HMDNavigationController alloc]initWithRootViewController:personCenterVC];
    [self presentViewController:personCenterVC animated:YES completion:^{
        
    }];
    
}
//点击搜索按钮
- (IBAction)searchBtnClick:(UIButton *)sender {
    
}
//点击链接
- (IBAction)linkBtnClick:(UIButton *)sender {
    
}
#pragma mark -其他
-(void)switchLinkState:(BOOL)link{
    NSString *imageName = @"link-off";
    NSString *linkText = @"设备未链接";
    if (link) {
        imageName = @"link-on";
        linkText = @"设备已链接";
        
    }
    [self.linkStateImageView setImage:[UIImage imageNamed:imageName]];
    self.linkStateLabel.text = linkText;
}
#pragma mark -代理
//对应的标题被点击
-(void)scrollViewDidSelectItemAtIndex:(NSInteger)index{
    [self.contentView showViewAtIndex:index];
}
//滚动
-(void)scrollContentViewDidEndDecelerating:(UIScrollView *)scrollView atIndex:(NSInteger)index{
    [self.titleView btnClickAtIndex:index];
}
@end
