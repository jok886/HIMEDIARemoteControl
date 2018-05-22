//
//  HMDMainLoadingView.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/16.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDMainLoadingView.h"
#import "UIImageView+HMDAnimation.h"
@interface HMDMainLoadingView()
@property (nonatomic,weak) UIImageView *loadingImageView;
@end
@implementation HMDMainLoadingView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.loadingImageView.center =CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
}
-(void)setupUI{
    UIImageView *loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:loadingImageView];
    self.loadingImageView = loadingImageView;
    loadingImageView.image = [UIImage imageNamed:@"loading_l_green"];
}

-(void)startLoading{
    self.hidden = NO;
    [self.loadingImageView startRotationAnimation];
}

-(void)endLoading{
    self.hidden = YES;
    [self.loadingImageView stopRotationAnimaton];
}
@end
