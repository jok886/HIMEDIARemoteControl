//
//  HMDVideoShowCollectionViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/4/18.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDVideoShowCollectionViewCell.h"
#import "UIImageView+HMDDLANLoadImage.h"
#import "HMDVideoModel.h"
@interface HMDVideoShowCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *videoIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLab;

@end
@implementation HMDVideoShowCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setupCellWithVideoModel:(HMDVideoModel *)videoModel{

    [self.videoIconImageView setImageWithURLStr:videoModel.img_url placeholderImage:[UIImage imageNamed:@"search"]];
    self.synopsisLab.text = videoModel.info;

}
@end
