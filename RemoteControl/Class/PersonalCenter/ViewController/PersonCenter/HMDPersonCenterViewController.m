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
    
    //设置按钮
//    [self.myAppBtn setButtonWithImage:[UIImage imageNamed:@"mine_application"] mainTitle:@"我的应用" subtitle:@"精彩内容绘制"];
}


#pragma mark - 通知
//登录通知
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLogin:) name:HMDWechatLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatSignout:) name:HMDWechatSignout object:nil];
}

-(void)wechatLogin:(NSNotification *)info{
    if ([info.object isKindOfClass:[HMDUserModel class]]) {
        HMDUserModel *userModel = (HMDUserModel *)info.object;
        [self upUserInfoWithUserModel:userModel];
    }
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
  
}

//我的应用
- (IBAction)myAPPListCenter:(UIButton *)sender {
//    sender.selected = YES;
//    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLinkViewWillHide object:nil];
    [HMDLinkView sharedInstance].hidden = YES;
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
    self.userNameLab.font = [UIFont systemFontOfSize:17];
    self.userNameLab.text = userModel.nickname;
        self.userNameTopConstraint.constant = 17;
    self.signInBtn.hidden = YES;

}

//登出
-(void)wechatSignout:(NSNotification *)info{

    [self.userIconImageView setImage:[UIImage imageNamed:@"user_default"]];
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
