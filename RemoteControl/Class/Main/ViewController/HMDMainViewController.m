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
#import "HMDSearchTVViewController.h"
#import "HMDSearchDeviceViewController.h"
#import "HMDTVRemoteViewController.h"
#import "HMDMainVideoViewController.h"

#import "HMDTreasureChestViewController.h"

#import "HMDDeviceLinkDao.h"
#import "HMDLoginDao.h"
#import "AppDelegate.h"
#import "UIImageView+HMDDLANLoadImage.h"
#import "EncryptionTools.h"
@interface HMDMainViewController ()
<HMDScrollTitleViewDelegate,
HMDScrollContentViewDelegate,
HMDLinkViewDelegate>
@property (nonatomic,weak) HMDScrollTitleView *titleView;               //标题
@property (nonatomic,weak) HMDScrollContentView *contentView;           //内容
@property (nonatomic,strong) HMDLinkView *linkView;                     //内容
@property (nonatomic,strong) HMDDeviceLinkDao *linkDao;                 //链接设备
@property (nonatomic,strong) HMDLoginDao *loginDao;                     //登录
@property (nonatomic,assign) BOOL changeToKeyWindow;                    //链接设备
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;               //用户头像

@end

@implementation HMDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //是否第一次登陆,第一次需要初始化引导界面
    [self setupUI];
    [self getDLanLink:[[NSUserDefaults standardUserDefaults] objectForKey:DLANLastTimeLinkIP]];
    [self addNotificationCenter];
    //这里增加自动登录
    [self autoLogin];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.changeToKeyWindow) {
        self.changeToKeyWindow = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self.linkView];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userIconClick:)];
    [self.userIconImageView addGestureRecognizer:tapGesture];
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
        switch (i) {
            case 0:
                {
                    HMDTreasureChestViewController *childVC = [[HMDTreasureChestViewController alloc]init];
                    [childVCArray addObject:childVC];
                }
                break;
            case 1:
            {
                HMDMainVideoViewController *childVC = [[HMDMainVideoViewController alloc]init];
                [childVCArray addObject:childVC];
            }
                break;
                
            default:
            {
                UIViewController *childVC = [[UIViewController alloc]init];
                [childVCArray addObject:childVC];
            }
                break;
        }

    }
    CGFloat viewW = HMDScreenW;
    CGFloat viewH = HMDScreenH - 85-LINKVIEHIGHT;
    contentView.frame = CGRectMake(0, 85, viewW, viewH);
    contentView.delegate = self;
    [contentView setupUIWithchildViewController:childVCArray];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
}

-(void)setupLinkView{
    self.linkView = [[HMDLinkView alloc]initWithFrame:CGRectMake(0, HMDScreenH-LINKVIEHIGHT, HMDScreenW, LINKVIEHIGHT)];
    self.linkView.delegate = self;
    [self.view addSubview:self.linkView];
}

-(void)getDLanLink:(NSString *)ip{
    if (ip.length >1) {
        HMDWeakSelf(self)
        [self.linkDao getDeviceInfo:ip finishBlock:^(BOOL success) {
            [weakSelf.linkView switchLinkState:success ip:ip];
        }];
    }
}

-(void)addNotificationCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkViewWillShow) name:HMDLinkViewWillShow object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkViewWillHide) name:HMDLinkViewWillHide object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewDeviceIP:) name:HMDNewDeviceIP object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatSignout:) name:HMDWechatSignout object:nil];
}

-(void)autoLogin{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:WXLoginRefreshToken];
    if (refreshToken){
        NSString *decryptRefreshToken = [EncryptionTools decryptAESWithHINAVI:refreshToken];
        if (!myDelegate.loginState && decryptRefreshToken) {
            HMDWeakSelf(self)
            [self.loginDao getWechatInfoWithRefreshToken:decryptRefreshToken finishBlock:^(BOOL success, HMDUserModel *userModel) {
                if (success) {
                    [weakSelf upUserInfoWithUserModel:userModel];
                }
            }];
        }
    }

}
#pragma mark -点击
//点击用户头像
- (void)userIconClick:(UITapGestureRecognizer *)tapGesture {
    //跳转个人中心
    HMDWeakSelf(self)
    HMDPersonCenterViewController *personCenterVC = [[HMDPersonCenterViewController alloc]init];
    personCenterVC.upUserInfoBlock = ^(HMDUserModel *userModel) {
        [weakSelf upUserInfoWithUserModel:userModel];
    };
    HMDNavigationController *nav = [[HMDNavigationController alloc]initWithRootViewController:personCenterVC];

    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
}
//点击搜索按钮
- (IBAction)searchBtnClick:(UIButton *)sender {
    HMDSearchTVViewController *searchTVVC = [[HMDSearchTVViewController alloc]init];
    HMDNavigationController *nav = [[HMDNavigationController alloc]initWithRootViewController:searchTVVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - NSNotificationCenter
//显示链接状态
-(void)linkViewWillShow{
    self.linkView.hidden = NO;
}
//隐藏链接状态
-(void)linkViewWillHide{
    self.linkView.hidden = YES;
}
//更新链接状态
-(void)getNewDeviceIP:(NSNotification *)info{
    NSString *ip = info.object;
    [self getDLanLink:ip];
    
}
//登出
-(void)wechatSignout:(NSNotification *)info{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myDelegate.userModel = nil;
    myDelegate.loginState = NO;
    [self.userIconImageView setImage:[UIImage imageNamed:@"user_default"]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WXCurHID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WXLoginRefreshToken];
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
    self.linkView.hidden = YES;
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
#pragma mark - 其他
//更新UI
-(void)upUserInfoWithUserModel:(HMDUserModel *)userModel{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myDelegate.userModel = userModel;
    myDelegate.loginState = YES;
    [self.userIconImageView setImageWithURLStr:userModel.headimgurl placeholderImage:nil];

}
#pragma mark - 懒加载
-(HMDDeviceLinkDao *)linkDao{
    if (_linkDao == nil) {
        _linkDao = [[HMDDeviceLinkDao alloc] init];
    }
    return _linkDao;
}
-(HMDLoginDao *)loginDao{
    if (_loginDao == nil) {
        _loginDao = [[HMDLoginDao alloc] init];
    }
    return _loginDao;
}
@end
