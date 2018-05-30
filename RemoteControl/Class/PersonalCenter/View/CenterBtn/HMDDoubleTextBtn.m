//
//  HMDDoubleTextBtn.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/14.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDDoubleTextBtn.h"
@interface HMDDoubleTextBtn()

@end
@implementation HMDDoubleTextBtn

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
-(void)setupUI{
    UILabel *subtitleLab = [[UILabel alloc] init];
    [self addSubview:subtitleLab];
    self.subtitleLab = subtitleLab;
    [self.subtitleLab setFont:[UIFont systemFontOfSize:12]];
    [self.subtitleLab setTextColor:HMDColorFromValue(0x999999)];
    
    [self.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.titleLabel setTextColor:HMDColorFromValue(0x333333)];
}
-(void)setButtonWithImage:(UIImage *)image mainTitle:(NSString *)mainTitle subtitle:(NSString *)subtitle{
    [self setImage:image forState:UIControlStateNormal];
    [self setTitle:mainTitle forState:UIControlStateNormal];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat centerY = self.imageView.center.y;
    CGRect mainTitleRect = self.titleLabel.frame;
    mainTitleRect.origin.y = centerY - mainTitleRect.size.height;
    self.titleLabel.frame = mainTitleRect;
    self.subtitleLab.text = self.subtitle;
    [self.subtitleLab sizeToFit];
    CGRect subTitleRect = self.subtitleLab.frame;
    subTitleRect.origin.x = mainTitleRect.origin.x+4;
    subTitleRect.origin.y = centerY+4;
    self.subtitleLab.frame = subTitleRect;
}
//-(void)setSubtitle:(NSString *)subtitle{
//
//    _subtitle = subtitle;
////    self.subtitleLab.text = subtitle;
//}

-(UILabel *)subtitleLab{
    if (_subtitleLab == nil) {
        UILabel *subtitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

        _subtitleLab = subtitleLab;
        [_subtitleLab setFont:[UIFont systemFontOfSize:12]];
        [_subtitleLab setTextColor:HMDColorFromValue(0x999999)];
                [self addSubview:subtitleLab];
    }
    return _subtitleLab;
}
-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.layer.borderColor = HMDMAIN_COLOR.CGColor;
        self.layer.borderWidth = 1;
    }else{
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
