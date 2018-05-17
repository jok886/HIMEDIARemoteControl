//
//  HMDMainViewController.m
//  RemoteControl
//
//  Created by Lin on 2018/3/30.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDMainViewController.h"

#import "HMDScrollTitleView.h"
#import "HMDScrollContentView.h"
#import "HMDLinkView.h"
#import "HMDLoginView.h"

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
#import "HMDSroceStarView.h"
#import "UIImage+Color.h"
@interface HMDMainViewController ()
<HMDScrollTitleViewDelegate,
HMDScrollContentViewDelegate,
HMDLinkViewDelegate,
HMDDMRControlDelegate>
@property (nonatomic,weak) HMDScrollTitleView *titleView;                           //标题
@property (nonatomic,weak) HMDScrollContentView *contentView;                       //内容
//@property (nonatomic,weak) HMDLinkView *linkView;                                 //底部链接状态
@property (nonatomic,strong) HMDDeviceLinkDao *linkDao;                             //链接设备
@property (nonatomic,strong) HMDLoginDao *loginDao;                                 //登录
@property (nonatomic,assign) BOOL changeToKeyWindow;                                //第一次将linkview转到keywindow
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;                //用户头像

@property (nonatomic,strong) NSString *searchIP;                                    //要搜索的ip
@property (nonatomic,assign) BOOL autoLink;                                         //尝试自动重连
@property (nonatomic,weak) HMDSearchDeviceViewController *searchVC;                 //搜索设备界面
@end

@implementation HMDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //是否第一次登陆,第一次需要初始化引导界面
    [self setupUI];
    [self autoDLanLink];
    [self addNotificationCenter];
    //这里增加自动登录
    [self autoLogin];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.changeToKeyWindow) {
        self.changeToKeyWindow = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:[HMDLinkView sharedInstance]];
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
    CGFloat viewY = CGRectGetMaxY([[UIApplication sharedApplication] statusBarFrame])+5;
    titleView.frame = CGRectMake(60, viewY, HMDScreenW-120, 55);
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
    CGFloat viewY = 85;
    if (iPhoneX) {
        viewY = SafeAreaTop+65;
        viewH = HMDScreenH -(SafeAreaTop + SafeAreaBottom)-LINKVIEHIGHT-65;
    }
    contentView.frame = CGRectMake(0, viewY, viewW, viewH);
    contentView.delegate = self;
    [contentView setupUIWithchildViewController:childVCArray];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
}

-(void)setupLinkView{
    CGFloat y = HMDScreenH-LINKVIEHIGHT;
    if (iPhoneX) {
        y -= SafeAreaBottom;
    }
    HMDLinkView *linkView = [HMDLinkView sharedInstance];
    linkView.frame = CGRectMake(0, y, HMDScreenW, LINKVIEHIGHT);
    linkView.delegate = self;
    [linkView setupUI];
    [self.view addSubview:linkView];
}

-(void)autoDLanLink{
    //wifi环境才进行自动连接
    if ([HMDDLANNetTool sharedInstance].isWIFIEnvironmental) {
        NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:DLANLastTimeLinkDeviceUUID];
        [[[HMDDHRCenter sharedInstance] DMRControl] setDelegate:self];
        if (uuid.length >1) {
            self.autoLink = YES;
            //启动DMC去搜索设备
            if (![[[HMDDHRCenter sharedInstance] DMRControl] isRunning]) {
                [[[HMDDHRCenter sharedInstance] DMRControl] start];
            }
            [[HMDLinkView sharedInstance] switchLinkState:HMDLinkViewStateLinking ip:nil uuid:nil];
            //5s内找不到设备停止重连
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.autoLink) {
                    if ([[[HMDDHRCenter sharedInstance] DMRControl] getCurrentRender] == nil) {
                        [[[HMDDHRCenter sharedInstance] DMRControl] stop];
                        [[HMDLinkView sharedInstance] switchLinkState:HMDLinkViewStateunLink ip:nil uuid:nil];
                        [HMDProgressHub showMessage:@"未匹配到上次链接的设备" hideAfter:2.0];
                    }
                }
            });
        }
    }
}

-(void)addNotificationCenter{
    //登录通知

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLogin:) name:HMDWechatLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatSignout:) name:HMDWechatSignout object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewDeviceIP:) name:HMDNewDeviceIP object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatSignout:) name:HMDWechatSignout object:nil];
}

-(void)autoLogin{
//    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *loginModel = [[NSUserDefaults standardUserDefaults] objectForKey:HMDLoginModel];
    if ([loginModel isEqualToString:HMDLoginWXModel]) {
        //上次是微信登录的
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:HMDLoginRefreshToken];
        if (refreshToken){
            NSString *decryptRefreshToken = [EncryptionTools decryptAESWithHINAVI:refreshToken];
            if (![[NSUserDefaults standardUserDefaults] boolForKey:HMDLoginState] && decryptRefreshToken) {
                HMDWeakSelf(self)
                [self.loginDao getWechatInfoWithRefreshToken:decryptRefreshToken finishBlock:^(BOOL success, HMDUserModel *userModel) {
                    if (success) {
                        [weakSelf upUserInfoWithUserModel:userModel];
                    }
                }];
            }
        }
    }else if ([loginModel isEqualToString:HMDLoginPhoneModel]) {
        //上次是手机登录的
        NSDictionary *loginDict = [[NSUserDefaults standardUserDefaults] objectForKey:HMDLoginRefreshToken];
        NSString *userID = [loginDict objectForKey:@"userID"];
        NSString *encryptKey = [loginDict objectForKey:@"key"];
        NSString *key = [EncryptionTools decryptAESWithHINAVI:encryptKey];
    }


}

#pragma mark -点击
//点击用户头像
- (void)userIconClick:(UITapGestureRecognizer *)tapGesture {
    //跳转个人中心

    HMDPersonCenterViewController *personCenterVC = [[HMDPersonCenterViewController alloc]init];

    [self presentViewController:personCenterVC animated:YES completion:^{
        
    }];
    
}
//点击搜索按钮
- (IBAction)searchBtnClick:(UIButton *)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:HMDLoginState]) {
        HMDSearchTVViewController *searchVC = [[HMDSearchTVViewController alloc] init];
        HMDNavigationController *nav = [[HMDNavigationController alloc] initWithRootViewController:searchVC];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [HMDLinkView sharedInstance].hidden = YES;
        HMDLoginView *loginView = [HMDLoginView hmd_viewFromXib];
        loginView.frame = self.view.bounds;
        [self.view addSubview:loginView];
    }


}

#pragma mark - NSNotificationCenter

//更新链接状态
-(void)getNewDeviceIP:(NSNotification *)info{
    NSString *ip = info.object;
    self.searchIP = ip;
    dispatch_async(dispatch_get_main_queue(), ^{
        [HMDProgressHub showMessage:[NSString stringWithFormat:@"尝试链接:%@",ip] hideAfter:2.0];
        [[HMDLinkView sharedInstance] switchLinkState:HMDLinkViewStateLinking ip:nil uuid:nil];
    });

    [[[HMDDHRCenter sharedInstance] DMRControl] setDelegate:self];
    //启动DMC去搜索设备
    if (![[[HMDDHRCenter sharedInstance] DMRControl] isRunning]) {
        [[[HMDDHRCenter sharedInstance] DMRControl] start];
    }else{
        [[[HMDDHRCenter sharedInstance] DMRControl] restart];
    }

//尝试5s,链接不到就取消
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.searchIP) {
            [HMDProgressHub showMessage:@"无法链接设备" hideAfter:2.0];
            [[HMDLinkView sharedInstance] switchLinkState:HMDLinkViewStateunLink ip:nil uuid:nil];
        }
    });
    
}
//登出
-(void)wechatSignout:(NSNotification *)info{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HMDLoginState];
    [self.userIconImageView setImage:[UIImage imageNamed:@"user_default"]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WXCurHID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HMDLoginRefreshToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HMDLoginModel];
}
//登录
-(void)wechatLogin:(NSNotification *)info{
    if ([info.object isKindOfClass:[HMDUserModel class]]) {
        HMDUserModel *userModel = (HMDUserModel *)info.object;
        [self upUserInfoWithUserModel:userModel];
    }
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

-(void)LinkView:(HMDLinkView *)linkView linkBtnClick:(HMDLinkViewState)linkState withViewController:(UIViewController *)viewController{

    switch (linkState) {
        case HMDLinkViewStateunLink:
        {
            
            //先判断是否局域网状态
            if ([[HMDDLANNetTool sharedInstance] isWIFIEnvironmental]) {
                [HMDLinkView sharedInstance].hidden = YES;
                //停止自动搜索
                self.autoLink = NO;
                //进入搜索设备
                HMDSearchDeviceViewController *searchVC = [[HMDSearchDeviceViewController alloc]init];
                
                self.searchVC = searchVC;
                [viewController presentViewController:searchVC animated:YES completion:^{
 
                        //开启设备
                        if (![[[HMDDHRCenter sharedInstance] DMRControl] isRunning]) {
                            [[[HMDDHRCenter sharedInstance] DMRControl] setDelegate:self];
                            [[[HMDDHRCenter sharedInstance] DMRControl] start];
                        }else{
                            [[[HMDDHRCenter sharedInstance] DMRControl] restart];
                        }

                }];
            }else{
                [HMDProgressHub showMessage:@"请先链接wifi" hideAfter:2.0];
            }

        }
            break;
//        case HMDLinkViewStateLinking:
//        {
//            [self.linkView switchLinkState:HMDLinkViewStateunLink ip:nil];
//        }
//            break;
        default:
            break;
    }

    
}

-(void)LinkView:(HMDLinkView *)linkView remoteBtnClickWithViewController:(UIViewController *)viewController{
    [HMDLinkView sharedInstance].hidden = YES;
    //进入遥控器
    HMDTVRemoteViewController *tvRemoteVC = [[HMDTVRemoteViewController alloc]init];
    tvRemoteVC.showLinkViewWhenDismiss = YES;
    HMDNavigationController *nav = [[HMDNavigationController alloc]initWithRootViewController:tvRemoteVC];
    [viewController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - ZM_DMRProtocolDelegate
-(void)onDMRAdded
{
    if (self.searchIP) {
        NSArray *renders = [[NSArray alloc] initWithArray:[[[HMDDHRCenter sharedInstance] DMRControl] getActiveRenders]];
        for (HMDRenderDeviceModel *model in renders) {
            HMDRenderDeviceModel *deviceModel = [[[HMDDHRCenter sharedInstance] DMRControl] getRenderWithUUID:model.uuid];
            if ([self.searchIP isEqualToString:deviceModel.localIP]) {
                [[[HMDDHRCenter sharedInstance] DMRControl] chooseRenderWithUUID:model.uuid];
                HMDRenderDeviceModel *deviceModel = [[[HMDDHRCenter sharedInstance] DMRControl] getCurrentRender];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[HMDLinkView sharedInstance] switchLinkState:HMDLinkViewStateLinked ip:deviceModel.localIP uuid:model.uuid];
                    [HMDProgressHub showMessage:@"连接成功" hideAfter:2.0];
                });

                self.searchIP = nil;
            }
        }
    }else if (self.autoLink){
        if ([[[HMDDHRCenter sharedInstance] DMRControl] getCurrentRender] == nil) {
            NSString *lastUUID = [[NSUserDefaults standardUserDefaults] objectForKey:DLANLastTimeLinkDeviceUUID];
            NSArray *renders = [[NSArray alloc] initWithArray:[[[HMDDHRCenter sharedInstance] DMRControl] getActiveRenders]];
            for (HMDRenderDeviceModel *model in renders) {
                if ([lastUUID isEqualToString:model.uuid]) {
                    [[[HMDDHRCenter sharedInstance] DMRControl] chooseRenderWithUUID:model.uuid];
                    HMDRenderDeviceModel *deviceModel = [[[HMDDHRCenter sharedInstance] DMRControl] getCurrentRender];
                    self.autoLink = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[HMDLinkView sharedInstance] switchLinkState:HMDLinkViewStateLinked ip:deviceModel.localIP uuid:model.uuid];
                    });
                }
            }
        }
    }
    if (self.searchVC) {
        [self.searchVC reloadTableViewWithdeviceArray:[[NSArray alloc] initWithArray:[[[HMDDHRCenter sharedInstance] DMRControl] getActiveRenders]]];
    }
    NSLog(@"%s",__FUNCTION__);
}
-(void)onDMRRemoved{
    if (self.searchVC) {
        [self.searchVC reloadTableViewWithdeviceArray:[[NSArray alloc] initWithArray:[[[HMDDHRCenter sharedInstance] DMRControl] getActiveRenders]]];
    }
    NSLog(@"%s",__FUNCTION__);
}
#pragma mark - 其他
//更新UI
-(void)upUserInfoWithUserModel:(HMDUserModel *)userModel{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myDelegate.userModel = userModel;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HMDLoginState];
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
