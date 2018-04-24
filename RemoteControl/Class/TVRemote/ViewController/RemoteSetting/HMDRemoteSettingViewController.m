//
//  HMDRemoteSettingViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/10.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDRemoteSettingViewController.h"

@interface HMDRemoteSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sideKeyControlBtn;
@property (weak, nonatomic) IBOutlet UIButton *shockBtn;

@end

@implementation HMDRemoteSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 初始化
-(void)setupUI{
    BOOL openSideKey = [[NSUserDefaults standardUserDefaults] boolForKey:OPENSIDEKEY];
    self.sideKeyControlBtn.selected = openSideKey;
    BOOL openShock = [[NSUserDefaults standardUserDefaults] boolForKey:OPENSHOCK];
    self.shockBtn.selected = openShock;
}
#pragma mark - 按键
//是否打开侧键控制
- (IBAction)switchVolumControl:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:OPENSIDEKEY];
}
- (IBAction)changeShock:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:OPENSHOCK];
}

@end
