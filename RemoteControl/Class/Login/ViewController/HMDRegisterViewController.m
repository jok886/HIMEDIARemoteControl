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
    if (phoneNum.length == 11) {
        [self.registerDao getDynamicCodeForRegister:phoneNum];
    }else{
        [HMDProgressHub showMessage:@"请输入正确的手机号码" hideAfter:2.0];
    }
    
}
//注册
- (IBAction)registerUserID:(id)sender {
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
    if (textField == self.phoneNumTextField) {
        if ([self.phoneNumTextField.text isEqualToString:@""]||self.phoneNumTextField.text==nil) {
            [HMDProgressHub showMessage:@"手机号不能为空" hideAfter:2.0];
        }else if (self.phoneNumTextField.text.length != 11) {
            [HMDProgressHub showMessage:@"请输入正确的手机号" hideAfter:2.0];
        }
    }
    if (textField == self.pwdTextField) {
        if ([self.pwdTextField.text isEqualToString:@""]||self.pwdTextField.text==nil){
            [HMDProgressHub showMessage:@"密码不能为空" hideAfter:2.0];
        }else if (self.pwdTextField.text.length < 6){
            [HMDProgressHub showMessage:@"密码必须大于6位" hideAfter:2.0];
        }
    }
    if (self.phoneNumTextField.text.length != 11 && self.pwdTextField.text.length >= 6 && self.verificationCodeTextField.text.length >0) {
        self.registerBtn.enabled = YES;
    }else{
        self.registerBtn.enabled = NO;
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
