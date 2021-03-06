//
//  HMDSearchTVResultCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/25.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDSearchTVResultCell.h"
#import "UIImageView+HMDDLANLoadImage.h"
@interface HMDSearchTVResultCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@end
@implementation HMDSearchTVResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setupCellWithVideoModel:(HMDVideoModel *)videoModel{
    [self.iconImageView setImageWithURLStr:videoModel.img_url placeholderImage:[UIImage imageNamed:@"video_pic_default"]];
    self.titleLab.text = videoModel.title;

}
@end
