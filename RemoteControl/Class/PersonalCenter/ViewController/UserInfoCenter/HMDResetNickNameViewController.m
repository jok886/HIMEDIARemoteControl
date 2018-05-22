//
//  HMDResetNickNameViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/21.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDResetNickNameViewController.h"
#import "HMDMainLoadingView.h"
#import "AppDelegate.h"
#import "HMDUpUserInfoDao.h"
@interface HMDResetNickNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextF;
@property (weak, nonatomic) IBOutlet HMDMainLoadingView *loadingView;
@property (nonatomic,strong) HMDUpUserInfoDao *userInfoDao;
@end

@implementation HMDResetNickNameViewController

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
    self.title = @"编辑昵称";
}
#pragma mark - 点击

- (IBAction)saveNewNikeName:(id)sender {
    NSString *nickName = self.nickNameTextF.text;
    if (nickName.length < 4|| nickName.length >20) {
        [HMDProgressHub showMessage:@"昵称必须为4到20个字" hideAfter:2.0];
    }else{
        [self.loadingView startLoading];

        HMDWeakSelf(self)
        NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:HMDLoginPhoneNum];
        [self.userInfoDao updateNicknameWithPhone:phoneNum nickName:nickName finishBlock:^(NSInteger status) {
            [weakSelf.loadingView endLoading];
            switch (status) {
                case 200:
                {
                    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    HMDUserModel *userModel = myDelegate.userModel;
                    userModel.nickname = nickName;
                    [[NSNotificationCenter defaultCenter] postNotificationName:HMDLogin object:userModel];
                    [HMDProgressHub showMessage:@"修改成功" hideAfter:2.0];
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(resetNickNameViewController:resetNickName:)]) {
                        [weakSelf.delegate resetNickNameViewController:weakSelf resetNickName:nickName];
                    }
                }
                    break;
                default:
                    [HMDProgressHub showMessage:@"网络异常,稍后再试" hideAfter:2.0];
                    break;
            }
        }];
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 懒加载
-(HMDUpUserInfoDao *)userInfoDao{
    if (_userInfoDao == nil) {
        _userInfoDao = [[HMDUpUserInfoDao alloc] init];
    }
    return _userInfoDao;
}
@end
