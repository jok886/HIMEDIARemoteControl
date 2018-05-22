//
//  HMDRegisterViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDRegisterViewController.h"
#import "HMDRegisterDao.h"
@interface HMDRegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;//登录按钮
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;//账号输入
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;//密码输入
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;//验证码
@property (nonatomic,strong) HMDRegisterDao *registerDao;
@property (weak, nonatomic) IBOutlet UIButton *dynamicCodeBtn;
/** 定时器 */
@property (nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet HMDMainLoadingView *loadingView;

@end

@implementation HMDRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [HMDLinkView sharedInstance].hidden = NO;
    [self endTimer];
}
#pragma mark - 初始化
-(void)setupUI{
    self.title = @"手机号注册";
    [self setupFirstNavBar];
}
#pragma mark - 点击
//获取验证码
- (IBAction)getVerificationCode:(id)sender {
    //判断手机号码位数
    NSString *phoneNum = self.phoneNumTextField.text;
    if ([HMDPredicate checkTelNumber:phoneNum]) {
//        HMDWeakSelf(self)
        [self.registerDao getDynamicCodeForRegister:phoneNum finishBlock:^(NSInteger status) {
//            [weakSelf endTimer];
            switch (status) {
                case 202:
                    [HMDProgressHub showMessage:@"手机号已注册" hideAfter:2.0];

                    break;
                default:
                    break;
            }
        }];
        [self startTimer];
    }else{
        [HMDProgressHub showMessage:@"请输入正确的手机号码" hideAfter:2.0];
    }
    
}
//注册
- (IBAction)registerUserID:(id)sender {
    NSString *phoneNum = self.phoneNumTextField.text;
    NSString *pwd = self.pwdTextField.text;
    if (![HMDPredicate checkTelNumber:phoneNum]) {
        [HMDProgressHub showMessage:@"请输入正确的手机号" hideAfter:2.0];
    }else if (![HMDPredicate checkPassword:pwd]){
        [HMDProgressHub showMessage:@"密码必须为6-18位数字或字母" hideAfter:2.0];
    }else if (self.verificationCodeTextField.text.length <6){
        [HMDProgressHub showMessage:@"验证码错误" hideAfter:2.0];
    }else{
        [self.loadingView startLoading];
        HMDWeakSelf(self)
        [self.registerDao registerPhone:self.phoneNumTextField.text dynamicCode:self.verificationCodeTextField.text password:self.pwdTextField.text finishBlock:^(NSInteger status) {
            [weakSelf.loadingView endLoading];
            switch (status) {
                case 200:
                    [weakSelf dismissAction:nil];
                    break;
                case 203:
                    [HMDProgressHub showMessage:@"验证码错误或过期" hideAfter:2.0];
                    break;
                default:
                    break;
            }
        }];
    }

}

//显示隐藏密码
- (IBAction)changepwdVisiable:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwdTextField.secureTextEntry = sender.selected;
}

//用户协议
- (IBAction)seeUserAgreements:(id)sender {
    
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField == self.phoneNumTextField) {
//        if ([self.phoneNumTextField.text isEqualToString:@""]||self.phoneNumTextField.text==nil) {
//            [HMDProgressHub showMessage:@"手机号不能为空" hideAfter:2.0];
//        }else if (![HMDPredicate checkTelNumber:self.phoneNumTextField.text]) {
//            [HMDProgressHub showMessage:@"请输入正确的手机号" hideAfter:2.0];
//        }
//    }
//    if (textField == self.pwdTextField) {
//        NSString *pwd = self.pwdTextField.text;
//        if ([pwd isEqualToString:@""]||pwd==nil){
//            [HMDProgressHub showMessage:@"密码不能为空" hideAfter:2.0];
//        }else if (![HMDPredicate checkPassword:pwd]){
//            [HMDProgressHub showMessage:@"密码必须为6-18位数字或字母" hideAfter:2.0];
//        }
//    }
//    if ([HMDPredicate checkTelNumber:self.phoneNumTextField.text] && [HMDPredicate checkPassword:self.pwdTextField.text] && self.verificationCodeTextField.text.length >0) {
//        self.registerBtn.enabled = YES;
//    }else{
//        self.registerBtn.enabled = NO;
//    }
}

#pragma mark - 其他
-(void)startTimer{
    self.dynamicCodeBtn.enabled = NO;
    [self.dynamicCodeBtn setTitle:@"59s后重新获取" forState:UIControlStateDisabled];
    self.timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(countDown:) userInfo:[NSDate date] repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//倒计时
-(void)countDown:(NSTimer *)timer{
    NSDate *curDate = timer.fireDate;
    NSDate *startDate = timer.userInfo;
   NSTimeInterval timeInterval = [curDate timeIntervalSinceDate:startDate];
    NSInteger showTime = 60-timeInterval;
    if (showTime<=0) {
        [self endTimer];

    }else{
        NSString *showString = [NSString stringWithFormat:@"%lds后重新获取",showTime];
        [self.dynamicCodeBtn setTitle:showString forState:UIControlStateDisabled];
    }


}
-(void)endTimer{
    self.dynamicCodeBtn.enabled = YES;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark - 懒加载
-(HMDRegisterDao *)registerDao{
    if (_registerDao == nil) {
        _registerDao = [[HMDRegisterDao alloc] init];
    }
    return _registerDao;
}

@end
