//
//  HMDPersonCenterViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/2.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDPersonCenterViewController.h"

#import "HMDAppListDao.h"

#import "UIImageView+HMDDLANLoadImage.h"

#import "AppDelegate.h"

#import "HMDQRCodeScanViewController.h"
#import "HMDApplistViewController.h"
#import "HMDRemoteSettingViewController.h"
#import "HMDUserInfoCenterViewController.h"
#import "HMDScreenshotViewController.h"
#import "HMDLoginView.h"
#import "HMDDoubleTextBtn.h"
@interface HMDPersonCenterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;                   //登录按钮
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;        //用户头像
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;                  //用户名

@property (strong, nonatomic) HMDAppListDao *appListDao;                    //app数据列表

@property (weak, nonatomic) IBOutlet UIView *userMainView;                  //用户背景
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameTopConstraint;

@property (weak, nonatomic) IBOutlet HMDDoubleTextBtn *myAppBtn;

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
    //渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, HMDScreenW, 250);
    gradientLayer.colors = @[(id)HMDColorFromValue(0x3BC797).CGColor,(id)HMDColorFromValue(0x3BC7C5).CGColor];  // 设置渐变颜色
    gradientLayer.startPoint = CGPointMake(0.5, 0);   //
    gradientLayer.endPoint = CGPointMake(0.5, 1);     //
    [self.userMainView.layer insertSublayer:gradientLayer atIndex:0];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:HMDLoginState]) {
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HMDUserModel *userModel = myDelegate.userModel;
        [self upUserInfoWithUserModel:userModel];
        
    }
    
    //头像增加点击事件进入个人中心
    self.userIconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserInfoCenter:)];
    [self.userIconImageView addGestureRecognizer:tapGestureRecognizer];
}


#pragma mark - 通知
//登录通知
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:HMDLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signout:) name:HMDSignout object:nil];
}


#pragma mark -点击

//返回
-(IBAction)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//扫描
-(IBAction)searchQRCode{
    HMDQRCodeScanViewController *QRCodeVC = [[HMDQRCodeScanViewController alloc]init];
    HMDNavigationController *nav = [[HMDNavigationController alloc]initWithRootViewController:QRCodeVC];
    [self presentViewController:nav animated:YES completion:nil];
}

//登录
- (IBAction)singInBtnClick:(UIButton *)sender {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:HMDLoginState]) {
        [HMDLinkView sharedInstance].hidden = YES;
        HMDLoginView *loginView = [HMDLoginView hmd_viewFromXib];
        loginView.frame = self.view.bounds;
        [self.view addSubview:loginView];
    }

}

//我的应用
- (IBAction)myAPPListCenter:(UIButton *)sender {
    //判断当前是否链接
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        [HMDLinkView sharedInstance].hidden = YES;
        HMDApplistViewController *appListVC = [[HMDApplistViewController alloc] init];
        HMDNavigationController *nav = [[HMDNavigationController alloc]initWithRootViewController:appListVC];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [HMDProgressHub showMessage:@"请先链接设备" hideAfter:2.0];
    }

}
//系统设置
- (IBAction)systemSetting:(id)sender {
    HMDRemoteSettingViewController *settingVC = [[HMDRemoteSettingViewController alloc] init];
    settingVC.needSetNav = YES;
    HMDNavigationController *nav = [[HMDNavigationController alloc]initWithRootViewController:settingVC];
    [self presentViewController:nav animated:YES completion:nil];
}

//截屏
- (IBAction)getCapture:(id)sender {
    //判断当前是否链接
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        HMDScreenshotViewController *screenshotVC = [[HMDScreenshotViewController alloc] init];
        HMDNavigationController *nav = [[HMDNavigationController alloc] initWithRootViewController:screenshotVC];
        [self.view.getCurActiveViewController presentViewController:nav animated:YES completion:nil];
    }else{
        [HMDProgressHub showMessage:@"请先链接设备" hideAfter:2.0];
    }
//    [self.appListDao getCaptureFinishBlock:^(BOOL success, NSData *imageData) {
//        if (success) {
//            UIImage *image = [UIImage imageWithData:imageData];
//            UIImageView *showImageView = [[UIImageView alloc] initWithImage:image];
//            showImageView.layer.anchorPoint = CGPointMake(0.1, 0.9);
//            showImageView.contentMode = UIViewContentModeScaleAspectFit;
//            showImageView.frame = CGRectMake(0, 0, HMDScreenW, HMDScreenH);
//            [[UIApplication sharedApplication].keyWindow addSubview:showImageView];
//            [UIView animateWithDuration:1.5 animations:^{
//                CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.4, 0.4);
//                showImageView.transform = scaleTransform;
//            } completion:^(BOOL finished) {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [showImageView removeFromSuperview];
//                });
//
//            }];
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//        }
//    }];
}
//启动清理大师
- (IBAction)startHiTVAPK:(id)sender {

    //判断当前是否链接
    if ([HMDLinkView sharedInstance].linkViewState == HMDLinkViewStateLinked) {
        [self.appListDao openDLanAppWithPackage:@"com.hitv.process" FinishBlock:^(BOOL success) {
            if (success) {
                
            }
        }];
    }else{
        [HMDProgressHub showMessage:@"请先链接设备" hideAfter:2.0];
    }
}

-(void)gotoUserInfoCenter:(UITapGestureRecognizer *)tap{
    NSString *loginModel = [[NSUserDefaults standardUserDefaults] objectForKey:HMDLoginModel];
    if ([loginModel isEqualToString:HMDLoginPhoneModel]) {
        [HMDLinkView sharedInstance].hidden = YES;
        HMDUserInfoCenterViewController *userInfoCenter = [[UIStoryboard storyboardWithName:@"HMDUserInfoCenterViewController" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        
        HMDNavigationController *nav = [[HMDNavigationController alloc]initWithRootViewController:userInfoCenter];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [HMDProgressHub showMessage:@"第三方登录不支持个人信息修改" hideAfter:2.0];
    }

}
#pragma mark - 其他
//更新UI
-(void)upUserInfoWithUserModel:(HMDUserModel *)userModel{
    NSLog(@"%s",__FUNCTION__);
    [self.userIconImageView setImageWithURLStr:userModel.headimgurl placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.userNameLab.font = [UIFont systemFontOfSize:17];
    self.userNameLab.text = userModel.nickname;
        self.userNameTopConstraint.constant = 17;
    self.signInBtn.hidden = YES;

}
//登录
-(void)login:(NSNotification *)info{
    if ([info.object isKindOfClass:[HMDUserModel class]]) {
        HMDUserModel *userModel = (HMDUserModel *)info.object;
        [self upUserInfoWithUserModel:userModel];
    }
}
//登出
-(void)signout:(NSNotification *)info{

    [self.userIconImageView setImage:[UIImage imageNamed:@"default_avatar"]];
    self.userNameLab.text = @"登录海美迪会员,用手机玩转盒子";
    self.userNameLab.font = [UIFont systemFontOfSize:15];
    self.userNameTopConstraint.constant = 13;
    self.signInBtn.hidden = NO;
}
#pragma mark - 懒加载

-(HMDAppListDao *)appListDao{
    if (_appListDao == nil) {
        _appListDao = [[HMDAppListDao alloc] init];
    }
    return _appListDao;
}
@end
