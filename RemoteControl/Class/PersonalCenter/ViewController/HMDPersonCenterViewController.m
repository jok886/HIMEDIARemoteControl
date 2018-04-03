//
//  HMDPersonCenterViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/2.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDPersonCenterViewController.h"
#import "HMDQRCodeScanViewController.h"

@interface HMDPersonCenterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;

@end

@implementation HMDPersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -初始化
-(void)setupUI{
    
    //判断是否安装了微信
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
        [self.signInBtn setTitle:@"  微信登录" forState:UIControlStateNormal];
    }else{
        [self.signInBtn setTitle:@"  手机登录" forState:UIControlStateNormal];
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
//    self.navigationController.navigationBar.hidden = NO;
    [self presentViewController:QRCodeVC animated:YES completion:nil];
//    [self.navigationController pushViewController:QRCodeVC animated:YES];
    
}

//登录
- (IBAction)singInBtnClick:(UIButton *)sender {
    
}

@end
