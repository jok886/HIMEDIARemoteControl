//
//  HMDTVRemoteViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/3.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTVRemoteViewController.h"
#import "KeyCodeMacro.h"
#import "HMDTVRemoteDao.h"
@interface HMDTVRemoteViewController ()
@property (nonatomic,strong) HMDTVRemoteDao *remoteDao;
@end

@implementation HMDTVRemoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 初始化
-(void)setupUI{
    [self setupNavigation];
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
//    //扫描按钮
//    UIButton *searchQRButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [searchQRButton setImage:[UIImage imageNamed:@"search-gray"] forState:UIControlStateNormal];
//    [searchQRButton setImage:[UIImage imageNamed:@"search-gray"] forState:UIControlStateHighlighted];
//    [searchQRButton addTarget:self action:@selector(searchQRCode) forControlEvents:UIControlEventTouchUpInside];
//    [searchQRButton sizeToFit];
//    
//    // 设置返回按钮
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchQRButton];
}

#pragma mark -点击
//电源
- (IBAction)TVPowerBtnClick:(UIButton *)sender {
    HMDWeakObj(self)
    [self.remoteDao remoteTVWithKey:KEYCODE_POWER finishBlock:^(BOOL success) {
        if (weakself.powerOffBlock) {
            weakself.powerOffBlock();
        }
        [weakself backAction:nil];
    }];
    
}
//首页
- (IBAction)TVHomeBtnClick:(UIButton *)sender {
    [self.remoteDao remoteTVWithKey:KEYCODE_HOME finishBlock:nil];
}
//上
- (IBAction)TVUPBtnClick:(UIButton *)sender {
    [self.remoteDao remoteTVWithKey:KEYCODE_DPAD_UP finishBlock:nil];
}
//下
- (IBAction)TVDownBtnClick:(UIButton *)sender {
    [self.remoteDao remoteTVWithKey:KEYCODE_DPAD_DOWN finishBlock:nil];
}
//左
- (IBAction)TVLeftBtnClick:(UIButton *)sender {
    [self.remoteDao remoteTVWithKey:KEYCODE_DPAD_LEFT finishBlock:nil];
}
//右
- (IBAction)TVRightBtnClick:(UIButton *)sender {
    [self.remoteDao remoteTVWithKey:KEYCODE_DPAD_RIGHT finishBlock:nil];
}
//OK
- (IBAction)TVOKBtnClick:(UIButton *)sender {
    [self.remoteDao remoteTVWithKey:KEYCODE_DPAD_CENTER finishBlock:nil];
}
//菜单
- (IBAction)TVMenuBtnClick:(UIButton *)sender {
    
    [self.remoteDao remoteTVWithKey:KEYCODE_MENU finishBlock:nil];
}
//返回
- (IBAction)TVBackBtnClick:(UIButton *)sender {
    [self.remoteDao remoteTVWithKey:KEYCODE_ESCAPE finishBlock:nil];
}
//音量+
- (IBAction)TVVolumeAddBtnClick:(UIButton *)sender {
    [self.remoteDao remoteTVWithKey:KEYCODE_VOLUME_UP finishBlock:nil];
}
//截屏
- (IBAction)TVScreenShotBtnClick:(UIButton *)sender {
//    [self.remoteDao remoteTVWithKey:KEYCODE_VOLUME_UP];
}
//音量-
- (IBAction)TVVolumeMinusBtnClick:(UIButton *)sender {
    [self.remoteDao remoteTVWithKey:KEYCODE_VOLUME_DOWN finishBlock:nil];
}
//返回
-(void)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 懒加载
-(HMDTVRemoteDao *)remoteDao{
    if (_remoteDao == nil) {
        _remoteDao = [[HMDTVRemoteDao alloc]init];
    }
    return _remoteDao;
}
@end
