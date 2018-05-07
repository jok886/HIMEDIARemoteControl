//
//  HMDPersonCenterViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/2.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDPersonCenterViewController.h"

#import "AppDelegate.h"

#import "HMDLoginDao.h"
#import "HMDAppListDao.h"

#import "UIImageView+HMDDLANLoadImage.h"
#import "WXApi.h"

#import "HMDQRCodeScanViewController.h"
#import "HMDApplistViewController.h"
#import "HMDRemoteSettingViewController.h"
@interface HMDPersonCenterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;

@property (assign, nonatomic) BOOL wxLogin;
@property (strong, nonatomic) HMDLoginDao *loginDao;
@property (strong, nonatomic) HMDAppListDao *appListDao;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLogin:) name:HMDWechatLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatSignout:) name:HMDWechatSignout object:nil];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLinkViewWillHide object:nil];
//    [HMDLinkView sharedInstance].hidden = YES;
    HMDApplistViewController *appListVC = [[HMDApplistViewController alloc] init];
    [self.navigationController pushViewController:appListVC animated:YES];
}
//系统设置
- (IBAction)systemSetting:(id)sender {
    HMDRemoteSettingViewController *settingVC = [[HMDRemoteSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

//截屏
- (IBAction)getCapture:(id)sender {
    [self.appListDao getCaptureFinishBlock:^(BOOL success, NSData *imageData) {
        if (success) {
            UIImage *image = [UIImage imageWithData:imageData];
            UIImageView *showImageView = [[UIImageView alloc] initWithImage:image];
            showImageView.layer.anchorPoint = CGPointMake(0.1, 0.9);
            showImageView.contentMode = UIViewContentModeScaleAspectFit;
            showImageView.frame = CGRectMake(0, 0, HMDScreenW, HMDScreenH);
            [[UIApplication sharedApplication].keyWindow addSubview:showImageView];
            [UIView animateWithDuration:1.5 animations:^{
                CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.4, 0.4);
                showImageView.transform = scaleTransform;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [showImageView removeFromSuperview];
                });
                
            }];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
    }];
}
//启动清理大师
- (IBAction)startHiTVAPK:(id)sender {

    [self.appListDao openDLanAppWithPackage:@"com.hitv.process" FinishBlock:^(BOOL success) {
        if (success) {

        }
    }];
}

#pragma mark - 其他
//更新UI
-(void)upUserInfoWithUserModel:(HMDUserModel *)userModel{

    [self.userIconImageView setImageWithURLStr:userModel.headimgurl placeholderImage:nil];
    self.userNameLab.text = userModel.nickname;
    self.signInBtn.hidden = YES;
    if (self.upUserInfoBlock) {
        self.upUserInfoBlock(userModel);
    }
}

//登出
-(void)wechatSignout:(NSNotification *)info{

    [self.userIconImageView setImage:[UIImage imageNamed:@"user_default"]];
    self.userNameLab.text = @"登录海美迪会员,用手机玩转盒子";
    self.signInBtn.hidden = NO;
}
#pragma mark - 懒加载
-(HMDLoginDao *)loginDao{
    if (_loginDao == nil) {
        _loginDao = [[HMDLoginDao alloc]init];
    }
    return _loginDao;
}

-(HMDAppListDao *)appListDao{
    if (_appListDao == nil) {
        _appListDao = [[HMDAppListDao alloc] init];
    }
    return _appListDao;
}
@end
