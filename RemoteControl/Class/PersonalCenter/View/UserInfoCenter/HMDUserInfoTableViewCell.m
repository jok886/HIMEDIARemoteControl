//
//  HMDUserInfoTableViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDUserInfoTableViewCell.h"
@interface HMDUserInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;


@end
@implementation HMDUserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellWithTitle:(NSString *)title subTitle:(NSString *)subTitle imageurl:(NSString *)imageurl{
    if (title) {
        self.leftLab.text = title;
    }else{
        self.leftLab.hidden = YES;
    }
    if (subTitle) {
        self.rightLab.text = subTitle;
    }else{
        self.rightLab.hidden = YES;
    }
    if (imageurl) {
        [self.iconImageView setImageWithURLStr:imageurl placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    }else{
        self.iconImageView.hidden = YES;
    }
}
@end
