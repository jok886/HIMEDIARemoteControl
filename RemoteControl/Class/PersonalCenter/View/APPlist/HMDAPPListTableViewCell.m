//
//  HMDAPPListTableViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/23.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDAPPListTableViewCell.h"
#import "UIImageView+HMDDLANLoadImage.h"

@interface HMDAPPListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *apkIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *apkNameLab;
@property (weak, nonatomic) IBOutlet UILabel *apkDescribeLab;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end
@implementation HMDAPPListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithAPKModel:(HMDAPKModel *)model{
    self.apkNameLab.text = model.name;
    self.apkDescribeLab.text = model.versionName;
    NSString *imageURL = [NSString stringWithFormat:HMD_DLAN_APK_ICON,HMDCURLINKDEVICEIP];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                model.package,@"package",
                                nil];
    [self.apkIconImageView setDLANImageWithMethod:@"POST" URLStr:imageURL parameters:parameters placeholderImage:nil];
}
@end
