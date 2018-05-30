//
//  HMDLocationVideoCollectionViewCell.m
//  RemoteControl
//
//  Created by 林鸿键 on 2018/5/29.
//  Copyright © 2018年 HIMEDIA. All rights reserved.
//

#import "HMDLocationVideoCollectionViewCell.h"
#import "HMDLocationVideoModel.h"
#import <Photos/Photos.h>
@interface HMDLocationVideoCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLab;
@property (nonatomic, strong) HMDLocationVideoModel *videoModel;
@end
@implementation HMDLocationVideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setupCellWithLocationVideoModel:(HMDLocationVideoModel *)videoModel{
    _videoModel = videoModel;
    self.videoImageView.image = [UIImage imageNamed:@"video_banner_default_s"];
    if (videoModel.assetImage == nil) {
        HMDWeakSelf(self)
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = YES;
        options.version = PHImageRequestOptionsVersionCurrent;
        
        [[PHImageManager defaultManager] requestImageForAsset:videoModel.asset targetSize:CGSizeMake(videoModel.asset.pixelWidth/10.0, videoModel.asset.pixelHeight/10.0) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            UIImage *image = result;
            weakSelf.videoImageView.image = image;
            if (weakSelf.videoModel.assetImage==nil) {
                weakSelf.videoModel.assetImage = image;
            }
        }];
    }else{
        self.videoImageView.image = videoModel.assetImage;
    }
    self.videoTitleLab.text = videoModel.assetTitle;
}
@end

