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
//@property (weak, nonatomic) IBOutlet UILabel *apkDescribeLab;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;               //打开
@property (weak, nonatomic) IBOutlet UIButton *uninstallBtn;            //卸载

@property (nonatomic,strong) HMDAPKModel *apkModel;
@end
@implementation HMDAPPListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithAPKModel:(HMDAPKModel *)model{
    _apkModel = model;
    switch (model.apkStyle) {
        case HMDAPKInstallStyle:
        {
            self.apkNameLab.text = model.name;
            self.uninstallBtn.hidden = NO;
            NSString *imageURL = [NSString stringWithFormat:HMD_DLAN_APK_ICON,HMDCURLINKDEVICEIP];
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        model.package,@"package",
                                        nil];
            [self.actionBtn setTitle:@"打开" forState:UIControlStateNormal];
            [self.apkIconImageView setDLANImageWithMethod:@"POST" URLStr:imageURL parameters:parameters placeholderImage:[UIImage imageNamed:@"app_default"]];
        }

            break;
        case HMDAPKRecommendStyle:
        {
            self.uninstallBtn.hidden = YES;
            self.apkNameLab.text = model.name;
            switch ([model.installed integerValue]) {
                case 0:
                    [self.actionBtn setTitle:@"安装中" forState:UIControlStateNormal];
                    break;
                case 1:
                    [self.actionBtn setTitle:@"下载" forState:UIControlStateNormal];
                    break;
                case 2:
                    [self.actionBtn setTitle:@"打开" forState:UIControlStateNormal];
                    break;
                    
                default:
                    [self.actionBtn setTitle:@"未知状态" forState:UIControlStateNormal];
                    break;
            }
            [self.apkIconImageView setImageWithURLStr:model.img_url placeholderImage:[UIImage imageNamed:@"app_default"]];
        }
            break;
        default:
            break;
    }
    
}
- (IBAction)openBtnClick:(id)sender {
    if (self.actionBlock) {
        self.actionBlock(self.indexPath);
    }
}
- (IBAction)uninstallBtnClick:(id)sender {
    if (self.uninstallBlock) {
        self.uninstallBlock(self.indexPath);
    }
}

@end
