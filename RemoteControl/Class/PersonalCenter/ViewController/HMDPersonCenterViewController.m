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
@interface HMDPersonCenterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;

@end

@implementation HMDPersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -初始化
-(void)setupUI{
    [self setupNavigation];
    //判断是否安装了微信
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
//        [self.signInBtn setTitle:@"  微信登录" forState:UIControlStateNormal];
//    }else{
//        [self.signInBtn setTitle:@"  手机登录" forState:UIControlStateNormal];
//    }
    if ([WXApi isWXAppInstalled]) {
        [self.signInBtn setTitle:@"  微信登录" forState:UIControlStateNormal];
    }else{
        [self.signInBtn setTitle:@"  手机登录" forState:UIControlStateNormal];
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
    
}

@end
