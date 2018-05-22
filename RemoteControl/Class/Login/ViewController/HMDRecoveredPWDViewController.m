//
//  HMDRecoveredPWDViewController.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/21.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDRecoveredPWDViewController.h"

#import "HMDRegisterDao.h"
#import "EncryptionTools.h"
@interface HMDRecoveredPWDViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;//账号输入
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;//密码输入
@property (weak, nonatomic) IBOutlet UITextField *makesurePWDTextField;//密码输入二次确认
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;//验证码
@property (nonatomic,strong) HMDRegisterDao *registerDao;
@property (weak, nonatomic) IBOutlet UIButton *dynamicCodeBtn;
/** 定时器 */
@property (nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet HMDMainLoadingView *loadingView;
@property (weak, nonatomic) IBOutlet UIButton *makesureBtn;

@end

@implementation HMDRecoveredPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    if (!self.resetPWD) {
        [HMDLinkView sharedInstance].hidden = NO;
    }
    [self endTimer];
}
#pragma mark - 初始化
-(void)setupUI{
    if (self.resetPWD) {
        self.title = @"修改密码";
    }else{
        self.title = @"忘记密码";
        [self setupFirstNavBar];
    }

}
#pragma mark - 点击
//获取验证码
- (IBAction)getVerificationCode:(id)sender {
    //判断手机号码位数
    NSString *phoneNum = self.phoneNumTextField.text;
    if ([HMDPredicate checkTelNumber:phoneNum]) {
//        HMDWeakSelf(self)
        [self.registerDao getDynamicCodeForForgetPWD:phoneNum finishBlock:^(NSInteger status) {
//            [weakSelf endTimer];
            switch (status) {
                case 202:
                    [HMDProgressHub showMessage:@"手机号已注册" hideAfter:2.0];

                    break;
                case 201:
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
- (IBAction)changepwdVisiable:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwdTextField.secureTextEntry = sender.selected;
}
- (IBAction)changeMakesurepwdVisiable:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.makesurePWDTextField.secureTextEntry = sender.selected;
}
//确定

- (IBAction)recoverPWD:(id)sender {
    //先判断
    NSString *phoneNum = self.phoneNumTextField.text;
    NSString *pwd = self.pwdTextField.text;
    if (![HMDPredicate checkTelNumber:phoneNum]) {
        [HMDProgressHub showMessage:@"请输入正确的手机号" hideAfter:2.0];
    }else if (![HMDPredicate checkPassword:pwd]){
        [HMDProgressHub showMessage:@"密码必须为6-18位数字或字母" hideAfter:2.0];
    }else if (self.verificationCodeTextField.text.length <6){
        [HMDProgressHub showMessage:@"验证码错误" hideAfter:2.0];
    }else if (![pwd isEqualToString:self.makesurePWDTextField.text]){
         [HMDProgressHub showMessage:@"两次输入的密码不一致" hideAfter:2.0];
    } else{
        
        [self.loadingView startLoading];
        HMDWeakSelf(self)
        [self.registerDao recoverPWDWithPhone:self.phoneNumTextField.text dynamicCode:self.verificationCodeTextField.text password:self.pwdTextField.text finishBlock:^(NSInteger status) {
            [weakSelf.loadingView endLoading];
            switch (status) {
                case 200:
                    {
                        if (weakSelf.resetPWD) {
                            NSString *encryptRefresh_token = [EncryptionTools encryptAESWithHINAVI:pwd];
                            [[NSUserDefaults standardUserDefaults] setObject:encryptRefresh_token forKey:HMDLoginRefreshToken];
                        }
                        [HMDProgressHub showMessage:@"修改成功" hideAfter:2.0];
                        
                        [weakSelf dismissAction:nil];
                    
                    }
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
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
