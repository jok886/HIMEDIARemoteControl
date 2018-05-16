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


@interface HMDLoginView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *loginShowView;//展示界面

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;//登录按钮
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;//账号输入
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;//密码输入
@property (weak, nonatomic) IBOutlet UIView *otherLoginView;        //第三方登录
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewHConstraint;
@property (weak, nonatomic) IBOutlet UIButton *weChatLoginBtn;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLogin:) name:HMDWechatLogin object:nil];
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
    if (self.phoneNumTextField.text.length != 11 && self.pwdTextField.text.length >= 6) {
        self.loginBtn.enabled = YES;
    }else{
        self.loginBtn.enabled = NO;
    }
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
    if ([self.phoneNumTextField.text isEqualToString:@""]||self.phoneNumTextField.text==nil) {
        [HMDProgressHub showMessage:@"手机号不能为空" hideAfter:2.0];
    }else if (self.phoneNumTextField.text.length != 11) {
        [HMDProgressHub showMessage:@"请输入正确的手机号" hideAfter:2.0];
    }else if ([self.pwdTextField.text isEqualToString:@""]||self.pwdTextField.text==nil){
        [HMDProgressHub showMessage:@"密码不能为空" hideAfter:2.0];
    }else if (self.pwdTextField.text.length < 6){
        [HMDProgressHub showMessage:@"密码必须大于6位" hideAfter:2.0];
    }else{
        //登录
    }
}
//是否显示密码
- (IBAction)pwdVisiable:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwdTextField.secureTextEntry = sender.selected;
    
}

//忘记密码
- (IBAction)forgetPassword:(id)sender {
    
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
    }
}
@end
