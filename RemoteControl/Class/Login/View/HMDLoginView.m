//
//  HMDLoginView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/11.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDLoginView.h"

#import "WXApi.h"

#import "HMDRegisterViewController.h"
#import "HMDRecoveredPWDViewController.h"

#import "HMDLoginDao.h"
#import "HMDUserModel.h"
#import "EncryptionTools.h"
@interface HMDLoginView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *loginShowView;//展示界面

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;//登录按钮
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;//账号输入
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;//密码输入
@property (weak, nonatomic) IBOutlet UIView *otherLoginView;        //第三方登录
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewHConstraint;
@property (weak, nonatomic) IBOutlet UIButton *weChatLoginBtn;
@property (nonatomic,strong) HMDLoginDao *loginDao;
@end

@implementation HMDLoginView
static NSString * const loginAnimationKey = @"loginAnimationKey";

-(void)awakeFromNib{
    [super awakeFromNib];
    //判断是否有微信
    if ([WXApi isWXAppInstalled]) {
        self.otherLoginView.hidden = NO;
        [self addNotification];
    }else{
        self.otherLoginView.hidden = YES;
        self.loginViewHConstraint.constant = 238;
    }
}
//登录通知
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLogin:) name:HMDLogin object:nil];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
//    NSString *phoneNum = self.phoneNumTextField.text;
//    NSString *pwd = self.pwdTextField.text;
//    if (textField == self.phoneNumTextField) {
//        if ([phoneNum isEqualToString:@""]||phoneNum==nil) {
//            [HMDProgressHub showMessage:@"手机号不能为空" hideAfter:2.0];
//        }else if (![HMDPredicate checkTelNumber:phoneNum]) {
//            [HMDProgressHub showMessage:@"请输入正确的手机号" hideAfter:2.0];
//        }
//    }
//    if (textField == self.pwdTextField) {
//        if ([pwd isEqualToString:@""]||pwd==nil){
//            [HMDProgressHub showMessage:@"密码不能为空" hideAfter:2.0];
//        }else if (pwd.length < 6){
//            [HMDProgressHub showMessage:@"密码必须大于6位" hideAfter:2.0];
//        }
//    }
//    if ([HMDPredicate checkTelNumber:phoneNum] && pwd.length >= 6) {
//        self.loginBtn.enabled = YES;
//    }else{
//        self.loginBtn.enabled = NO;
//    }
}

#pragma mark - 点击
//注册
- (IBAction)registerBtnClick:(id)sender {
    HMDRegisterViewController *registerVC = [[HMDRegisterViewController alloc] init];
    HMDNavigationController *nav = [[HMDNavigationController alloc] initWithRootViewController:registerVC];
    [self.getCurActiveViewController presentViewController:nav animated:YES completion:nil];
    [self removeFromSuperview];
}

//登录
- (IBAction)loginBtnClick:(id)sender {

    NSString *phoneNum = self.phoneNumTextField.text;
    NSString *pwd = self.pwdTextField.text;
    if ([phoneNum isEqualToString:@""]||phoneNum==nil) {
        [HMDProgressHub showMessage:@"手机号不能为空" hideAfter:2.0];
    }else if (![HMDPredicate checkTelNumber:phoneNum]) {
        [HMDProgressHub showMessage:@"请输入正确的手机号" hideAfter:2.0];
    }else if ([pwd isEqualToString:@""]||pwd==nil){
        [HMDProgressHub showMessage:@"密码不能为空" hideAfter:2.0];
    }else if (![HMDPredicate checkPassword:pwd]){
        [HMDProgressHub showMessage:@"密码必须大于6位" hideAfter:2.0];
    }else{
        //登录
        [self startLoginAnimation];
        HMDWeakSelf(self)
        [self.loginDao loginWithPhoneNum:phoneNum passWord:pwd finishBlock:^(BOOL success, HMDUserModel *userModel) {
            [weakSelf stopLoginAnimaton];
            if (success) {
                 NSString *encryptRefresh_token = [EncryptionTools encryptAESWithHINAVI:pwd];
                [[NSUserDefaults standardUserDefaults] setObject:HMDLoginPhoneModel forKey:HMDLoginModel];
                [[NSUserDefaults standardUserDefaults] setObject:encryptRefresh_token forKey:HMDLoginRefreshToken];
                [[NSUserDefaults standardUserDefaults] setObject:phoneNum forKey:HMDLoginPhoneNum];
                [[NSUserDefaults standardUserDefaults] setObject:userModel.hid forKey:WXCurHID];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:HMDLogin object:userModel];
            }else{
                if (userModel) {
                    switch ([userModel.status integerValue]) {
                        case 201:
                            [HMDProgressHub showMessage:@"手机号未注册" hideAfter:2.0];
                            break;
                        case 204:
                            [HMDProgressHub showMessage:@"密码错误" hideAfter:2.0];
                            break;
                        default:
                            break;
                    }
                }else{
                    [HMDProgressHub showMessage:@"网络异常,登录失败" hideAfter:2.0];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:HMDLogin object:nil];
            }
        }];
    }
}
//是否显示密码
- (IBAction)pwdVisiable:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwdTextField.secureTextEntry = sender.selected;
    
}

//忘记密码
- (IBAction)forgetPassword:(id)sender {
    HMDRecoveredPWDViewController *recoveredPWDVC = [[HMDRecoveredPWDViewController alloc] init];
    HMDNavigationController *nav = [[HMDNavigationController alloc] initWithRootViewController:recoveredPWDVC];
    [self.getCurActiveViewController presentViewController:nav animated:YES completion:nil];
    [self removeFromSuperview];
}
//微信登录
- (IBAction)loginWithWeChat:(UIButton *)sender {
    [self startLoginAnimation];
    sender.userInteractionEnabled = NO;
    SendAuthReq *req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"wx_oauth2_authorization_state" ;
    [WXApi sendReq:req];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取当前手指的点
    CGPoint curP = [self getCurPoint:touches];
    if (CGRectContainsPoint(self.loginShowView.frame, curP)) {

    }else{
        [self removeFromSuperview];
        [HMDLinkView sharedInstance].hidden = NO;
    }
    
}
#pragma mark - 动画
//动画
-(void)startLoginAnimation{
    self.loginBtn.selected = YES;
    if ([[self.loginBtn.imageView.layer animationKeys] containsObject:loginAnimationKey]) {
        return;
    }else{
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
        rotationAnimation.duration = 1.0f;
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.removedOnCompletion = NO;
        [self.loginBtn.imageView.layer addAnimation:rotationAnimation forKey:loginAnimationKey];
    }
    
}

-(void)stopLoginAnimaton{
    self.loginBtn.selected = NO;
    if ([[self.loginBtn.imageView.layer animationKeys] containsObject:loginAnimationKey]) {
        [self.loginBtn.imageView.layer removeAnimationForKey:loginAnimationKey];
    }
}

#pragma mark - 其他
//获取当前手指的点
- (CGPoint)getCurPoint:(NSSet *)touches {
    //获取当前手指的点
    UITouch *touch = [touches anyObject];
    CGPoint curP =  [touch locationInView:self];
    return curP;
}

-(void)wechatLogin:(NSNotification *)info{
    [self stopLoginAnimaton];
    if (info.object == nil) {
        self.weChatLoginBtn.userInteractionEnabled = YES;
        [HMDProgressHub showMessage:@"登录失败" hideAfter:2.0];
    }else{
        [self removeFromSuperview];
        [HMDLinkView sharedInstance].hidden = NO;
    }
}

#pragma mark - 懒加载
-(HMDLoginDao *)loginDao{
    if (_loginDao == nil) {
        _loginDao = [[HMDLoginDao alloc] init];
    }
    return _loginDao;
}
@end
