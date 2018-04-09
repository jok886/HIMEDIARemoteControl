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
#import "HMDLinkView.h"

#import "HMDPersonCenterViewController.h"

#import "HMDDeviceLinkDao.h"
#import "HMDSearchDeviceViewController.h"
#import "HMDTVRemoteViewController.h"

@interface HMDMainViewController ()
<HMDScrollTitleViewDelegate,
HMDScrollContentViewDelegate,
HMDLinkViewDelegate>
@property (nonatomic,weak) HMDScrollTitleView *titleView;               //标题
@property (nonatomic,weak) HMDScrollContentView *contentView;           //内容
@property (nonatomic,strong) HMDLinkView *linkView;                       //内容
@property (nonatomic,strong) HMDDeviceLinkDao *linkDao;                 //链接设备
@property (nonatomic,assign) BOOL changeToKeyWindow;                 //链接设备
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;                                   //用户头像

@end

@implementation HMDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //是否第一次登陆,第一次需要初始化引导界面
    [self setupUI];
    [self getDLanLink];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.changeToKeyWindow) {
        self.changeToKeyWindow = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self.linkView];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -初始化
-(void)setupUI{
    [self setupContentViewController];
    [self setupTitleViewController];
    [self setupLinkView];
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

-(void)setupLinkView{
    self.linkView = [[HMDLinkView alloc]initWithFrame:CGRectMake(0, HMDScreenH-60, HMDScreenW, 60)];
    self.linkView.delegate = self;
    [self.view addSubview:self.linkView];
}

-(void)getDLanLink{
    NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:DLANLINKIP];
    if (ip.length >1) {
        HMDWeakSelf(self)
        [self.linkDao getDeviceInfo:ip finishBlock:^(BOOL success) {
            [weakSelf.linkView switchLinkState:success ip:ip];
//            [weakSelf switchLinkState:success ip:ip];
        }];
    }
}
#pragma mark -点击
//点击用户头像
- (IBAction)avatarBtnClick:(UIButton *)sender {
    //跳转个人中心
    HMDPersonCenterViewController *personCenterVC = [[HMDPersonCenterViewController alloc]init];
    HMDNavigationController *nav = [[HMDNavigationController alloc]initWithRootViewController:personCenterVC];

    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
}
//点击搜索按钮
- (IBAction)searchBtnClick:(UIButton *)sender {

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

-(void)LinkView:(HMDLinkView *)linkView linkBtnClick:(BOOL)link withViewController:(UIViewController *)viewController{
    if (link) {
        HMDWeakSelf(self)
        //进入遥控器
        HMDTVRemoteViewController *tvRemoteVC = [[HMDTVRemoteViewController alloc]init];
        tvRemoteVC.powerOffBlock = ^{
            [weakSelf.linkView switchLinkState:NO ip:nil];
        };
        HMDNavigationController *nav = [[HMDNavigationController alloc]initWithRootViewController:tvRemoteVC];
        [viewController presentViewController:nav animated:YES completion:nil];
    }else{
        //进入搜索设备
        HMDSearchDeviceViewController *searchVC = [[HMDSearchDeviceViewController alloc]init];
        HMDWeakSelf(self)
        HMDWeakObj(searchVC)
        searchVC.selectedFinishBlock = ^(NSString *ip) {
            
            [weakSelf.linkDao getDeviceInfo:ip finishBlock:^(BOOL success) {
                [weakSelf.linkView switchLinkState:success ip:ip];
                [weaksearchVC backAction:nil];
            }];
        } ;
        HMDNavigationController *nav = [[HMDNavigationController alloc]initWithRootViewController:searchVC];
        [viewController presentViewController:nav animated:YES completion:nil];
    }
}

-(void)LinkView:(HMDLinkView *)linkView linkOffBtnClickWithViewController:(UIViewController *)viewController{
    [self.linkView switchLinkState:NO ip:nil];
}

#pragma mark - 懒加载
-(HMDDeviceLinkDao *)linkDao{
    if (_linkDao == nil) {
        _linkDao = [[HMDDeviceLinkDao alloc] init];
    }
    return _linkDao;
}
@end
