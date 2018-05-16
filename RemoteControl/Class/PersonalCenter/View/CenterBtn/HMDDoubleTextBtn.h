//
//  HMDDoubleTextBtn.h
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/14.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDDoubleTextBtn : UIButton
@property (nonatomic,strong) NSString *subtitle;                //副标题
@property (nonatomic,weak) UILabel *subtitleLab;                //副标题
//-(void)setButtonWithImage:(UIImage *)image mainTitle:(NSString *)mainTitle subtitle:(NSString *)subtitle;
@end
