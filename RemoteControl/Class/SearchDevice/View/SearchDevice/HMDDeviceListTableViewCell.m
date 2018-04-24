//
//  HMDDeviceListTableViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/8.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDDeviceListTableViewCell.h"

@interface HMDDeviceListTableViewCell()
@property (nonatomic,strong) HMDDeviceModel *deviceModel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *deviceIPLab;
@property (weak, nonatomic) IBOutlet UIImageView *deviceLinkStateImageView;

@end

@implementation HMDDeviceListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupUIWithDeviceModel:(HMDDeviceModel *)deviceModel{
    self.deviceModel = deviceModel;
    self.deviceNameLab.text = deviceModel.friendlyName;
    self.deviceIPLab.text = deviceModel.ip;
}

@end
