//
//  HMDBaseViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/2.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDBaseViewController.h"
@interface HMDBaseViewController ()

@end

@implementation HMDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //自动移64关闭
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    HMDLog(@"-[%@ dealloc]",[self class]);
}
//统一第一个页面的返回
-(void)setupFirstNavBar{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_back_wbg"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_back_wbg"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

-(void)dismissAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
