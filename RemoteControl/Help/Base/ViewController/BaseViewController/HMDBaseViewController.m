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
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.view.backgroundColor = [UIColor whiteColor];
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
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_back_wbg"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_back_wbg"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 60, 40);
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

-(void)reSetupNavBarWithWhiteItem{
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 60, 40);
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
-(void)dismissAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)backAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
