//
//  HMDTipNotificationManager.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDTipNotificationManager.h"

#define kNOTIFICATION_VIEW_HEIGHT 65

@interface HMDTipNotificationManager()
@property (nonatomic,readonly,getter=isShowing) BOOL showing;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *tipImageView;
@property (nonatomic,strong) UIView  *backgroundView;
@end

@implementation HMDTipNotificationManager

- (instancetype)init{
    if (self  = [super init]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.textColor = [UIColor whiteColor];
        
        self.textFont =[UIFont fontWithName:@"PingFang-SC-Regular" size:(14.0)];
        self.delaySeconds = 1.0f;
        [self.backgroundView addSubview:self.titleLabel];
        [self.backgroundView addSubview:self.tipImageView];
        
        UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNotification)];
        [self.backgroundView addGestureRecognizer:dismissTap];
    }
    return self;
}

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
+ (void)setOptions:(NSDictionary *)options{
    if (!options) {
        return;
    }
    if (options[CN_BACKGROUND_COLOR_KEY]) {
        [HMDTipNotificationManager shareManager].backgroundColor = options[CN_BACKGROUND_COLOR_KEY];
    }
    if (options[CN_TEXT_COLOR_KEY]) {
        [HMDTipNotificationManager shareManager].textColor = options[CN_TEXT_COLOR_KEY];
    }
    if (options[CN_TEXT_FONT_KEY]) {
        [HMDTipNotificationManager shareManager].textFont = options[CN_TEXT_FONT_KEY];
    }
    if (options[CN_DELAY_SECOND_KEY]){
        [HMDTipNotificationManager shareManager].delaySeconds = [options[CN_DELAY_SECOND_KEY] floatValue];
    }
}

+ (void)showMessage:(NSString *)message{
    
    [HMDTipNotificationManager showMessage:message withOptions:nil completeBlock:nil];
}

+(void)showMessage:(NSString *)message color:(UIColor *)color{
    [HMDTipNotificationManager showMessage:message withOptions:@{CN_TEXT_COLOR_KEY:HMDColorFromValue(WHITE),CN_BACKGROUND_COLOR_KEY:color}];
}

+(void)showMessage:(NSString *)message color:(UIColor *)color completeBlock:(CNCompleteBlock)completeBlock{
    [HMDTipNotificationManager showMessage:message withOptions:@{CN_TEXT_COLOR_KEY:HMDColorFromValue(WHITE),CN_BACKGROUND_COLOR_KEY:color} completeBlock:completeBlock];
}

+ (void)showMessage:(NSString *)message withOptions:(NSDictionary *)options{
    
    [HMDTipNotificationManager showMessage:message withOptions:options completeBlock:nil];
    
}

+ (void)showMessage:(NSString *)message withOptions:(NSDictionary *)options completeBlock:(CNCompleteBlock)completeBlock{
    [HMDTipNotificationManager shareManager].completeBlock = completeBlock;
    [HMDTipNotificationManager setOptions:options];
    if ([[HMDTipNotificationManager shareManager] isShowing]) {
        [[HMDTipNotificationManager shareManager] reDisplayTitleLabel:message];
    }else{
        [[HMDTipNotificationManager shareManager] showNotification:message];
    }
}


#pragma mark - Public Methods
/**
 *  重新设置titleLabel backgroundView 背景等
 *
 *  @param message 需要显示的message
 */
- (void)setupViewOptionsWithMessage:(NSString *)message{
    self.backgroundView.backgroundColor = self.backgroundColor;
    self.titleLabel.textColor = self.textColor;
    self.titleLabel.font = self.textFont;
    self.titleLabel.text = message;
    if ([self.backgroundColor isEqual:WARNNING_COLOR]) {
        self.tipImageView.image = [UIImage imageNamed:@"warning"];
    }else if ([self.backgroundColor isEqual:TIP_COLOR]){
        self.tipImageView.image = [UIImage imageNamed:@"tips"];
    }else{
        self.tipImageView.image = [UIImage imageNamed:@"share_success"];
    }
}


/**
 *  显示一条消息通知
 *
 *  @param message 需要显示的信息
 */
- (void)showNotification:(NSString *)message{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissNotification) object:nil];
    self.backgroundView.frame = CGRectMake(0, -kNOTIFICATION_VIEW_HEIGHT, self.backgroundView.frame.size.width, kNOTIFICATION_VIEW_HEIGHT);
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.backgroundView];
    [self setupViewOptionsWithMessage:message];
    [self resizeTitleLabelFrame];
    [self resizeTitleImgFrame];
    [UIView animateWithDuration:.5 animations:^{
        self.backgroundView.frame = CGRectMake(0, 0, self.backgroundView.frame.size.width, kNOTIFICATION_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(dismissNotification) withObject:nil afterDelay:self.delaySeconds];
    }];
}

#pragma mark - Private Methods

/**
 *  当消息通知已经显示时  重新显示titleLabel
 *
 *  @param message 需要显示的消息
 */
- (void)reDisplayTitleLabel:(NSString *)message{
    //取消之前通知隐藏notification
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissNotification) object:nil];
    [UIView animateWithDuration:.2 animations:^{
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, kNOTIFICATION_VIEW_HEIGHT + 10, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    } completion:^(BOOL finished) {
        [self setupViewOptionsWithMessage:message];
        [self resizeTitleLabelFrame];
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, -10, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        [UIView animateWithDuration:.1 animations:^{
            [self resizeTitleLabelFrame];
        } completion:^(BOOL finished) {
            //重新定义调用延迟隐藏notification
            [self performSelector:@selector(dismissNotification) withObject:nil afterDelay:self.delaySeconds];
        }];
    }];
}

- (void)resizeTitleLabelFrame{
    
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size = [self.titleLabel sizeThatFits:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 40, 36)];
    titleFrame.origin = CGPointMake(45, self.backgroundView.frame.size.height/2 - titleFrame.size.height/2 + 5);
    self.titleLabel.frame = titleFrame;
}

- (void)resizeTitleImgFrame{
    
    CGRect imgFrame = self.tipImageView.frame;
    imgFrame.size = [self.tipImageView sizeThatFits:CGSizeMake(16, 14)];
    imgFrame.origin = CGPointMake(20, self.backgroundView.frame.size.height/2 - imgFrame.size.height/2 + 5);
    self.tipImageView.frame = imgFrame;
}

/**
 *  隐藏通知
 */
- (void)dismissNotification{
    if (!self.showing) {
        return;
    }
    [UIView animateWithDuration:.5 animations:^{
        self.backgroundView.frame = CGRectMake(0, -kNOTIFICATION_VIEW_HEIGHT, self.backgroundView.frame.size.width, kNOTIFICATION_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        if (self.completeBlock) {
            self.completeBlock();
            self.completeBlock = nil;
        }
    }];
}

#pragma mark - getters & setters
- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -kNOTIFICATION_VIEW_HEIGHT, [[UIScreen mainScreen] bounds].size.width, kNOTIFICATION_VIEW_HEIGHT)];
        _backgroundView.clipsToBounds = YES;
    }
    return _backgroundView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIImageView *)tipImageView
{
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _tipImageView;
}

- (BOOL)isShowing{
    return self.backgroundView && self.backgroundView.superview;
}

@end
