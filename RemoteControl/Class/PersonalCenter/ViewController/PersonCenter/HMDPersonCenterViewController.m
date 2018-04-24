//
//  HMDPersonCenterViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/2.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDPersonCenterViewController.h"
#import "HMDQRCodeScanViewController.h"
#import "WXApi.h"
#import "HMDLoginDao.h"
#import "UIImageView+HMDDLANLoadImage.h"
#import "AppDelegate.h"

#import "HMDApplistViewController.h"
@interface HMDPersonCenterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;

@property (assign, nonatomic) BOOL wxLogin;
@property (strong, nonatomic) HMDLoginDao *loginDao;

@end

@implementation HMDPersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    [self setupNavigation];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (myDelegate.isLogin) {
        HMDUserModel *userModel = myDelegate.userModel;
        [self.userIconImageView setImageWithURLStr:userModel.headimgurl placeholderImage:nil];
        self.userNameLab.text = userModel.nickname;
        self.signInBtn.hidden = YES;
    }else{
        //判断是否安装了微信
        if ([WXApi isWXAppInstalled]) {
            self.wxLogin = YES;
            [self.signInBtn setTitle:@"  微信登录" forState:UIControlStateNormal];
        }else{
            self.wxLogin = NO;
            [self.signInBtn setTitle:@"  手机登录" forState:UIControlStateNormal];
        }
    }


}

-(void)setupNavigation{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_back_wbg"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_back_wbg"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //扫描按钮
    UIButton *searchQRButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchQRButton setImage:[UIImage imageNamed:@"search-gray"] forState:UIControlStateNormal];
    [searchQRButton setImage:[UIImage imageNamed:@"search-gray"] forState:UIControlStateHighlighted];
    [searchQRButton addTarget:self action:@selector(searchQRCode) forControlEvents:UIControlEventTouchUpInside];
    [searchQRButton sizeToFit];

    // 设置返回按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchQRButton];
}

#pragma mark - 通知
//登录通知
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLogin:) name:HMDWECHATLOGIN object:nil];
}

-(void)wechatLogin:(NSNotification *)info{
    if ([info.object isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)info.object;
        if (authResp.errCode == 0) {
            NSLog(@"登录成功");
            NSString *code = authResp.code;
            HMDWeakSelf(self)
            [self.loginDao getWechatInfoWithCode:code finishBlock:^(BOOL success, HMDUserModel *userModel) {
                if (success) {
                    [weakSelf upUserInfoWithUserModel:userModel];
                }
            }];
        }else{
            NSLog(@"登录失败");
        }
    }
}
#pragma mark -点击

//返回
-(void)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//扫描
-(void)searchQRCode{
    HMDQRCodeScanViewController *QRCodeVC = [[HMDQRCodeScanViewController alloc]init];
    [self.navigationController pushViewController:QRCodeVC animated:YES];
//    [self presentViewController:QRCodeVC animated:YES completion:nil];
    
}

//登录
- (IBAction)singInBtnClick:(UIButton *)sender {
    if (self.wxLogin) {
        SendAuthReq *req = [[SendAuthReq alloc]init];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"wx_oauth2_authorization_state" ;
        [WXApi sendReq:req];
    }
}

//我的应用
- (IBAction)myAPPListCenter:(id)sender {
    HMDApplistViewController *appListVC = [[HMDApplistViewController alloc] init];
    [self.navigationController pushViewController:appListVC animated:YES];
}

#pragma mark - 其他
//更新UI
-(void)upUserInfoWithUserModel:(HMDUserModel *)userModel{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myDelegate.userModel = userModel;
    myDelegate.loginState = YES;
    [self.userIconImageView setImageWithURLStr:userModel.headimgurl placeholderImage:nil];
    self.userNameLab.text = userModel.nickname;
    self.signInBtn.hidden = YES;
}
#pragma mark - 懒加载
-(HMDLoginDao *)loginDao{
    if (_loginDao == nil) {
        _loginDao = [[HMDLoginDao alloc]init];
    }
    return _loginDao;
}
@end
