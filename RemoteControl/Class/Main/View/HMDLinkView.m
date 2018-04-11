//
//  HMDLinkView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/9.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDLinkView.h"
#import "UIView+Additions.h"

@interface HMDLinkView()
@property (weak, nonatomic) UIButton *linkStateBtn;
@property (weak, nonatomic) UILabel *linkStateLab;
@property (weak, nonatomic) UIButton *linkBtn;

@end
@implementation HMDLinkView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIButton *linkStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    linkStateBtn.frame = CGRectMake(15, 15, 30, 30);
    [linkStateBtn setImage:[UIImage imageNamed:@"link-off"] forState:UIControlStateNormal];
    [linkStateBtn setImage:[UIImage imageNamed:@"link-on"] forState:UIControlStateSelected];
    [linkStateBtn addTarget:self action:@selector(linkStateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.linkStateBtn = linkStateBtn;
    [self addSubview:linkStateBtn];
    
    UIButton *linkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    linkBtn.frame = CGRectMake(HMDScreenW-45, 15, 30, 60);
    [linkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [linkBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [linkBtn setTitle:@"搜索设备" forState:UIControlStateNormal];
    [linkBtn setTitle:@"进入遥控器" forState:UIControlStateSelected];
    [linkBtn addTarget:self action:@selector(linkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [linkBtn sizeToFit];
    CGRect linkBtnFrame = linkBtn.frame;
    CGPoint center = CGPointMake(30, 30);
    center.x = HMDScreenW - CGRectGetWidth(linkBtnFrame)*0.5-20;
    linkBtn.center = center;
    self.linkBtn = linkBtn;
    [self addSubview:linkBtn];
    
    UILabel *linkStateLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 100, 100)];
    [linkStateLab setTextColor:[UIColor blackColor]];
    linkStateLab.text = @"设备未链接";
    linkStateLab.font = [UIFont systemFontOfSize:14];
    [linkStateLab sizeToFit];
    CGRect linkStateLabFrame = linkStateLab.frame;
    center.x = 60 + CGRectGetWidth(linkStateLabFrame)*0.5;
    linkStateLab.center = center;
    self.linkStateLab = linkStateLab;
    [self addSubview:linkStateLab];
    
}

-(void)linkBtnClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LinkView:linkBtnClick:withViewController:)]) {
        [self.delegate LinkView:self linkBtnClick:btn.selected withViewController:[self currentViewController]];
    }
}
-(void)linkStateBtnClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LinkView:linkOffBtnClickWithViewController:)]) {
        [self.delegate LinkView:self linkOffBtnClickWithViewController:[self currentViewController]];
    }
}
-(void)switchLinkState:(BOOL)link ip:(NSString *)ip{
    self.linkBtn.selected = link;
    
    NSString *linkText = @"设备未链接";
    if (link) {
        self.linkStateBtn.enabled = YES;
        linkText = [NSString stringWithFormat:@"已链接:%@",ip];
        //链接成功将此次的记录,下次登录时直连
        [[NSUserDefaults standardUserDefaults] setObject:ip forKey:DLANLINKIP];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        self.linkStateBtn.enabled = NO;
    }
    self.linkStateBtn.selected = link;
    self.linkStateLab.text = linkText;
    
    [self.linkBtn sizeToFit];
    CGRect linkBtnFrame = self.linkBtn.frame;
    CGPoint center = CGPointMake(30, 30);
    center.x = HMDScreenW - CGRectGetWidth(linkBtnFrame)*0.5-20;
    self.linkBtn.center = center;
    
    [self.linkStateLab sizeToFit];
    CGRect linkStateLabFrame = self.linkStateLab.frame;
    center.x = 60 + CGRectGetWidth(linkStateLabFrame)*0.5;
    self.linkStateLab.center = center;

}

- (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
@end
