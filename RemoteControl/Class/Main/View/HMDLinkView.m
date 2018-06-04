//
//  HMDLinkView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/9.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDLinkView.h"
#import "UIView+Additions.h"
#import "UIImageView+HMDAnimation.h"
@interface HMDLinkView()
@property (weak, nonatomic) UIButton *linkStateBtn;
@property (weak, nonatomic) UIButton *remoteBtn;

@end
@implementation HMDLinkView
+(HMDLinkView *)sharedInstance
{
    static HMDLinkView * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HMDLinkView alloc] init];
        
    });
    return instance;
}

//-(instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        [self setupUI];
//    }
//    return self;
//}

-(void)setupUI{
//    //增加渐变层
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = CGRectMake(0, -25, HMDScreenW, 25);
//    gradientLayer.colors = @[(id)HMDColor(240, 240, 240, 0).CGColor,(id)HMDColor(240, 240, 240, 1).CGColor];  // 设置渐变颜色
//    gradientLayer.startPoint = CGPointMake(0.5, 0);
//    gradientLayer.endPoint = CGPointMake(0.5, 1);
//    [self.layer addSublayer:gradientLayer];
    
    self.backgroundColor = [UIColor whiteColor];
    self.linkViewState = HMDLinkViewStateunLink;
    
    UIButton *linkStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    linkStateBtn.frame = CGRectMake(15, 15, 30, 30);
    //未链接状态
    linkStateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [linkStateBtn setImage:[UIImage imageNamed:@"status_unconnected"] forState:UIControlStateNormal];
    [linkStateBtn setTitle:@"  当前设备未链接,请点击重新连接" forState:UIControlStateNormal];
    [linkStateBtn setTitleColor:HMDTEXT_UNUSE_COLOR forState:UIControlStateNormal];
    //链接状态
    [linkStateBtn setImage:[UIImage imageNamed:@"status_connected"] forState:UIControlStateSelected];
    [linkStateBtn setTitleColor:HMDTEXT_COLOR forState:UIControlStateSelected];
    linkStateBtn.userInteractionEnabled = NO;
    [linkStateBtn sizeToFit];
    linkStateBtn.center = CGPointMake(CGRectGetWidth(self.bounds)*0.5, CGRectGetHeight(self.bounds)*0.5);
    [linkStateBtn addTarget:self action:@selector(linkStateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //连接中
    [linkStateBtn setImage:[UIImage imageNamed:@"loading_s_green"] forState:UIControlStateDisabled];
    [linkStateBtn setTitle:@"  自动连接中..." forState:UIControlStateDisabled];
    [linkStateBtn setTitleColor:HMDMAIN_COLOR forState:UIControlStateDisabled];
    linkStateBtn.userInteractionEnabled = NO;
    [linkStateBtn sizeToFit];
    linkStateBtn.center = CGPointMake(CGRectGetWidth(self.bounds)*0.5, CGRectGetHeight(self.bounds)*0.5);
    [linkStateBtn addTarget:self action:@selector(linkStateBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    self.linkStateBtn = linkStateBtn;
    [self addSubview:linkStateBtn];
    
    UIButton *remoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    remoteBtn.frame = CGRectMake(HMDScreenW-45, 15, 30, 60);
    remoteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [remoteBtn setTitleColor:HMDMAIN_COLOR forState:UIControlStateNormal];
    [remoteBtn setTitle:@"进入遥控器" forState:UIControlStateNormal];
    [remoteBtn addTarget:self action:@selector(remoteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [remoteBtn sizeToFit];
    CGRect remoteBtnFrame = remoteBtn.frame;
    CGPoint center =  CGPointMake(CGRectGetWidth(self.bounds)*0.5, CGRectGetHeight(self.bounds)*0.5);
    center.x = HMDScreenW - CGRectGetWidth(remoteBtnFrame)*0.5-20;
    remoteBtn.center = center;
    self.remoteBtn = remoteBtn;
    self.remoteBtn.hidden = YES;
    [self addSubview:remoteBtn];

}

-(void)remoteBtnClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LinkView:linkBtnClick:withViewController:)]) {
        [self.delegate LinkView:self remoteBtnClickWithViewController:self.getCurActiveViewController];
    }
}

-(void)linkStateBtnClick:(UIButton *)btn{
    if (self.linkViewState == HMDLinkViewStateLinked) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(LinkView:linkBtnClick:withViewController:)]) {
            [self.delegate LinkView:self linkBtnClick:self.linkViewState withViewController:self.getCurActiveViewController];
        }
    }
}


-(void)switchLinkState:(HMDLinkViewState)linkState ip:(NSString *)ip uuid:(NSString *)uuid{
    self.linkViewState = linkState;
    [self.linkStateBtn.imageView stopRotationAnimaton];
    NSString *linkText;
    switch (linkState) {
        case HMDLinkViewStateLinked:
            {
                self.linkStateBtn.enabled = YES;
                self.linkStateBtn.selected = YES;
                linkText = [NSString stringWithFormat:@"  已链接:%@",ip];
                //链接成功将此次的记录,下次登录时直连
                [[NSUserDefaults standardUserDefaults] setObject:ip forKey:DLANLINKIP];
                [[NSUserDefaults standardUserDefaults] setObject:ip forKey:DLANLastTimeLinkIP];
                [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:DLANLastTimeLinkDeviceUUID];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.linkStateBtn setTitle:linkText forState:UIControlStateSelected];
                self.remoteBtn.hidden = NO;
                [self.linkStateBtn sizeToFit];
                CGPoint center = self.linkStateBtn.center;
                center.x = CGRectGetWidth(self.linkStateBtn.frame)*0.5+15;
                self.linkStateBtn.center =center;
            }
            break;
        case HMDLinkViewStateunLink:
        {
            self.linkStateBtn.enabled = YES;
            self.linkStateBtn.selected = NO;
            self.remoteBtn.hidden = YES;
            [self.linkStateBtn setTitle:@"  当前设备未链接,请点击重新连接" forState:UIControlStateNormal];
            [self.linkStateBtn sizeToFit];
            self.linkStateBtn.center =  CGPointMake(CGRectGetWidth(self.bounds)*0.5, CGRectGetHeight(self.bounds)*0.5);
        }
            break;
        case HMDLinkViewStateLinking:
        {
            self.linkStateBtn.enabled = NO;
            self.remoteBtn.hidden = YES;
            [self.linkStateBtn sizeToFit];
            self.linkStateBtn.center =  CGPointMake(CGRectGetWidth(self.bounds)*0.5, CGRectGetHeight(self.bounds)*0.5);
            [self.linkStateBtn.imageView startRotationAnimation];
            
        }
            break;
        default:
            break;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.linkViewState == HMDLinkViewStateunLink) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(LinkView:linkBtnClick:withViewController:)]) {
            [self.delegate LinkView:self linkBtnClick:self.linkViewState withViewController:self.getCurActiveViewController];
        }
    }else if (self.linkViewState == HMDLinkViewStateLinked){
        //断开链接
        //获取当前手指的点
        CGPoint curP = [self getCurPoint:touches];
        if (CGRectContainsPoint(self.linkStateBtn.frame, curP)) {
            [self switchLinkState:HMDLinkViewStateunLink ip:nil uuid:nil];
            [HMDProgressHub showMessage:@"已与设备断开" hideAfter:2.0];
        }
    }
}

//获取当前手指的点
- (CGPoint)getCurPoint:(NSSet *)touches {
    //获取当前手指的点
    UITouch *touch = [touches anyObject];
    CGPoint curP =  [touch locationInView:self];
    return curP;
}

@end
