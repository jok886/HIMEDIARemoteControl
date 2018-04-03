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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    HMDLog(@"-[%@ dealloc]",[self class]);
}

@end
